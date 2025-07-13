import 'dart:convert';
import 'package:finalproject/service/service_http_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer'; // Pastikan ini ada
import 'package:shared_preferences/shared_preferences.dart'; // Pastikan ini ada

class AuthRepository {
  final ServiceHttpClient _httpClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AuthRepository({required ServiceHttpClient httpClient}) : _httpClient = httpClient;

  Future<Map<String, dynamic>> login(String email, String password) async {
    final Map<String, dynamic> body = {
      "email": email,
      "password": password,
    };

    try {
      log('AuthRepository: Mengirim permintaan login ke: login');
      final response = await _httpClient.post('login', body, includeAuth: false);
      log('AuthRepository: Menerima respons login. Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        log('AuthRepository: Respons login berhasil (RAW): ${jsonEncode(responseBody)}'); // Gunakan jsonEncode untuk memastikan format string yang bisa dibaca

        final Map<String, dynamic>? data = responseBody['data'];

        if (data != null) {
          log('AuthRepository: Objek "data" dari respons: ${jsonEncode(data)}'); // Log objek data

          if (data.containsKey('token') && data['token'] != null) {
            final String receivedToken = data['token']; // Simpan token ke variabel lokal
            await _secureStorage.write(key: "authToken", value: receivedToken);
            log('AuthRepository: Token berhasil disimpan ke SecureStorage: ${receivedToken.substring(0, 10)}...');

            final String? userName = data['name'] as String?;
            final String? userRole = data['role'] as String?;
            final int? patientId = data['patient_id'] as int?; // Coba ambil patient_id

            log('AuthRepository: Nilai yang dibaca - userRole: "$userRole", patientId: $patientId'); // Log nilai yang dibaca

            final prefs = await SharedPreferences.getInstance();

            // Penting: Pastikan "Pasien" di sini sama persis dengan yang dari API (P kapital)
            if (userRole == 'Pasien' && patientId != null) {
              await prefs.setInt('patient_id', patientId); // Menyimpan patient_id
              log('AuthRepository: Patient ID $patientId BERHASIL disimpan ke SharedPreferences.');
            } else {
              await prefs.remove('patient_id'); // Pastikan dihapus jika tidak valid
              log('AuthRepository: Patient ID TIDAK disimpan. Kondisi: userRole="$userRole" (expected "Pasien"), patientId=$patientId (expected non-null).');
            }

            await prefs.setString('user_role', userRole ?? ''); // Simpan peran
            await prefs.setString('user_name', userName ?? ''); // Simpan nama
            log('AuthRepository: user_role ("${userRole ?? 'null'}"), user_name ("${userName ?? 'null'}") disimpan ke SharedPreferences.');

            if (userName != null && userRole != null) {
              return {
                'message': responseBody['message'] ?? 'Login berhasil',
                'token': receivedToken, // <<< TAMBAHKAN KUNCI 'token' DI SINI
                'user_role': userRole,
                'user_name': userName,
                'patient_id': patientId, // Kembalikan patient_id juga
              };
            } else {
              log('AuthRepository: Objek "data" tidak lengkap (tidak ada nama atau peran). Respons lengkap: ${jsonEncode(responseBody)}');
              throw Exception('Login successful but user data (name or role) is incomplete.');
            }
          } else {
            log('AuthRepository: Respons login tidak mengandung token di dalam "data" objek. Respons lengkap: ${jsonEncode(responseBody)}');
            throw Exception('Login successful but no token received in "data" object.');
          }
        } else {
          log('AuthRepository: Objek "data" dalam respons adalah null. Respons lengkap: ${jsonEncode(responseBody)}');
          throw Exception('Login successful but "data" object is null.');
        }
      } else {
        log('AuthRepository: Login gagal. Status Code: ${response.statusCode}. Body: ${response.body}');
        try {
          var errorBody = json.decode(response.body);
          throw Exception('Login failed: ${errorBody['message'] ?? 'Unknown error'}');
        } catch (_) {
          throw Exception('Login failed: ${response.body}');
        }
      }
    } catch (e) {
      log('AuthRepository: Error selama login: $e', error: e, stackTrace: StackTrace.current); // Log error dengan stack trace
      throw Exception("Login process error: $e");
    }
  }

  // Metode register, logout, getToken tetap sama, tapi tambahkan log serupa
  // di register() untuk patient_id jika relevan.
  // Pastikan juga di logout() patient_id dihapus dari SharedPreferences.

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final Map<String, dynamic> body = {
      "name": name,
      "email": email,
      "password": password,
      "password_confirmation": password,
    };

