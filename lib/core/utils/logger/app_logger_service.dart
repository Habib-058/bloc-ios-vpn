



import 'package:bloc_vpn_ios/core/utils/logger/route_logger.dart';

import 'app_logger.dart';

typedef RouteChangeCallback = void Function(AppLogger routeLog);
typedef AppErrorCallback = void Function(AppLogger errorLog);

/// App-wide logger service (independent of API service)
class AppLoggerService {
  static LoggingRouteObserver? _observer;
  static RouteChangeCallback? _onRouteChange;
  static AppErrorCallback? _onAppUnknownError;
  static AppErrorCallback? _onAppError;

  static LoggingRouteObserver? get routeObserver => _observer;

  /// Initialize with callbacks to capture route changes and errors
  static void init({
    required RouteChangeCallback onRouteChange,
    required AppErrorCallback onAppUnknownError,
    required AppErrorCallback onAppError,
  }) {
    _onRouteChange = onRouteChange;
    _onAppUnknownError = onAppUnknownError;
    _onAppError = onAppError;
    _observer = LoggingRouteObserver(
      onLog: (log) {
        _onRouteChange?.call(log);
      },
    );
  }

  /// Report a known app error with structured, human-readable details
  static void reportAppError({
    String? route,
    required String errorName,
    String? reason,
    String? description,
    StackTrace? stackTrace,
  }) {
    final data = {
      'errorType': 'APP_ERROR',
      'errorName': errorName,
      'reason': reason,
      'description': description,
      'stack': stackTrace?.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    };
    if (route != null && route.isNotEmpty) {
      data['route'] = route;
    }
    _onAppError?.call(AppLogger(logType: LogType.UNIVERSAL, data: data));
  }

  /// Report an unknown app error
  static void reportUnknownError({
    String? route,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final data = {
      'errorType': 'UNKNOWN',
      'errorName': error?.runtimeType.toString(),
      'reason': error?.toString(),
      'description': 'An unexpected error occurred',
      'stack': stackTrace?.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    };
    if (route != null && route.isNotEmpty) {
      data['route'] = route;
    }
    _onAppUnknownError?.call(AppLogger(logType: LogType.UNIVERSAL, data: data));
  }
}
