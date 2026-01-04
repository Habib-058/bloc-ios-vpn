import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Enum for different log types
enum LogType {
  API_SERVICE,
  ROUTING_INFO,
  UNIVERSAL,
}

/// Enum for error types
enum ResponseType {
  API_ERROR,
  NETWORK_ERROR,
  TIMEOUT_ERROR,
  UNKNOWN_ERROR,
  SUCCESS,
}

/// Model for API Log data
class ApiLogData {
  final ResponseType responseType;
  final String method;
  final String endpoint;
  final int? statusCode;
  final Map<String, String>? requestHeaders;
  final Map<String, String>? requestBody; // Type info only (sanitized mode)
  final Map<String, String>? queryParams; // Sanitized mode
  final Map<String, dynamic>? rawRequestBody; // Raw (debug mode)
  final Map<String, dynamic>? rawQueryParams; // Raw (debug mode)
  final String? errorMessage;
  final String? responseBody;
  final Duration? duration;
  final DateTime timestamp;

  ApiLogData({
    required this.responseType,
    required this.method,
    required this.endpoint,
    this.statusCode,
    this.requestHeaders,
    this.requestBody,
    this.queryParams,
    this.rawRequestBody,
    this.rawQueryParams,
    this.errorMessage,
    this.responseBody,
    this.duration,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    final base = <String, dynamic>{
      'reasonType': responseType.name,
      'method': method,
      'endpoint': endpoint,
      'statusCode': statusCode,
      'errorMessage': errorMessage,
      'durationMs': duration?.inMilliseconds,
      'timestamp': timestamp.toIso8601String(),
    };

    if (kDebugMode) {
      // Raw data in debug mode
      base['requestHeaders'] = requestHeaders;
      base['requestBody'] = rawRequestBody;
      base['queryParams'] = rawQueryParams;
      base['responseBody'] = responseBody; // Only expose in debug mode
    } else {
      // Sanitized in release/profile
      base['requestHeaders'] = _sanitizeHeaders(requestHeaders);
      base['requestBodyTypes'] = requestBody;
      base['queryParams'] = queryParams;
      // Do not expose response body content in release/profile
    }

    return base;
  }

  /// Remove sensitive information from headers
  static Map<String, String>? _sanitizeHeaders(Map<String, String>? headers) {
    if (headers == null) return null;
    final sanitized = Map<String, String>.from(headers);
    if (sanitized.containsKey('Authorization')) {
      sanitized['Authorization'] = '[REDACTED]';
    }
    return sanitized;
  }
}

/// Model for Log entry
class AppLogger {
  final LogType logType;
  final dynamic data;

  AppLogger({
    required this.logType,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'logType': logType.name,
      'data': data is ApiLogData ? (data as ApiLogData).toJson() : data,
    };
  }

  @override
  String toString() {
    if (data is ApiLogData && kDebugMode) {
      final map = Map<String, dynamic>.from(
        (data as ApiLogData).toJson(),
      );
      final dynamic raw = map['responseBody'];
      if (raw is String) {
        try {
          final decoded = jsonDecode(raw);
          map['responseBody'] = decoded;
        } catch (_) {
          // keep as-is if not JSON
        }
      }
      return 'Log(${logType.name}): ${jsonEncode({'logType': logType.name, 'data': map})}';
    }
    return 'Log(${logType.name}): ${jsonEncode(toJson())}';
  }
}

/// Helper class to build API logs
class ApiLogger {

  static Map<String, String> extractBodyTypes(Map<String, dynamic>? body) {
    if (body == null) return {};

    final types = <String, String>{};
    body.forEach((key, value) {
      types[key] = _getRuntimeTypeName(value);
    });
    return types;
  }

  /// Get a human-readable type name
  static String _getRuntimeTypeName(dynamic value) {
    if (value == null) return 'null';
    if (value is String) return 'String';
    if (value is int) return 'int';
    if (value is double) return 'double';
    if (value is bool) return 'bool';
    if (value is List) {
      if (value.isEmpty) return 'List<dynamic>';
      return 'List<${_getRuntimeTypeName(value.first)}>';
    }
    if (value is Map) return 'Map';
    return value.runtimeType.toString();
  }

  /// Create a success log
  static AppLogger success({
    required String method,
    required String endpoint,
    required int statusCode,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    String? responseBody,
    Duration? duration,
  }) {
    return AppLogger(
      logType: LogType.API_SERVICE,
      data: ApiLogData(
        responseType: ResponseType.SUCCESS,
        method: method,
        endpoint: endpoint,
        statusCode: statusCode,
        requestHeaders: headers,
        requestBody: extractBodyTypes(body),
        rawRequestBody: body,
        queryParams: queryParams,
        rawQueryParams: queryParams,
        responseBody: responseBody,
        duration: duration,
      ),
    );
  }

  /// Create an API error log
  static AppLogger apiError({
    required String method,
    required String endpoint,
    required int statusCode,
    required String errorMessage,
    String? responseBody,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    Duration? duration,
  }) {
    return AppLogger(
      logType: LogType.API_SERVICE,
      data: ApiLogData(
        responseType: ResponseType.API_ERROR,
        method: method,
        endpoint: endpoint,
        statusCode: statusCode,
        errorMessage: errorMessage,
        responseBody: responseBody,
        requestHeaders: headers,
        requestBody: extractBodyTypes(body),
        rawRequestBody: body,
        queryParams: queryParams,
        rawQueryParams: queryParams,
        duration: duration,
      ),
    );
  }

  /// Create a network error log
  static AppLogger networkError({
    required String method,
    required String endpoint,
    required String errorMessage,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    Duration? duration,
  }) {
    return AppLogger(
      logType: LogType.API_SERVICE,
      data: ApiLogData(
        responseType: ResponseType.NETWORK_ERROR,
        method: method,
        endpoint: endpoint,
        errorMessage: errorMessage,
        requestHeaders: headers,
        requestBody: extractBodyTypes(body),
        rawRequestBody: body,
        queryParams: queryParams,
        rawQueryParams: queryParams,
        duration: duration,
      ),
    );
  }

  /// Create a timeout error log
  static AppLogger timeoutError({
    required String method,
    required String endpoint,
    required String errorMessage,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    Duration? duration,
  }) {
    return AppLogger(
      logType: LogType.API_SERVICE,
      data: ApiLogData(
        responseType: ResponseType.TIMEOUT_ERROR,
        method: method,
        endpoint: endpoint,
        errorMessage: errorMessage,
        requestHeaders: headers,
        requestBody: extractBodyTypes(body),
        rawRequestBody: body,
        queryParams: queryParams,
        rawQueryParams: queryParams,
        duration: duration,
      ),
    );
  }

  /// Create an unknown error log
  static AppLogger unknownError({
    required String method,
    required String endpoint,
    required String errorMessage,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    Duration? duration,
  }) {
    return AppLogger(
      logType: LogType.API_SERVICE,
      data: ApiLogData(
        responseType: ResponseType.UNKNOWN_ERROR,
        method: method,
        endpoint: endpoint,
        errorMessage: errorMessage,
        requestHeaders: headers,
        requestBody: extractBodyTypes(body),
        rawRequestBody: body,
        queryParams: queryParams,
        rawQueryParams: queryParams,
        duration: duration,
      ),
    );
  }
}
