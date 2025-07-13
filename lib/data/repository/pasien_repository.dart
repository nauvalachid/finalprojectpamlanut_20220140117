import 'dart:convert';
import 'package:finalproject/data/model/request/admin/editpasien_request_model.dart';
import 'package:finalproject/data/model/request/admin/tambahpasien_request_model.dart';
import 'package:finalproject/data/model/response/admin/editpasien_response_model.dart';
import 'package:finalproject/data/model/response/admin/melihatpasien_response_model.dart';
import 'package:finalproject/data/model/response/admin/tambahpasien_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:finalproject/service/service_http_client.dart';

/// Kelas repository untuk mengelola operasi API terkait Pasien.
/// Kelas ini bertanggung jawab untuk berkomunikasi dengan backend Laravel.
class PasienRepository {
  final ServiceHttpClient _serviceHttpClient;

  /// Konstruktor untuk PasienRepository.
  /// Membutuhkan instance [ServiceHttpClient] untuk melakukan permintaan HTTP.
  PasienRepository(this._serviceHttpClient);

  /// Mengambil daftar semua pasien.
  ///
  /// ServiceHttpClient akan secara otomatis menyertakan token otorisasi jika tersedia.
  ///
  /// Mengembalikan [List<MelihatPasienResponseModel>] jika berhasil.
  /// Melemparkan [Exception] jika terjadi kesalahan.
  Future<List<MelihatPasienResponseModel>> getPasien() async {
    const String endpoint = 'pasiens'; // Sesuai dengan route resource 'pasiens'
    try {
      final http.Response response = await _serviceHttpClient.get(endpoint);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => MelihatPasienResponseModel.fromMap(json)).toList();
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            'Gagal memuat pasien: ${response.statusCode} - ${errorBody['message'] ?? 'Kesalahan tidak diketahui'}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil pasien: $e');
    }
  }

  /// Mengambil detail pasien berdasarkan ID.
  ///
  /// ServiceHttpClient akan secara otomatis menyertakan token otorisasi jika tersedia.
  ///
  /// Mengembalikan [MelihatPasienResponseModel] jika berhasil.
  /// Melemparkan [Exception] jika terjadi kesalahan (misalnya, pasien tidak ditemukan).
  Future<MelihatPasienResponseModel> getPasienById(int id) async {
    final String endpoint = 'pasiens/$id'; // Sesuai dengan route resource 'pasiens/{id}'
    try {
      final http.Response response = await _serviceHttpClient.get(endpoint);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        return MelihatPasienResponseModel.fromMap(jsonMap);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            'Gagal memuat detail pasien: ${response.statusCode} - ${errorBody['message'] ?? 'Kesalahan tidak diketahui'}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil detail pasien: $e');
    }
  }

  /// Menambahkan pasien baru.
  ///
  /// [request] adalah objek [TambahPasienRequestModel] yang berisi data pasien baru.
  /// ServiceHttpClient akan secara otomatis menyertakan token otorisasi.
  ///
  /// Mengembalikan [TambahPasienResponseModel] jika berhasil.
  /// Melemparkan [Exception] jika terjadi kesalahan.
  Future<TambahPasienResponseModel> addPasien(TambahPasienRequestModel request) async {
    const String endpoint = 'pasiens'; // Sesuai dengan route resource 'pasiens'
    try {
      final http.Response response = await _serviceHttpClient.post(
        endpoint,
        request.toMap(), // Gunakan toMap() untuk body yang diharapkan Map<String, dynamic>
      );

      if (response.statusCode == 201) { // Biasanya 201 Created untuk operasi POST yang berhasil
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        return TambahPasienResponseModel.fromMap(jsonMap);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            'Gagal menambahkan pasien: ${response.statusCode} - ${errorBody['message'] ?? 'Kesalahan tidak diketahui'}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat menambahkan pasien: $e');
    }
  }

  /// Mengedit pasien yang sudah ada.
  ///
  /// [id] adalah ID pasien yang akan diedit.
  /// [request] adalah objek [EditPasienRequestModel] yang berisi data yang akan diupdate.
  /// ServiceHttpClient akan secara otomatis menyertakan token otorisasi.
  ///
  /// Mengembalikan [EditPasienResponseModel] jika berhasil.
  /// Melemparkan [Exception] jika terjadi kesalahan.
  Future<EditPasienResponseModel> editPasien(int id, EditPasienRequestModel request) async {
    final String endpoint = 'pasiens/$id'; // DIUBAH: Sesuai dengan route resource 'pasiens/{id}'
    try {
      final http.Response response = await _serviceHttpClient.put(
        endpoint,
        request.toMap(), // Gunakan toMap() untuk body yang diharapkan Map<String, dynamic>
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> dynamicMap = json.decode(response.body);
        return EditPasienResponseModel.fromMap(dynamicMap);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            'Gagal mengedit pasien: ${response.statusCode} - ${errorBody['message'] ?? 'Kesalahan tidak diketahui'}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengedit pasien: $e');
    }
  }

  /// Menghapus pasien.
  ///
  /// [id] adalah ID pasien yang akan dihapus.
  /// ServiceHttpClient akan secara otomatis menyertakan token otorisasi.
  ///
  /// Mengembalikan [true] jika berhasil dihapus.
  /// Melemparkan [Exception] jika terjadi kesalahan.
  Future<bool> deletePasien(int id) async {
    final String endpoint = 'pasiens/$id'; // DIUBAH: Sesuai dengan route resource 'pasiens/{id}'
    try {
      final http.Response response = await _serviceHttpClient.delete(endpoint);

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            'Gagal menghapus pasien: ${response.statusCode} - ${errorBody['message'] ?? 'Kesalahan tidak diketahui'}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat menghapus pasien: $e');
    }
  }

  Future<MelihatPasienResponseModel> getAuthenticatedPasienProfile() async {
    try {
      final response = await _serviceHttpClient.get('pasien/profile'); // Sesuai dengan route Laravel
      if (response.statusCode == 200) {
        return MelihatPasienResponseModel.fromMap(json.decode(response.body));
      } else {
        throw Exception('Gagal memuat profil pasien: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error memuat profil pasien: $e');
    }
  }

  Future<TambahPasienResponseModel> createAuthenticatedPasienProfile(TambahPasienRequestModel request) async {
    try {
      final response = await _serviceHttpClient.post('pasien/profile', request.toMap());
      if (response.statusCode == 201) {
        return TambahPasienResponseModel.fromMap(json.decode(response.body));
      } else {
        throw Exception('Gagal membuat profil pasien: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error membuat profil pasien: $e');
    }
  }

  Future<EditPasienResponseModel> updateAuthenticatedPasienProfile(EditPasienRequestModel request) async {
    try {
      final response = await _serviceHttpClient.put('pasien/profile', request.toMap());
      if (response.statusCode == 200) {
        return EditPasienResponseModel.fromMap(json.decode(response.body));
      } else {
        throw Exception('Gagal memperbarui profil pasien: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error memperbarui profil pasien: $e');
    }
  }

  Future<bool> deleteAuthenticatedPasienProfile() async {
    try {
      final response = await _serviceHttpClient.delete('pasien/profile');
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Gagal menghapus profil pasien: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error menghapus profil pasien: $e');
    }
  }
}
