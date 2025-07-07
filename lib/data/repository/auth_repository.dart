import 'dart:convert';
import 'package:finalproject/service/service_http_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final ServiceHttpClient _httpClient = ServiceHttpClient();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Fungsi untuk login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final Map<String, dynamic> body = {
      "email": email,
      "password": password,
    };

    final response = await _httpClient.post('login', body);

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);

      // Simpan token di secure storage
      await _secureStorage.write(key: "authToken", value: responseBody['token']);

      return responseBody; // Mengembalikan data respons jika berhasil login
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  // Fungsi untuk register
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final Map<String, dynamic> body = {
      "name": name,
      "email": email,
      "password": password,
      "password_confirmation": password, // Password confirmation juga diperlukan pada register
    };

    final response = await _httpClient.post('register', body);

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);

      // Simpan token di secure storage setelah register berhasil
      await _secureStorage.write(key: "authToken", value: responseBody['token']);

      return responseBody; // Mengembalikan data respons jika berhasil register
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  // Fungsi untuk logout
  Future<void> logout() async {
    final token = await _secureStorage.read(key: "authToken");

    if (token != null) {
      await _httpClient.postWithToken('logout', {}); // Mengirimkan token untuk logout
      await _secureStorage.delete(key: "authToken"); // Hapus token setelah logout
    }
  }

  // Fungsi untuk mendapatkan token yang disimpan
  Future<String?> getToken() async {
    return await _secureStorage.read(key: "authToken");
  }
}
