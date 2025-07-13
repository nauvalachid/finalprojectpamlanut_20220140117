import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer'; // Import untuk log

class ServiceHttpClient {
  // PASTIKAN BASE URL INI BENAR SESUAI API BACKEND ANDA
  // Ini harus mengarah ke base URL API Anda, biasanya diakhiri dengan '/api/'
  final String baseUrl = 'http://10.0.2.2:8000/api/'; // URL API backend
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage(); // Gunakan const

  // Metode pembantu untuk mendapatkan headers dengan token
  Future<Map<String, String>> _getHeaders({bool includeAuth = true, bool isMultipart = false}) async {
    final Map<String, String> headers = {
      'Accept': 'application/json',
    };

    if (!isMultipart) { // Hanya tambahkan Content-Type JSON jika bukan multipart
      headers['Content-Type'] = 'application/json';
    }

    if (includeAuth) {
      final token = await secureStorage.read(key: "authToken"); // Kunci harus konsisten
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
        log('ServiceHttpClient: Token digunakan: ${token.substring(0, 10)}...'); // Log sebagian token
      } else {
        log('ServiceHttpClient: Tidak ada token autentikasi.');
      }
    } else {
      log('ServiceHttpClient: Permintaan tanpa autentikasi.');
    }
    return headers;
  }

  // POST (untuk JSON)
  Future<http.Response> post(String endpoint, Map<String, dynamic> body, {bool includeAuth = true}) async {
    final url = Uri.parse("$baseUrl$endpoint");
    log('ServiceHttpClient: POST request ke: $url');
    try {
      final headers = await _getHeaders(includeAuth: includeAuth);
      log('ServiceHttpClient: Headers dikirim untuk POST: $headers');
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      log('ServiceHttpClient: Respons POST dari $endpoint: ${response.statusCode} - ${response.body}');
      return response;
    } catch (e) {
      log('ServiceHttpClient: Error POST request: $e');
      throw Exception("POST request failed: $e");
    }
  }

  // GET
  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse("$baseUrl$endpoint");
    log('ServiceHttpClient: GET request ke: $url');
    try {
      final headers = await _getHeaders();
      log('ServiceHttpClient: Headers dikirim untuk GET: $headers');
      final response = await http.get(
        url,
        headers: headers,
      );
      log('ServiceHttpClient: Respons GET dari $endpoint: ${response.statusCode} - ${response.body}');
      return response;
    } catch (e) {
      log('ServiceHttpClient: Error GET request: $e');
      throw Exception("GET request failed: $e");
    }
  }

  // PUT
  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("$baseUrl$endpoint");
    log('ServiceHttpClient: PUT request ke: $url');
    try {
      final headers = await _getHeaders();
      log('ServiceHttpClient: Headers dikirim untuk PUT: $headers');
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      log('ServiceHttpClient: Respons PUT dari $endpoint: ${response.statusCode} - ${response.body}');
      return response;
    } catch (e) {
      log('ServiceHttpClient: Error PUT request: $e');
      throw Exception("PUT request failed: $e");
    }
  }

  // DELETE
  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse("$baseUrl$endpoint");
    log('ServiceHttpClient: DELETE request ke: $url');
    try {
      final headers = await _getHeaders();
      log('ServiceHttpClient: Headers dikirim untuk DELETE: $headers');
      final response = await http.delete(
        url,
        headers: headers,
      );
      log('ServiceHttpClient: Respons DELETE dari $endpoint: ${response.statusCode} - ${response.body}');
      return response;
    } catch (e) {
      log('ServiceHttpClient: Error DELETE request: $e');
      throw Exception("DELETE request failed: $e");
    }
  }

  // *******************************************************************
  // METODE UNTUK MENGIRIM MULTIPART REQUEST (UNTUK UPLOAD FILE)
  // *******************************************************************
  Future<http.Response> sendMultipartRequest(http.MultipartRequest request) async {
    log('ServiceHttpClient: Multipart request ke: ${request.url}');
    try {
      // Dapatkan headers termasuk token otentikasi
      final authHeaders = await _getHeaders(includeAuth: true, isMultipart: true);

      // Tambahkan headers otentikasi ke request multipart
      request.headers.addAll(authHeaders);
      
      log('ServiceHttpClient: Headers dikirim untuk Multipart: ${request.headers}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      log('ServiceHttpClient: Respons Multipart dari ${request.url}: ${response.statusCode} - ${response.body}');
      return response;
    } catch (e) {
      log('ServiceHttpClient: Error sendMultipartRequest: $e');
      throw Exception("Multipart request failed: $e");
    }
  }
}