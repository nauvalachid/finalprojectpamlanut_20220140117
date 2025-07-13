// finalproject/service/service_http_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer'; // Import untuk log

class ServiceHttpClient {
  final String baseUrl = 'http://10.0.2.2:8000/api/'; // URL API backend
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<Map<String, String>> _getHeaders({bool includeAuth = true, bool isMultipart = false}) async {
    final Map<String, String> headers = {
      'Accept': 'application/json', // Default accept JSON
    };

    if (!isMultipart) {
      headers['Content-Type'] = 'application/json';
    }

    if (includeAuth) {
      final token = await secureStorage.read(key: "authToken");
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
        log('ServiceHttpClient: Token used: ${token.substring(0, 10)}...');
      } else {
        log('ServiceHttpClient: No authentication token.');
      }
    } else {
      log('ServiceHttpClient: Request without authentication.');
    }
    return headers;
  }

  // POST (for JSON)
  Future<http.Response> post(String endpoint, Map<String, dynamic> body, {bool includeAuth = true}) async {
    final url = Uri.parse("$baseUrl$endpoint");
    log('ServiceHttpClient: POST request to: $url');
    try {
      final headers = await _getHeaders(includeAuth: includeAuth);
      log('ServiceHttpClient: Headers sent for POST: $headers');
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      log('ServiceHttpClient: POST response from $endpoint: ${response.statusCode} - ${response.body}');
      return response;
    } catch (e) {
      log('ServiceHttpClient: Error POST request: $e');
      throw Exception("POST request failed: $e");
    }
  }

  // GET - MODIFIKASI UNTUK returnRawResponse
  Future<http.Response> get(String endpoint, {bool returnRawResponse = false}) async {
    final url = Uri.parse("$baseUrl$endpoint");
    log('ServiceHttpClient: GET request to: $url');
    try {
      // Untuk PDF, kita mungkin tidak ingin 'Content-Type': 'application/json' di header permintaan,
      // tetapi biarkan 'Accept': 'application/json' karena itu adalah default dari _getHeaders
      // dan server dapat mengabaikannya jika mengembalikan file.
      final headers = await _getHeaders();
      log('ServiceHttpClient: Headers sent for GET: $headers');
      final response = await http.get(
        url,
        headers: headers,
      );

      if (!returnRawResponse && response.headers['content-type']?.contains('application/json') == true) {
        log('ServiceHttpClient: GET response from $endpoint: ${response.statusCode} - ${response.body}');
      } else {
        // Logika untuk respons non-JSON (misalnya PDF)
        log('ServiceHttpClient: GET response (raw) from $endpoint: ${response.statusCode}');
        // Jangan log body untuk respons raw karena bisa sangat besar
      }
      return response;
    } catch (e) {
      log('ServiceHttpClient: Error GET request: $e');
      throw Exception("GET request failed: $e");
    }
  }

  // PUT
  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("$baseUrl$endpoint");
    log('ServiceHttpClient: PUT request to: $url');
    try {
      final headers = await _getHeaders();
      log('ServiceHttpClient: Headers sent for PUT: $headers');
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      log('ServiceHttpClient: PUT response from $endpoint: ${response.statusCode} - ${response.body}');
      return response;
    } catch (e) {
      log('ServiceHttpClient: Error PUT request: $e');
      throw Exception("PUT request failed: $e");
    }
  }

  // DELETE
  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse("$baseUrl$endpoint");
    log('ServiceHttpClient: DELETE request to: $url');
    try {
      final headers = await _getHeaders();
      log('ServiceHttpClient: Headers sent for DELETE: $headers');
      final response = await http.delete(
        url,
        headers: headers,
      );
      log('ServiceHttpClient: DELETE response from $endpoint: ${response.statusCode} - ${response.body}');
      return response;
    } catch (e) {
      log('ServiceHttpClient: Error DELETE request: $e');
      throw Exception("DELETE request failed: $e");
    }
  }

  // METODE UNTUK MENGIRIM MULTIPART REQUEST (SUDAH BENAR)
  Future<http.Response> sendMultipartRequest(http.MultipartRequest request) async {
    log('ServiceHttpClient: Multipart request to: ${request.url}');
    try {
      final authHeaders = await _getHeaders(includeAuth: true, isMultipart: true);
      request.headers.addAll(authHeaders);
      
      log('ServiceHttpClient: Headers sent for Multipart: ${request.headers}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      log('ServiceHttpClient: Multipart response from ${request.url}: ${response.statusCode} - ${response.body}');
      return response;
    } catch (e) {
      log('ServiceHttpClient: Error sendMultipartRequest: $e');
      throw Exception("Multipart request failed: $e");
    }
  }
}