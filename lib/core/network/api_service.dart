import 'dart:async';
import 'dart:convert';


import 'package:bloc_vpn_ios/core/network/url_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

import '../cache_repositories/auth_preferences_repository.dart';
import '../exceptions/api_exception.dart';
import '../exceptions/network_exception.dart';
import '../utils/helper/connectivity_helper.dart';
import '../utils/helper/content_type_from_path_helper.dart';
import '../utils/logger/app_logger.dart';


class ApiService {
  // Private static instance
  static ApiService? _instance;
  static Completer<ApiService>? _completer;

  // Private constructor
  ApiService._internal({
    required this.client,
    required this.defaultBaseUrl,
    required this.defaultTimeoutSeconds,
    this.onConnectionError,
    this.onUnknownError,
    this.logger,
  });

  // Static method to initialize the singleton asynchronously
  static Future<ApiService> initialize({
    http.Client? client,
    int timeoutSeconds = 30,
    String? baseUrl,
    Function(dynamic error)? onConnectionError,
    Function(dynamic error)? onUnknownError,
    void Function(AppLogger log)? logger,
  }) async {
    if (_instance != null) {
      return _instance!;
    }

    if (_completer != null) {
      return _completer!.future;
    }

    _completer = Completer<ApiService>();

    try {
      final instance = ApiService._internal(
        client: client ?? http.Client(),
        defaultBaseUrl: baseUrl ?? UrlHelper.baseurl,
        defaultTimeoutSeconds: timeoutSeconds,
        onConnectionError: onConnectionError,
        onUnknownError: onUnknownError,
        logger: logger,
      );

      _instance = instance;
      _completer!.complete(instance);
      return instance;
    } catch (error) {
      _completer!.completeError(error);
      _completer = null;
      rethrow;
    }
  }

  // Factory constructor that returns the singleton instance
  factory ApiService() {
    if (_instance == null) {
      throw StateError(
        'ApiService has not been initialized. Call ApiService.initialize() first.',
      );
    }
    return _instance!;
  }

  // Getter for accessing the singleton instance
  static ApiService get instance {
    if (_instance == null) {
      throw StateError(
        'ApiService has not been initialized. Call ApiService.initialize() first.',
      );
    }
    return _instance!;
  }

  // Check if the service is initialized
  static bool get isInitialized => _instance != null;

  final http.Client client;
  final String defaultBaseUrl;
  final int defaultTimeoutSeconds;
  final Function(dynamic error)? onConnectionError;
  final Function(dynamic error)? onUnknownError;
  final void Function(AppLogger log)? logger;

  // Runtime configurable properties
  String? _currentBaseUrl;
  int? _currentTimeoutSeconds;

  // Getters for current configuration
  String get baseUrl => _currentBaseUrl ?? defaultBaseUrl;
  int get timeoutSeconds => _currentTimeoutSeconds ?? defaultTimeoutSeconds;

  // Get current configuration info
  Map<String, dynamic> get currentConfig => {
    'baseUrl': baseUrl,
    'timeoutSeconds': timeoutSeconds,
    'isUsingDefaultBaseUrl': _currentBaseUrl == null,
    'isUsingDefaultTimeout': _currentTimeoutSeconds == null,
  };

  // Method to reset the instance
  static Future<void> reset() async {
    if (_instance != null) {
      _instance!.client.close();
      _instance = null;
    }
    _completer = null;
  }

  // Helper method to build headers
  Future<Map<String, String>> _buildHeaders(
      bool authToken, {
        String? manualAuthToken,
      }) async {
    final headers = {'Content-Type': 'application/json'};

    if (authToken) {
      // If manual token is provided, use it; otherwise use stored token
      String token;
      if (manualAuthToken != null && manualAuthToken.trim().isNotEmpty) {
        token = manualAuthToken;
      } else {
        token = await AuthPreferencesRepository.getAuthToken();
      }

      if (token.trim().isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
        headers['chain'] = 'celo';
      }
    }
    return headers;
  }

