import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../errors/app_exception.dart';

/// Reusable HTTP client wrapper for ASP.NET Core REST API communication.
class ApiClient {
  final http.Client _httpClient;

  ApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  Map<String, String> get _defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Performs a GET request to the specified [endpoint].
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final uri = ApiConstants.buildUri(endpoint, queryParameters);
    return _sendRequest(
      () => _httpClient.get(
        uri,
        headers: {..._defaultHeaders, ...?headers},
      ),
    );
  }

  /// Performs a POST request to the specified [endpoint] with [body].
  Future<dynamic> post(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final uri = ApiConstants.buildUri(endpoint, queryParameters);
    return _sendRequest(
      () => _httpClient.post(
        uri,
        headers: {..._defaultHeaders, ...?headers},
        body: body != null ? jsonEncode(body) : null,
      ),
    );
  }

  /// Performs a PUT request to the specified [endpoint] with [body].
  Future<dynamic> put(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final uri = ApiConstants.buildUri(endpoint, queryParameters);
    return _sendRequest(
      () => _httpClient.put(
        uri,
        headers: {..._defaultHeaders, ...?headers},
        body: body != null ? jsonEncode(body) : null,
      ),
    );
  }

  /// Performs a DELETE request to the specified [endpoint].
  Future<dynamic> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final uri = ApiConstants.buildUri(endpoint, queryParameters);
    return _sendRequest(
      () => _httpClient.delete(
        uri,
        headers: {..._defaultHeaders, ...?headers},
      ),
    );
  }

  /// Wraps HTTP execution with timeout and robust exception handling.
  Future<dynamic> _sendRequest(Future<http.Response> Function() requestFn) async {
    try {
      final response = await requestFn().timeout(ApiConstants.timeoutDuration);
      return _processResponse(response);
    } on SocketException catch (e) {
      throw NetworkException(
        'Network error: Failed to connect to server at ${ApiConstants.baseUrl}. ${e.message}',
      );
    } on TimeoutException {
      throw const TimeoutException('Server request timed out. Please check your connection.');
    } on http.ClientException catch (e) {
      throw NetworkException('HTTP connection error: ${e.message}');
    } on FormatException catch (e) {
      throw SerializationException('Failed to format JSON data: ${e.message}');
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException('Unexpected error occurred: $e');
    }
  }

  /// Processes HTTP response status codes and decodes JSON body safely.
  dynamic _processResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = utf8.decode(response.bodyBytes);

    dynamic decodedData;
    if (body.isNotEmpty) {
      try {
        decodedData = jsonDecode(body);
      } catch (_) {
        decodedData = body;
      }
    }

    if (statusCode >= 200 && statusCode < 300) {
      return decodedData;
    }

    switch (statusCode) {
      case 400:
        throw ValidationException(
          _extractErrorMessage(decodedData, 'Bad Request: Invalid parameters provided.'),
          details: decodedData,
        );
      case 401:
      case 403:
        throw UnauthorizedException(
          _extractErrorMessage(decodedData, 'Unauthorized: Access denied.'),
        );
      case 404:
        throw NotFoundException(
          _extractErrorMessage(decodedData, 'Resource not found.'),
        );
      case 500:
      default:
        throw ServerException(
          _extractErrorMessage(decodedData, 'Server error with status code $statusCode.'),
          statusCode: statusCode,
          details: decodedData,
        );
    }
  }

  String _extractErrorMessage(dynamic decodedData, String fallback) {
    if (decodedData is Map) {
      if (decodedData['title'] != null) return decodedData['title'].toString();
      if (decodedData['message'] != null) return decodedData['message'].toString();
      if (decodedData['error'] != null) return decodedData['error'].toString();
      if (decodedData['errors'] != null) return decodedData['errors'].toString();
    } else if (decodedData is String && decodedData.isNotEmpty) {
      return decodedData;
    }
    return fallback;
  }
}
