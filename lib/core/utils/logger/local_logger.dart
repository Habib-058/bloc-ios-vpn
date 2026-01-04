import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

typedef LogUploader =
    Future<bool> Function(
      File jsonFile, {
      required DateTime from,
      required DateTime to,
    });

/// Local file-based logger that only persists logs provided by the app.
/// - saveLog: append a single log record (Map or String) to a daily file
/// - sendLog: aggregate saved logs into a JSON file and send via [uploader]
/// - clearLog: delete persisted logs if [sendLog] succeeds
///
/// Scheduling: When initialized, it stores next-clear date. On initialize and
/// on each app start you can call [maybeSendAndClear] to perform send-then-clear
/// when the interval has elapsed.
class LocalLogger {
  static LocalLogger? _instance;

  final Duration clearInterval;
  final LogUploader uploader;
  Directory? _logsDir;
  Timer? _deferredCheck;
  Timer? _nextUploadTimer;
  SendPort? _workerSendPort;

  /// Persisted state file containing nextClearAt ISO string
  static const String _stateFileName = 'logger_state.json';

  LocalLogger._({
    required this.clearInterval,
    required this.uploader,
  });

  static LocalLogger get instance {
    final inst = _instance;
    if (inst == null) {
      throw StateError('LocalLogger not initialized');
    }
    return inst;
  }

  static Future<void> initialize({
    required Duration clearInterval,
    required LogUploader uploader,
  }) async {
    final logger = LocalLogger._(
      clearInterval: clearInterval,
      uploader: uploader,
    );
    await logger._prepare();
    _instance = logger;
  }

  Future<void> _prepare() async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final Directory logsDir = Directory('${appDir.path}/logs');
      if (!await logsDir.exists()) {
        await logsDir.create(recursive: true);
      }
      _logsDir = logsDir;

      // Initialize state file if missing
      final File stateFile = File('${logsDir.path}/$_stateFileName');
      if (!await stateFile.exists()) {
        final nextClearAt = DateTime.now().add(clearInterval);
        await stateFile.writeAsString(
          jsonEncode({
            'nextClearAt': nextClearAt.toIso8601String(),
          }),
        );
      }

      // Run a silent send-and-clear check shortly after init
      _deferredCheck?.cancel();
      _deferredCheck = Timer(const Duration(seconds: 1), () {
        _safeMaybeSendAndClear();
      });

      // Schedule the next upload timer based on the state file
      await _scheduleNextUpload();