  // Helper method to handle API response
  T _handleResponse<T>(
      http.Response response,
      T Function(dynamic) fromJson, {
        String? errorMessageKey,
      }) {
    final decodedBody =
    response.body.isNotEmpty ? jsonDecode(response.body) : null;
    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
        return fromJson(decodedBody);
      case 400:
      case 401:
      case 403:
      case 404:
      case 422:
      case 429:
        throw ApiException(
          message: _extractErrorMessage(decodedBody, errorMessageKey),
          statusCode: response.statusCode,
        );
      case 500:
      default:
        throw ApiException(
          message: _extractErrorMessage(decodedBody, errorMessageKey),
          statusCode: response.statusCode,
        );
    }
  }

  // Extract error message from decoded body with optional manual key (supports dot-path and indices)
  String _extractErrorMessage(dynamic body, String? errorMessageKey) {
    String toMessage(dynamic value) {
      if (value == null) return 'Unknown error occurred';
      if (value is String) return value;
      if (value is List) {
        final messages = value
            .map(
              (e) => e is String
              ? e
              : (e is Map && e.isNotEmpty)
              ? (e.values.first?.toString() ?? '')
              : e.toString(),
        )
            .where((e) => e.trim().isNotEmpty)
            .toList();
        if (messages.isNotEmpty) return messages.first;
      }
      if (value is Map) {
        const commonKeys = [
          'message',
          'error',
          'errors',
          'detail',
          'title',
          'msg',
          'description',
        ];
        for (final key in commonKeys) {
          if (value.containsKey(key)) {
            return toMessage(value[key]);
          }
        }
      }
      return value.toString();
    }

    if (body == null) return 'Unknown error occurred';

    if (errorMessageKey != null && errorMessageKey.trim().isNotEmpty) {
      try {
        final parts = errorMessageKey.split('.');
        dynamic current = body;
        for (final raw in parts) {
          if (current == null) break;
          final part = raw.trim();
          final index = int.tryParse(part);
          if (index != null &&
              current is List &&
              index >= 0 &&
              index < current.length) {
            current = current[index];
          } else if (current is Map && current.containsKey(part)) {
            current = current[part];
          } else {
            current = null;
            break;
          }
        }
        final msg = toMessage(current);
        if (msg.trim().isNotEmpty && msg != 'null') return msg;
      } catch (_) {
        // ignore and fallback
      }
    }

    return toMessage(body);
  }

  // Convert StreamedResponse to Response
  Future<http.Response> _convertStreamedResponse(
      http.StreamedResponse streamedResponse,
      ) async {
    final responseBody = await streamedResponse.stream.bytesToString();
    return http.Response(
      responseBody,
      streamedResponse.statusCode,
      headers: streamedResponse.headers,
      reasonPhrase: streamedResponse.reasonPhrase,
    );
  }

  // Helper method to call logger
  void _logToLogger(AppLogger log) {
    if (logger != null) {
      try {
        logger!(log);
      } catch (e) {
        // Silent fail to avoid spamming console in production
        if (kDebugMode) {
          debugPrint('Logger error: $e');
        }
      }
    }
  }

  // Generic API call method (GET, POST, PUT, DELETE, Multipart POST)
  Future<T> _makeRequest<T>({
    required String method,
    required String endpoint,
    required T Function(dynamic value) fromJson,
    bool authToken = false,
    String? manualAuthToken,
    Map<String, String>? queryParams,
    Map<String, dynamic>? body,
    bool isMultipart = false,
    String? fileKey,
    String? filePath,
    bool showErrorPopup = false,
    VoidCallback? onErrorPopupOkay,
    String? errorMessageKey,
    bool notifyUnknownError = true,
  }) async {
    final startTime = DateTime.now();
    final uri = Uri.parse(
      '$baseUrl$endpoint',
    ).replace(queryParameters: queryParams);

    // Check for internet connection
    bool isConnected = await ConnectivityHelper.hasInternetConnection();
    if (!isConnected) {
      final duration = DateTime.now().difference(startTime);
      final networkError = NetworkException(message: "No internet connection");
      final headers = await _buildHeaders(
        authToken,
        manualAuthToken: manualAuthToken,
      );

      // Log network error
      _logToLogger(
        ApiLogger.networkError(
          method: method,
          endpoint: endpoint,
          errorMessage: networkError.message,
          headers: headers,
          body: body,
          queryParams: queryParams,
          duration: duration,
        ),
      );

      // Trigger connection error callback
      if (onConnectionError != null) {
        await onConnectionError!(networkError);
      }

      // Show error popup only if requested
      // if (showErrorPopup && Get.context != null) {
      //   Get.context!.showErrorPopup(
      //     message: "No Internet Connection",
      //     onPressed: onErrorPopupOkay,
      //   );
      // }

      throw networkError;
    }

    final retryOptions = RetryOptions(maxAttempts: 2);

    try {
      http.Response response;
      final headers = await _buildHeaders(
        authToken,
        manualAuthToken: manualAuthToken,
      );

      if (method == 'GET') {
        response = await retryOptions.retry(
              () => client
              .get(uri, headers: headers)
              .timeout(Duration(seconds: timeoutSeconds)),
          retryIf: (e) => e is http.ClientException || e is TimeoutException,
        );
      } else if ((method == 'POST' || method == 'PATCH') && isMultipart) {
        // Handle Multipart POST/PATCH request
        final request = http.MultipartRequest(method, uri);

        if (fileKey != null && filePath != null && filePath.trim().isNotEmpty) {
          final file = await http.MultipartFile.fromPath(
            fileKey,
            filePath,
            contentType: ContentTypeFromPathHelper.contentTypeFromPath(filePath),
          );
          request.files.add(file);
        }

        if (body != null) {
          // Prepare fields, ensuring fileKey is not sent if filePath is null/empty
          final Map<String, dynamic> mutableBody = Map<String, dynamic>.from(
            body,
          );
          if ((filePath == null || filePath.trim().isEmpty) &&
              fileKey != null) {
            mutableBody.remove(fileKey);
          }
          // Convert Map<String, dynamic> to Map<String, String>
          final stringBody = mutableBody.map(
                (key, value) => MapEntry(key, value.toString()),
          );
          request.fields.addAll(stringBody);
        }

        if (authToken) {
          String token;
          if (manualAuthToken != null && manualAuthToken.trim().isNotEmpty) {
            token = manualAuthToken;
          } else {
            token = await AuthPreferencesRepository.getAuthToken();
          }
          if (token.trim().isNotEmpty) {
            request.headers['Authorization'] = 'Bearer $token';
          }
        }

        final streamedResponse = await request.send().timeout(
          Duration(seconds: timeoutSeconds),
        );
        response = await _convertStreamedResponse(streamedResponse);
      } else {
        // Handle regular requests (POST, PUT, PATCH, DELETE)
        final requestBody = body != null ? jsonEncode(body) : null;

        response = await retryOptions.retry(
              () => client
              .send(
            http.Request(method, uri)
              ..headers.addAll(headers)
              ..body = requestBody ?? "",
          )
              .timeout(Duration(seconds: timeoutSeconds))
              .then(
                (streamedResponse) =>
                _convertStreamedResponse(streamedResponse),
          ),
          retryIf: (e) => e is http.ClientException || e is TimeoutException,
        );
      }

      final duration = DateTime.now().difference(startTime);

      // Handle response and log accordingly
      try {
        final result = _handleResponse(
          response,
          fromJson,
          errorMessageKey: errorMessageKey,
        );

        // Log success
        _logToLogger(
          ApiLogger.success(
            method: method,
            endpoint: endpoint,
            statusCode: response.statusCode,
            headers: headers,
            body: body,
            queryParams: queryParams,
            responseBody: response.body,
            duration: duration,
          ),
        );

        return result;
      } catch (apiException) {
        // Log API error
        if (apiException is ApiException) {
          _logToLogger(
            ApiLogger.apiError(
              method: method,
              endpoint: endpoint,
              statusCode: apiException.statusCode ?? 0,
              errorMessage: apiException.message,
              responseBody: response.body,
              headers: headers,
              body: body,
              queryParams: queryParams,
              duration: duration,
            ),
          );
        }
        rethrow;
      }
    } catch (e) {
      final duration = DateTime.now().difference(startTime);
      final headers = await _buildHeaders(
        authToken,
        manualAuthToken: manualAuthToken,
      );

      // Log different error types
      if (e is http.ClientException) {
        _logToLogger(
          ApiLogger.networkError(
            method: method,
            endpoint: endpoint,
            errorMessage: e.message,
            headers: headers,
            body: body,
            queryParams: queryParams,
            duration: duration,
          ),
        );
      } else if (e is TimeoutException) {
        _logToLogger(
          ApiLogger.timeoutError(
            method: method,
            endpoint: endpoint,
            errorMessage: 'Request timeout after ${timeoutSeconds}s',
            headers: headers,
            body: body,
            queryParams: queryParams,
            duration: duration,
          ),
        );
      } else if (e is! ApiException) {
        _logToLogger(
          ApiLogger.unknownError(
            method: method,
            endpoint: endpoint,
            errorMessage: e.toString(),
            headers: headers,
            body: body,
            queryParams: queryParams,
            duration: duration,
          ),
        );
      }

      throw await _handleError(
        e,
        uri.toString(),
        showErrorPopup: showErrorPopup,
        onErrorPopupOkay: onErrorPopupOkay,
        notifyUnknownError: notifyUnknownError,
      );
    }
  }

  // GET request
  Future<T> get<T>(
      String endpoint, {
        required T Function(dynamic value) fromJson,
        bool authToken = false,
        String? manualAuthToken,
        Map<String, String>? queryParams,
        bool showErrorPopup = false,
        VoidCallback? onErrorPopupOkay,
        String? errorMessageKey,
        bool notifyUnknownError = true,
      }) {
    return _makeRequest<T>(
      method: 'GET',
      endpoint: endpoint,
      fromJson: fromJson,
      authToken: authToken,
      manualAuthToken: manualAuthToken,
      queryParams: queryParams,
      showErrorPopup: showErrorPopup,
      onErrorPopupOkay: onErrorPopupOkay,
      errorMessageKey: errorMessageKey,
      notifyUnknownError: notifyUnknownError,
    );
  }

  // POST request
  Future<T> post<T>(
      String endpoint, {
        required Map<String, dynamic> body,
        required T Function(dynamic value) fromJson,
        bool authToken = false,
        String? manualAuthToken,
        Map<String, String>? queryParams,
        bool showErrorPopup = false,
        VoidCallback? onErrorPopupOkay,
        String? errorMessageKey,
        bool notifyUnknownError = true,
      }) {
    return _makeRequest<T>(
      method: 'POST',
      endpoint: endpoint,
      fromJson: fromJson,
      authToken: authToken,
      manualAuthToken: manualAuthToken,
      body: body,
      queryParams: queryParams,
      showErrorPopup: showErrorPopup,
      onErrorPopupOkay: onErrorPopupOkay,
      errorMessageKey: errorMessageKey,
      notifyUnknownError: notifyUnknownError,
    );
  }

  // Multipart POST request
  Future<T> postMultipart<T>({
    required String endpoint,
    required T Function(dynamic value) fromJson,
    String? fileKey,
    String? filePath,
    Map<String, dynamic>? fields,
    bool authToken = false,
    String? manualAuthToken,
    bool showErrorPopup = false,
    VoidCallback? onErrorPopupOkay,
    String? errorMessageKey,
    bool notifyUnknownError = true,
  }) {
    return _makeRequest<T>(
      method: 'POST',
      endpoint: endpoint,
      fromJson: fromJson,
      authToken: authToken,
      manualAuthToken: manualAuthToken,
      body: fields,
      isMultipart: true,
      fileKey: fileKey,
      filePath: filePath,
      showErrorPopup: showErrorPopup,
      onErrorPopupOkay: onErrorPopupOkay,
      errorMessageKey: errorMessageKey,
      notifyUnknownError: notifyUnknownError,
    );
  }

  // Multipart PATCH request
  Future<T> patchMultipart<T>({
    required String endpoint,
    required T Function(dynamic value) fromJson,
    String? fileKey,
    String? filePath,
    Map<String, dynamic>? fields,
    bool authToken = false,
    String? manualAuthToken,
    bool showErrorPopup = false,
    VoidCallback? onErrorPopupOkay,
    String? errorMessageKey,
    bool notifyUnknownError = true,
  }) {
    return _makeRequest<T>(
      method: 'PATCH',
      endpoint: endpoint,
      fromJson: fromJson,
      authToken: authToken,
      manualAuthToken: manualAuthToken,
      body: fields,
      isMultipart: true,
      fileKey: fileKey,
      filePath: filePath,
      showErrorPopup: showErrorPopup,
      onErrorPopupOkay: onErrorPopupOkay,
      errorMessageKey: errorMessageKey,
      notifyUnknownError: notifyUnknownError,
    );
  }

  // PATCH request
  Future<T> patch<T>(
      String endpoint, {
        required Map<String, dynamic> body,
        required T Function(dynamic value) fromJson,
        bool authToken = false,
        String? manualAuthToken,
        Map<String, String>? queryParams,
        bool showErrorPopup = false,
        VoidCallback? onErrorPopupOkay,
        String? errorMessageKey,
        bool notifyUnknownError = true,
      }) {
    return _makeRequest<T>(
      method: 'PATCH',
      endpoint: endpoint,
      fromJson: fromJson,
      authToken: authToken,
      manualAuthToken: manualAuthToken,
      body: body,
      queryParams: queryParams,
      showErrorPopup: showErrorPopup,
      onErrorPopupOkay: onErrorPopupOkay,
      errorMessageKey: errorMessageKey,
      notifyUnknownError: notifyUnknownError,
    );
  }

  // Handle error - Updated to include notifyUnknownError parameter
  Future<Exception> _handleError(
      dynamic error,
      String url, {
        bool showErrorPopup = false,
        VoidCallback? onErrorPopupOkay,
        bool notifyUnknownError = true,
      }) async {
    String errorMessage;
    Exception exception;

    if (error is http.ClientException) {
      errorMessage = 'Network error: ${error.message}';
      exception = NetworkException(message: errorMessage);
      if (onConnectionError != null) {
        await onConnectionError!(error);
      }
    } else if (error is TimeoutException) {
      errorMessage = 'Request timeout after ${timeoutSeconds}s';
      exception = ApiException(message: errorMessage);
    } else if (error is ApiException) {
      errorMessage = error.message;
      exception = error;
    } else {
      errorMessage = 'Unexpected error: ${error.toString()}';
      exception = ApiException(message: errorMessage);

      // Handle unknown error with callback only if notifyUnknownError is true
      if (notifyUnknownError && onUnknownError != null) {
        await onUnknownError!(error);
      }
    }

    // Debug print the full error details
    if (kDebugMode) {
      debugPrint("❌ API Error Details:");
      debugPrint("   URL: $url");
      debugPrint("   Error Type: ${error.runtimeType}");
      debugPrint("   Message: $errorMessage");
      debugPrint("   Notify Unknown Error: $notifyUnknownError");
    }

    // Show error popup only if requested and context is available
    // if (showErrorPopup && Get.context != null) {
    //   Get.context!.showErrorPopup(
    //     message: errorMessage,
    //     onPressed: onErrorPopupOkay,
    //   );
    // }

    return exception;
  }

}