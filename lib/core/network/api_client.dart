// ════════════════════════════════════════════════════════════════════════════
// 🔌 API CLIENT — Dio Implementation with Placeholders
// ════════════════════════════════════════════════════════════════════════════
//
// This API client uses Dio for HTTP requests.
//
// ⚠️ IMPORTANT: Before using this in production:
//   1. Configure your API keys in lib/core/constants/api_config.dart
//   2. Run: flutter pub get
//   3. Implement actual API calls in the marked sections
//
// ════════════════════════════════════════════════════════════════════════════

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_config.dart';

/// Custom exception for API errors.
class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final String? details;

  const ApiException({this.statusCode, required this.message, this.details});

  @override
  String toString() {
    if (details != null) {
      return 'ApiException($statusCode): $message - $details';
    }
    return 'ApiException($statusCode): $message';
  }
}

/// Network connectivity exception.
class NetworkException implements Exception {
  final String message;

  const NetworkException([this.message = 'No internet connection']);

  @override
  String toString() => 'NetworkException: $message';
}

/// A Dio-based HTTP client for Study Buddy API.
///
/// Features:
/// - Automatic retry on network failures
/// - Request/response logging in debug mode
/// - Token refresh handling
/// - Typed exceptions
class ApiClient {
  late final Dio _dio;
  final String baseUrl;
  String? _authToken;

  ApiClient({required this.baseUrl, String? authToken}) {
    _authToken = authToken;
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(milliseconds: ApiConfig.connectionTimeout),
        receiveTimeout: Duration(milliseconds: ApiConfig.receiveTimeout),
        sendTimeout: Duration(milliseconds: ApiConfig.sendTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (ApiConfig.apiKey.isNotEmpty)
            ApiConfig.apiKeyHeader: ApiConfig.apiKey,
        },
      ),
    );

    // Add interceptors for logging and auth
    _dio.interceptors.addAll([
      // Logging interceptor (debug mode only)
      if (kDebugMode)
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          logPrint: (obj) => debugPrint('[API] $obj'),
        ),

      // Auth token interceptor
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_authToken != null) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // TODO: Implement token refresh logic here
          // if (error.response?.statusCode == 401) {
          //   await _refreshToken();
          //   return handler.resolve(await _retry(error.requestOptions));
          // }
          return handler.next(error);
        },
      ),

      // Retry interceptor
      RetryInterceptor(
        dio: _dio,
        maxRetries: ApiConfig.maxRetries,
        retryDelay: Duration(milliseconds: ApiConfig.retryDelay),
      ),
    ]);
  }

  /// Update the authentication token.
  void setAuthToken(String token) {
    _authToken = token;
  }

  /// Clear the authentication token (logout).
  void clearAuthToken() {
    _authToken = null;
  }

  // ── GET ──────────────────────────────────────────────────────────────────

  /// Sends an HTTP GET request.
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ── POST ─────────────────────────────────────────────────────────────────

  /// Sends an HTTP POST request.
  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic>? body, {
    Map<String, String>? headers,
    bool multipart = false,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: multipart ? FormData.fromMap(body ?? {}) : body,
        options: Options(
          headers: headers,
          contentType: multipart ? 'multipart/form-data' : 'application/json',
        ),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ── PUT ──────────────────────────────────────────────────────────────────

  /// Sends an HTTP PUT request.
  Future<Map<String, dynamic>> put(
    String path,
    Map<String, dynamic>? body, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: body,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ── PATCH ────────────────────────────────────────────────────────────────

  /// Sends an HTTP PATCH request.
  Future<Map<String, dynamic>> patch(
    String path,
    Map<String, dynamic>? body, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: body,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ── DELETE ───────────────────────────────────────────────────────────────

  /// Sends an HTTP DELETE request.
  Future<void> delete(String path, {Map<String, String>? headers}) async {
    try {
      await _dio.delete(path, options: Options(headers: headers));
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ── File Upload ──────────────────────────────────────────────────────────

  /// Uploads a file (image, document, etc.).
  Future<Map<String, dynamic>> uploadFile(
    String path,
    String filePath, {
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
        if (additionalData != null) ...additionalData,
      });

      final response = await _dio.post(
        path,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          receiveTimeout: Duration(milliseconds: ApiConfig.receiveTimeout * 2),
        ),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ── Private Helpers ──────────────────────────────────────────────────────

  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode != null &&
        (response.statusCode! < 200 || response.statusCode! >= 300)) {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Request failed with status ${response.statusCode}',
        details: response.data?.toString(),
      );
    }

    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }

    return {};
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          message: 'Request timeout. Please check your connection.',
        );

      case DioExceptionType.connectionError:
        return const NetworkException(
          'No internet connection. Please check your network settings.',
        );

      case DioExceptionType.badResponse:
        return ApiException(
          statusCode: e.response?.statusCode,
          message: _getErrorMessage(e.response?.statusCode),
          details: e.response?.data?.toString(),
        );

      case DioExceptionType.cancel:
        return const ApiException(message: 'Request was cancelled');

      default:
        return ApiException(
          message: 'An unexpected error occurred',
          details: e.message,
        );
    }
  }

  String _getErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please log in again.';
      case 403:
        return 'Access denied. You don\'t have permission.';
      case 404:
        return 'Resource not found.';
      case 409:
        return 'Conflict. Resource already exists.';
      case 422:
        return 'Validation error. Please check your input.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Server error. Please try again later.';
      case 502:
      case 503:
      case 504:
        return 'Service temporarily unavailable.';
      default:
        return 'Request failed with status code $statusCode';
    }
  }
}

/// Retry interceptor for failed requests.
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    required this.dio,
    required this.maxRetries,
    required this.retryDelay,
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Don't retry for these error types
    if (err.type == DioExceptionType.badResponse ||
        err.type == DioExceptionType.cancel) {
      return handler.next(err);
    }

    int retryCount = 0;
    while (retryCount < maxRetries) {
      try {
        await Future.delayed(retryDelay * (retryCount + 1));
        final response = await dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          return handler.next(err);
        }
      }
    }
  }
}