    try {
      log('AuthRepository: Mengirim permintaan register.');
      final response = await _httpClient.post('register', body, includeAuth: false);
      log('AuthRepository: Menerima respons register. Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        log('AuthRepository: Respons register berhasil (RAW): ${jsonEncode(responseBody)}');

        final Map<String, dynamic>? data = responseBody['data'];

        if (data != null) {
          log('AuthRepository: Objek "data" dari respons register: ${jsonEncode(data)}');

          if (data.containsKey('token') && data['token'] != null) {
            await _secureStorage.write(key: "authToken", value: data['token']);
            log('AuthRepository: Token register berhasil disimpan: ${data['token'].substring(0, 10)}...');

            final String? userRole = data['role'] as String?;
            final int? patientId = data['patient_id'] as int?; // Ambil patient_id di register

            log('AuthRepository: Nilai yang dibaca dari register - userRole: "$userRole", patientId: $patientId');

            final prefs = await SharedPreferences.getInstance();
            if (userRole == 'Pasien' && patientId != null) {
              await prefs.setInt('patient_id', patientId);
              log('AuthRepository: Patient ID $patientId BERHASIL disimpan ke SharedPreferences setelah register.');
            } else {
              await prefs.remove('patient_id');
              log('AuthRepository: Patient ID TIDAK disimpan setelah register. Kondisi: userRole="$userRole" (expected "Pasien"), patientId=$patientId (expected non-null).');
            }
            await prefs.setString('user_role', userRole ?? '');
            await prefs.setString('user_name', data['name'] as String? ?? '');

          } else {
            log('AuthRepository: Respons register tidak mengandung token di dalam "data" objek. Respons lengkap: ${jsonEncode(responseBody)}');
            throw Exception('Registration successful but no token received in "data" object.');
          }
        } else {
          log('AuthRepository: Objek "data" dalam respons register adalah null. Respons lengkap: ${jsonEncode(responseBody)}');
          throw Exception('Registration successful but "data" object is null.');
        }
        return responseBody;
      } else {
        log('AuthRepository: Register gagal. Status Code: ${response.statusCode}. Body: ${response.body}');
        try {
          var errorBody = json.decode(response.body);
          throw Exception('Registration failed: ${errorBody['message'] ?? 'Unknown error'}');
        } catch (_) {
          throw Exception('Registration failed: ${response.body}');
        }
      }
    } catch (e) {
      log('AuthRepository: Error selama register: $e', error: e, stackTrace: StackTrace.current);
      throw Exception("Register process error: $e");
    }
  }

  Future<void> logout() async {
    final token = await _secureStorage.read(key: "authToken");
    log('AuthRepository: Token ditemukan untuk logout: ${token != null ? token.substring(0, 10) : 'null'}');

    if (token != null) {
      try {
        final response = await _httpClient.post('logout', {});

        if (response.statusCode == 200) {
          await _secureStorage.delete(key: "authToken");
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('user_name');
          await prefs.remove('user_role');
          await prefs.remove('patient_id'); // --- Pastikan ini ada ---
          log('AuthRepository: Token, nama, peran, dan patient_id pengguna BERHASIL dihapus.');
        } else {
          log('AuthRepository: Gagal logout: ${response.statusCode} - ${response.body}');
          throw Exception('Logout failed: ${response.body}');
        }
      } catch (e) {
        log('AuthRepository: Error selama logout: $e', error: e, stackTrace: StackTrace.current);
        await _secureStorage.delete(key: "authToken");
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('user_name');
        await prefs.remove('user_role');
        await prefs.remove('patient_id'); // --- Pastikan ini ada ---
        log('AuthRepository: Token, nama, peran, dan patient_id pengguna dihapus secara lokal meskipun logout server gagal.');
        throw Exception("Logout process error: $e");
      }
    } else {
      log('AuthRepository: Tidak ada token untuk logout.');
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_name');
      await prefs.remove('user_role');
      await prefs.remove('patient_id'); // --- Pastikan ini ada ---
    }
  }

  Future<String?> getToken() async {
    final token = await _secureStorage.read(key: "authToken");
    log('AuthRepository: Token diambil dari storage: ${token != null ? token.substring(0, 10) : 'null'}');
    return token;
  }
}
