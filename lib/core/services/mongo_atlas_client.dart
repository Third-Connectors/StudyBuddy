// ════════════════════════════════════════════════════════════════════════════
// 🍃 MONGO ATLAS CLIENT — HTTP-based MongoDB Atlas Data API
// ════════════════════════════════════════════════════════════════════════════
//
// Communicates directly with MongoDB Atlas via their REST Data API.
// No server required — calls go from Flutter → MongoDB Atlas HTTPS endpoints.
//
// Docs: https://www.mongodb.com/docs/atlas/app-services/data-api/
// ════════════════════════════════════════════════════════════════════════════

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/api_config.dart';

/// Exception thrown when MongoDB Atlas API returns an error.
class MongoAtlasException implements Exception {
  final String message;
  final int? statusCode;

  const MongoAtlasException(this.message, {this.statusCode});

  @override
  String toString() => 'MongoAtlasException($statusCode): $message';
}

/// HTTP client for MongoDB Atlas Data API.
///
/// Usage:
/// ```dart
/// final client = ref.read(mongoAtlasClientProvider);
/// final docs = await client.find(collection: 'questions', filter: {'subject': 'Matematika'});
/// ```
class MongoAtlasClient {
  late final Dio _dio;

  MongoAtlasClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.mongoAtlasBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'api-key': ApiConfig.mongoAtlasApiKey,
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => debugPrint('[MongoDB] $obj'),
        ),
      );
    }
  }

  /// Base payload that's included in every request.
  Map<String, dynamic> _base(String collection) => {
    'dataSource': ApiConfig.mongoAtlasDataSource,
    'database': ApiConfig.mongoAtlasDatabase,
    'collection': collection,
  };

  // ── find ─────────────────────────────────────────────────────────────────

  /// Fetch multiple documents from a collection.
  ///
  /// Returns an empty list on error (silent fallback for offline scenarios).
  Future<List<Map<String, dynamic>>> find({
    required String collection,
    Map<String, dynamic>? filter,
    Map<String, dynamic>? projection,
    Map<String, dynamic>? sort,
    int? limit,
    int? skip,
  }) async {
    try {
      final body = {
        ..._base(collection),
        if (filter != null) 'filter': filter,
        if (projection != null) 'projection': projection,
        if (sort != null) 'sort': sort,
        if (limit != null) 'limit': limit,
        if (skip != null) 'skip': skip,
      };

      final response = await _dio.post('/action/find', data: body);
      final docs = response.data['documents'] as List?;
      return docs?.cast<Map<String, dynamic>>() ?? [];
    } on DioException catch (e) {
      debugPrint('[MongoAtlasClient] find error: ${e.message}');
      return [];
    } catch (e) {
      debugPrint('[MongoAtlasClient] find error: $e');
      return [];
    }
  }

  // ── findOne ───────────────────────────────────────────────────────────────

  /// Fetch a single document from a collection.
  Future<Map<String, dynamic>?> findOne({
    required String collection,
    required Map<String, dynamic> filter,
    Map<String, dynamic>? projection,
  }) async {
    try {
      final body = {
        ..._base(collection),
        'filter': filter,
        if (projection != null) 'projection': projection,
      };

      final response = await _dio.post('/action/findOne', data: body);
      return response.data['document'] as Map<String, dynamic>?;
    } on DioException catch (e) {
      debugPrint('[MongoAtlasClient] findOne error: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('[MongoAtlasClient] findOne error: $e');
      return null;
    }
  }

  // ── insertOne ─────────────────────────────────────────────────────────────

  /// Insert a single document. Returns the inserted ID or null on failure.
  Future<String?> insertOne({
    required String collection,
    required Map<String, dynamic> document,
  }) async {
    try {
      final body = {..._base(collection), 'document': document};

      final response = await _dio.post('/action/insertOne', data: body);
      // insertedId comes as {"\$oid": "..."} in Atlas
      final raw = response.data['insertedId'];
      if (raw is Map) return raw['\$oid'] as String?;
      return raw?.toString();
    } on DioException catch (e) {
      debugPrint('[MongoAtlasClient] insertOne error: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('[MongoAtlasClient] insertOne error: $e');
      return null;
    }
  }

  // ── updateOne ─────────────────────────────────────────────────────────────

  /// Update a single document.
  Future<bool> updateOne({
    required String collection,
    required Map<String, dynamic> filter,
    required Map<String, dynamic> update,
    bool upsert = false,
  }) async {
    try {
      final body = {
        ..._base(collection),
        'filter': filter,
        'update': update,
        'upsert': upsert,
      };

      await _dio.post('/action/updateOne', data: body);
      return true;
    } on DioException catch (e) {
      debugPrint('[MongoAtlasClient] updateOne error: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('[MongoAtlasClient] updateOne error: $e');
      return false;
    }
  }

  // ── deleteOne ─────────────────────────────────────────────────────────────

  /// Delete a single document.
  Future<bool> deleteOne({
    required String collection,
    required Map<String, dynamic> filter,
  }) async {
    try {
      final body = {..._base(collection), 'filter': filter};

      await _dio.post('/action/deleteOne', data: body);
      return true;
    } on DioException catch (e) {
      debugPrint('[MongoAtlasClient] deleteOne error: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('[MongoAtlasClient] deleteOne error: $e');
      return false;
    }
  }

  /// Helper: extract string ID from Atlas ObjectId format.
  ///
  /// Atlas returns `_id` as `{"\$oid": "abc123"}` — this unwraps it.
  static String extractId(dynamic rawId) {
    if (rawId is Map) return rawId['\$oid']?.toString() ?? '';
    return rawId?.toString() ?? '';
  }
}

/// Riverpod provider for [MongoAtlasClient].
final mongoAtlasClientProvider = Provider<MongoAtlasClient>((ref) {
  return MongoAtlasClient();
});