      // Start background worker isolate for async, batched logging
      await _startWorker(logsDir);
    } catch (e, st) {
      _debug('LocalLogger prepare failed: $e');
      await _writeInternalError('prepare', e, st);
    }
  }

  Future<void> _startWorker(Directory logsDir) async {
    try {
      final ReceivePort receivePort = ReceivePort();
      await Isolate.spawn<_LoggerWorkerInit>(
        _loggerWorkerEntry,
        _LoggerWorkerInit(
          sendPort: receivePort.sendPort,
          logsDirPath: logsDir.path,
        ),
        errorsAreFatal: false,
        debugName: 'LocalLoggerWorker',
      );

      final completer = Completer<SendPort>();
      final sub = receivePort.listen((message) {
        if (message is SendPort) {
          completer.complete(message);
        }
      });
      _workerSendPort = await completer.future.timeout(
        const Duration(seconds: 3),
      );
      await sub.cancel();
    } catch (e, st) {
      _debug('LocalLogger worker start failed: $e');
      await _writeInternalError('worker_start', e, st);
      _workerSendPort = null; // fallback to direct file writes
    }
  }

  /// Append a log entry (Map or String) to today's log file.
  Future<void> saveLog(Map<String, dynamic> log) async {
    // Non-blocking: push to worker isolate if available; otherwise fallback
    final Map<String, dynamic> record = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'payload': log,
    };
    final send = _workerSendPort;
    final Directory? dir = _logsDir;
    if (send != null && dir != null) {
      try {
        send.send({'type': 'append', 'record': record});
        return;
      } catch (_) {
        // fall through to direct append if sending fails
      }
    }
    await _appendDirect(record);
  }

  Future<void> _appendDirect(Map<String, dynamic> record) async {
    try {
      final Directory? dir = _logsDir;
      if (dir == null) return;
      final String fileName = _bundleFileNameForDate(DateTime.now());
      final File file = File('${dir.path}/$fileName');
      if (!await file.exists()) {
        await file.create(recursive: true);
        await file.writeAsString('[]');
      }

      final JsonEncoder encoder = JsonEncoder((Object? value) {
        if (value is DateTime) return value.toIso8601String();
        return value?.toString();
      });
      final String payload = encoder.convert(record);

      final RandomAccessFile raf = await file.open(mode: FileMode.append);
      try {
        await raf.lock(FileLock.exclusive);
        final int length = await raf.length();
        // File must at least contain []
        final bool isEmptyArray = length <= 2;
        // Seek to just before closing bracket
        await raf.setPosition(length > 0 ? length - 1 : 0);
        if (isEmptyArray) {
          await raf.writeString(payload);
        } else {
          await raf.writeString(',');
          await raf.writeString(payload);
        }
        await raf.writeString(']');
        await raf.flush();
      } finally {
        try {
          await raf.unlock();
        } catch (_) {}
        await raf.close();
      }
    } catch (e, st) {
      _debug('LocalLogger direct append failed: $e');
      await _writeInternalError('append_direct', e, st);
    }
  }

  /// Attempt to send all saved logs as a single JSON file.
  /// Returns true only if upload succeeded.
  Future<bool> sendLog() async {
    try {
      final Directory? dir = _logsDir;
      if (dir == null) return false;
      final files = await _listLogFiles(dir);
      if (files.isEmpty) {
        _debug('LocalLogger: No log files to send');
        return true; // nothing to send
      }
      _debug('LocalLogger: Found ${files.length} log files to send');

      final DateTime from = await _oldestLogDate(files) ?? DateTime.now();
      final DateTime to = await _newestLogDate(files) ?? DateTime.now();

      final File bundle = File(
        '${dir.path}/bundle_${DateTime.now().millisecondsSinceEpoch}.json',
      );
      await _writeBundleJson(files, bundle);

      bool ok = false;
      try {
        ok = await uploader(bundle, from: from, to: to);
      } catch (e, st) {
        _debug('LocalLogger uploader threw: $e');
        await _writeInternalError('uploader', e, st);
        ok = false;
      }
      if (!ok) {
        _debug('LocalLogger: upload failed, keeping logs');
      }
      // Do not delete original files here; deletion happens in clearLog after success
      return ok;
    } catch (e, st) {
      _debug('LocalLogger sendLog failed: $e');
      await _writeInternalError('sendLog', e, st);
      return false;
    }
  }

  /// Clear all saved logs after a successful send.
  Future<void> clearLog() async {
    try {
      final Directory? dir = _logsDir;
      if (dir == null) return;
      final files = await _listLogFiles(dir);
      for (final f in files) {
        try {
          if (await f.exists()) {
            await f.delete();
            _debug(
              'LocalLogger: Successfully deleted log file ${f.path.split('/').last}',
            );
          }
        } catch (e, st) {
          // Only log if it's not a "file not found" error
          if (e.toString().contains('No such file or directory')) {
            // File was already deleted, this is expected
            continue;
          }
          _debug('LocalLogger delete file failed: $e');
          await _writeInternalError('clearLog_delete', e, st);
        }
      }
      // Also delete any bundles older than today to avoid buildup
      final bundles = dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json') && f.path.contains('bundle_'))
          .where((f) => !f.path.contains(_stateFileName)) // Exclude state file
          .where(
            (f) => !f.path.contains(
              'bundle_${DateTime.now().millisecondsSinceEpoch}',
            ),
          ) // Exclude current temp bundle
          .toList();
      for (final b in bundles) {
        try {
          if (await b.exists()) {
            await b.delete();
            _debug(
              'LocalLogger: Successfully deleted bundle file ${b.path.split('/').last}',
            );
          }
        } catch (e, st) {
          // Only log if it's not a "file not found" error
          if (e.toString().contains('No such file or directory')) {
            // File was already deleted, this is expected
            continue;
          }
          _debug('LocalLogger delete bundle failed: $e');
          await _writeInternalError('clearLog_bundle', e, st);
        }
      }
    } catch (e, st) {
      _debug('LocalLogger clearLog failed: $e');
      await _writeInternalError('clearLog', e, st);
    }
  }

  /// Create a unified .ldjson export file combining all available logs.
  /// Returns the file if created, otherwise null.
  Future<File?> exportLdjson() async {
    try {
      final Directory? dir = _logsDir;
      if (dir == null) return null;
      final List<File> files = await _listLogFiles(dir);
      // Include bundle json files and internal errors if present
      final List<File> bundles = dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json') && f.path.contains('bundle_'))
          .toList();
      final File internal = File('${dir.path}/logger_errors.ldjson');

      final Directory tmp = await getTemporaryDirectory();
      final String outPath =
          '${tmp.path}/logs_export_${DateTime.now().millisecondsSinceEpoch}.ldjson';
      final File out = File(outPath);
      if (await out.exists()) {
        await out.delete();
      }
      final RandomAccessFile raf = await out.open(mode: FileMode.write);
      try {
        // Write ldjson lines from legacy ldjson files
        for (final f in files) {
          try {
            final lines = await f.readAsLines();
            for (final line in lines) {
              if (line.trim().isEmpty) continue;
              // Validate JSON; if invalid, wrap as {"malformed": line}
              try {
                jsonDecode(line);
                await raf.writeString(line);
              } catch (_) {
                await raf.writeString(jsonEncode({'malformed': line}));
              }
              await raf.writeString('\n');
            }
          } catch (_) {}
        }

        // Flatten bundle arrays into ldjson
        for (final b in bundles) {
          try {
            final raw = await b.readAsString();
            final decoded = jsonDecode(raw);
            if (decoded is List) {
              for (final item in decoded) {
                await raf.writeString(jsonEncode(item));
                await raf.writeString('\n');
              }
            } else if (decoded is Map && decoded['logs'] is List) {
              for (final item in (decoded['logs'] as List)) {
                await raf.writeString(jsonEncode(item));
                await raf.writeString('\n');
              }
            }
          } catch (_) {}
        }

        // Append internal errors if exist
        if (await internal.exists()) {
          try {
            final errs = await internal.readAsLines();
            for (final line in errs) {
              if (line.trim().isEmpty) continue;
              await raf.writeString(line);
              await raf.writeString('\n');
            }
          } catch (_) {}
        }

        await raf.flush();
      } finally {
        await raf.close();
      }
      return out;
    } catch (e, st) {
      _debug('LocalLogger exportLdjson failed: $e');
      await _writeInternalError('export_ldjson', e, st);
      return null;
    }
  }

  /// Create a unified .json export file combining all available logs.
  /// The output is a JSON object with keys: {"logs": [...], "internalErrors": [...]}.
  /// Returns the file if created, otherwise null.
  Future<File?> exportJson() async {
    try {
      final Directory? dir = _logsDir;
      if (dir == null) return null;
      final List<File> files = await _listLogFiles(dir);
      final List<File> bundles = dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json') && f.path.contains('bundle_'))
          .toList();
      final File internal = File('${dir.path}/logger_errors.ldjson');

      final List<Map<String, dynamic>> allLogs = <Map<String, dynamic>>[];
      final List<Map<String, dynamic>> allErrors = <Map<String, dynamic>>[];

      // Collect logs from ldjson daily files
      for (final f in files) {
        try {
          final lines = await f.readAsLines();
          for (final line in lines) {
            if (line.trim().isEmpty) continue;
            try {
              final decoded = jsonDecode(line);
              if (decoded is Map<String, dynamic>) {
                allLogs.add(decoded);
              } else {
                allLogs.add({'_': decoded});
              }
            } catch (_) {
              allLogs.add({'malformed': line});
            }
          }
        } catch (_) {}
      }

      // Collect logs from bundle json arrays
      for (final b in bundles) {
        try {
          final raw = await b.readAsString();
          final decoded = jsonDecode(raw);
          if (decoded is List) {
            for (final item in decoded) {
              if (item is Map<String, dynamic>) {
                allLogs.add(item);
              } else {
                allLogs.add({'_': item});
              }
            }
          } else if (decoded is Map && decoded['logs'] is List) {
            for (final item in (decoded['logs'] as List)) {
              if (item is Map<String, dynamic>) {
                allLogs.add(item);
              } else {
                allLogs.add({'_': item});
              }
            }
          }
        } catch (_) {}
      }

      // Collect internal errors
      if (await internal.exists()) {
        try {
          final errs = await internal.readAsLines();
          for (final line in errs) {
            if (line.trim().isEmpty) continue;
            try {
              final decoded = jsonDecode(line);
              if (decoded is Map<String, dynamic>) {
                allErrors.add(decoded);
              } else {
                allErrors.add({'_': decoded});
              }
            } catch (_) {
              allErrors.add({'malformed': line});
            }
          }
        } catch (_) {}
      }

      final Directory tmp = await getTemporaryDirectory();
      final String outPath =
          '${tmp.path}/logs_export_${DateTime.now().millisecondsSinceEpoch}.json';
      final File out = File(outPath);
      await out.writeAsString(
        jsonEncode({
          'logs': allLogs,
          'internalErrors': allErrors,
        }),
      );
      return out;
    } catch (e, st) {
      _debug('LocalLogger exportJson failed: $e');
      await _writeInternalError('export_json', e, st);
      return null;
    }
  }

  /// Check if interval elapsed; if yes, try to send then clear.
  /// If upload fails, it will not clear and keeps the same nextClearAt.
  Future<void> maybeSendAndClear() async {
    try {
      final Directory? dir = _logsDir;
      if (dir == null) return;
      final File stateFile = File('${dir.path}/$_stateFileName');
      DateTime nextClearAt = DateTime.now().add(clearInterval);
      if (await stateFile.exists()) {
        try {
          final raw =
              jsonDecode(await stateFile.readAsString())
                  as Map<String, dynamic>;
          final v = raw['nextClearAt'] as String?;
          if (v != null) {
            nextClearAt = DateTime.tryParse(v) ?? nextClearAt;
          }
        } catch (e, st) {
          _debug('LocalLogger state read failed: $e');
          await _writeInternalError('state_read', e, st);
        }
      }

      if (DateTime.now().isBefore(nextClearAt)) {
        return; // not yet time
      }

      final bool sent = await sendLog();
      if (sent) {
        _debug('LocalLogger: Auto clearing logs after successful upload');
        await clearLog();
        final DateTime newNext = DateTime.now().add(clearInterval);
        await stateFile.writeAsString(
          jsonEncode({'nextClearAt': newNext.toIso8601String()}),
        );
        _debug(
          'LocalLogger: Next auto clear scheduled for ${newNext.toIso8601String()}',
        );
        // Schedule the next upload timer
        await _scheduleNextUpload();
      }
    } catch (e, st) {
      _debug('LocalLogger maybeSendAndClear failed: $e');
      await _writeInternalError('maybeSendAndClear', e, st);
    }
  }

  void _safeMaybeSendAndClear() {
    // Fire and forget, swallow all exceptions
    maybeSendAndClear();
  }

  Future<void> _scheduleNextUpload() async {
    try {
      final Directory? dir = _logsDir;
      if (dir == null) return;
      final File stateFile = File('${dir.path}/$_stateFileName');

      DateTime nextClearAt = DateTime.now().add(clearInterval);
      if (await stateFile.exists()) {
        try {
          final raw =
              jsonDecode(await stateFile.readAsString())
                  as Map<String, dynamic>;
          final v = raw['nextClearAt'] as String?;
          if (v != null) {
            nextClearAt = DateTime.tryParse(v) ?? nextClearAt;
          }
        } catch (e, st) {
          _debug('LocalLogger state read failed: $e');
          await _writeInternalError('state_read', e, st);
        }
      }

      final Duration timeUntilNext = nextClearAt.difference(DateTime.now());
      if (timeUntilNext.isNegative) {
        // Time has already passed, run immediately
        _safeMaybeSendAndClear();
      } else {
        // Schedule timer for the exact time
        _nextUploadTimer?.cancel();
        _debug(
          'LocalLogger: Scheduling next upload in ${timeUntilNext.inSeconds} seconds',
        );
        _nextUploadTimer = Timer(timeUntilNext, () {
          _safeMaybeSendAndClear();
          // After upload, schedule the next one
          _scheduleNextUpload();
        });
      }
    } catch (e, st) {
      _debug('LocalLogger scheduleNextUpload failed: $e');
      await _writeInternalError('scheduleNextUpload', e, st);
    }
  }

  /// Dispose of resources and cancel timers
  void dispose() {
    _deferredCheck?.cancel();
    _nextUploadTimer?.cancel();
    _deferredCheck = null;
    _nextUploadTimer = null;
  }

  // Helpers
  // Kept for backward compatibility if needed in future; currently unused.
  // String _fileNameForDate(DateTime d) =>
  //     'log_${d.year}-${_two(d.month)}-${_two(d.day)}.ldjson';

  String _bundleFileNameForDate(DateTime d) =>
      'bundle_${d.year}-${_two(d.month)}-${_two(d.day)}.json';

  String _two(int n) => n < 10 ? '0$n' : '$n';

  Future<List<File>> _listLogFiles(Directory dir) async {
    final all = await dir.list().toList();
    return all
        .whereType<File>()
        .where((f) => f.path.endsWith('.ldjson') || f.path.endsWith('.json'))
        .where((f) => !f.path.contains(_stateFileName)) // Exclude state file
        .where(
          (f) => !f.path.contains(
            'bundle_${DateTime.now().millisecondsSinceEpoch}',
          ),
        ) // Exclude temp upload bundles
        .toList();
  }

  Future<DateTime?> _oldestLogDate(List<File> files) async {
    if (files.isEmpty) return null;
    files.sort((a, b) => a.path.compareTo(b.path));
    return _dateFromFileName(files.first.path);
  }

  Future<DateTime?> _newestLogDate(List<File> files) async {
    if (files.isEmpty) return null;
    files.sort((a, b) => a.path.compareTo(b.path));
    return _dateFromFileName(files.last.path);
  }

  DateTime? _dateFromFileName(String path) {
    final name = path.split('/').last;
    // Handle both log_YYYY-MM-DD.ldjson and bundle_YYYY-MM-DD.json formats
    try {
      String datePart;
      if (name.startsWith('log_')) {
        // log_YYYY-MM-DD.ldjson format
        datePart = name.substring(4, 14);
      } else if (name.startsWith('bundle_')) {
        // bundle_YYYY-MM-DD.json format
        datePart = name.substring(7, 17);
      } else {
        return null;
      }
      final parts = datePart.split('-');
      return DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeBundleJson(List<File> files, File bundle) async {
    final RandomAccessFile raf = await bundle.open(mode: FileMode.write);
    try {
      await raf.lock(FileLock.exclusive);
      final all = <Map<String, dynamic>>[];
      for (final f in files) {
        final lines = await f.readAsLines();
        for (final line in lines) {
          if (line.trim().isEmpty) continue;
          try {
            final decoded = jsonDecode(line);
            all.add(decoded is Map<String, dynamic> ? decoded : {'_': decoded});
          } catch (_) {
            all.add({'malformed': line});
          }
        }
      }
      await raf.writeString(jsonEncode({'logs': all}));
      await raf.flush();
    } finally {
      try {
        await raf.unlock();
      } catch (_) {}
      await raf.close();
    }
  }

  void _debug(String message) {
    if (kDebugMode) {
      log(message);
    }
  }

  Future<void> _writeInternalError(
    String stage,
    Object error,
    StackTrace st,
  ) async {
    try {
      final Directory? dir = _logsDir;
      if (dir == null) return;
      final File file = File('${dir.path}/logger_errors.ldjson');
      final RandomAccessFile raf = await file.open(mode: FileMode.append);
      try {
        await raf.lock(FileLock.exclusive);
        final String line = jsonEncode({
          'timestamp': DateTime.now().toIso8601String(),
          'stage': stage,
          'error': error.toString(),
          'stack': st.toString(),
        });
        await raf.writeString(line);
        await raf.writeString('\n');
        await raf.flush();
      } finally {
        try {
          await raf.unlock();
        } catch (_) {}
        await raf.close();
      }
    } catch (_) {
      /* silently ignore */
    }
  }
}

// ===== Worker isolate implementation =====

class _LoggerWorkerInit {
  final SendPort sendPort;
  final String logsDirPath;
  _LoggerWorkerInit({required this.sendPort, required this.logsDirPath});
}

void _loggerWorkerEntry(_LoggerWorkerInit init) async {
  final ReceivePort rx = ReceivePort();
  init.sendPort.send(rx.sendPort);

  final String logsDirPath = init.logsDirPath;
  final List<Map<String, dynamic>> buffer = <Map<String, dynamic>>[];
  Timer? flushTimer;

  Future<void> ensureAndAppend(List<Map<String, dynamic>> items) async {
    try {
      final DateTime now = DateTime.now();
      final String fileName =
          'bundle_${now.year}-${now.month < 10 ? '0${now.month}' : '${now.month}'}-${now.day < 10 ? '0${now.day}' : '${now.day}'}.json';
      final File file = File('$logsDirPath/$fileName');
      if (!await file.exists()) {
        await file.create(recursive: true);
        await file.writeAsString('[]');
      }
      final RandomAccessFile raf = await file.open(mode: FileMode.append);
      try {
        await raf.lock(FileLock.exclusive);
        final int length = await raf.length();
        final bool isEmptyArray = length <= 2;
        await raf.setPosition(length > 0 ? length - 1 : 0);
        final JsonEncoder encoder = JsonEncoder((Object? value) {
          if (value is DateTime) return value.toIso8601String();
          return value?.toString();
        });
        final String joined = items.map(encoder.convert).join(',');
        if (isEmptyArray) {
          await raf.writeString(joined);
        } else {
          await raf.writeString(',');
          await raf.writeString(joined);
        }
        await raf.writeString(']');
        await raf.flush();
      } finally {
        try {
          await raf.unlock();
        } catch (_) {}
        await raf.close();
      }
    } catch (_) {
      // swallow in worker
    }
  }

  Future<void> scheduleFlush() async {
    flushTimer?.cancel();
    flushTimer = Timer(const Duration(seconds: 2), () async {
      if (buffer.isEmpty) return;
      final items = List<Map<String, dynamic>>.from(buffer);
      buffer.clear();
      await ensureAndAppend(items);
    });
  }

  rx.listen((message) async {
    if (message is Map) {
      final String? type = message['type'] as String?;
      if (type == 'append') {
        final rec = message['record'];
        if (rec is Map) {
          buffer.add(Map<String, dynamic>.from(rec));
          if (buffer.length >= 50) {
            final items = List<Map<String, dynamic>>.from(buffer);
            buffer.clear();
            await ensureAndAppend(items);
          } else {
            await scheduleFlush();
          }
        }
      }
    }
  });
}
