import 'dart:convert';
import 'package:finalproject/data/model/request/admin/editjadwal_request_model.dart';
import 'package:finalproject/data/model/request/admin/tambahjadwal_request_model.dart';
import 'package:finalproject/data/model/response/admin/editjadwal_response_model.dart';
import 'package:finalproject/data/model/response/admin/tambahjadwal_response_model.dart';
import 'package:finalproject/data/model/response/melihatjadwal_response_model.dart';
import 'package:finalproject/service/service_http_client.dart'; // Pastikan path ini benar
import 'package:http/http.dart' as http; // Tetap diperlukan untuk http.Response

/// Kelas repository untuk mengelola operasi API terkait Jadwal (Schedule).
/// Kelas ini bertanggung jawab untuk berkomunikasi dengan backend Laravel.
class JadwalRepository {
  // ServiceHttpClient akan diinjeksi melalui konstruktor.
  // Ini adalah praktik terbaik untuk Dependency Injection.
  final ServiceHttpClient _serviceHttpClient;

  /// Konstruktor untuk JadwalRepository.
  /// Membutuhkan instance [ServiceHttpClient] untuk melakukan permintaan HTTP.
  JadwalRepository(this._serviceHttpClient);

  // --- Catatan Penting ---
  // Metode _getHeaders yang sebelumnya ada di sini tidak lagi diperlukan,
  // karena ServiceHttpClient sudah menanganinya secara internal.
  // Parameter authToken di setiap metode juga akan dihapus/disesuaikan.

  /// Mengambil daftar semua jadwal.
  ///
  /// ServiceHttpClient akan secara otomatis menyertakan token otorisasi jika tersedia.
  ///
  /// Mengembalikan [List<MelihatJadwalResponseModel>] jika berhasil.
  /// Melemparkan [Exception] jika terjadi kesalahan.
  Future<List<MelihatJadwalResponseModel>> getJadwals() async {
    const String endpoint = 'jadwals'; // Cukup berikan endpoint
    try {
      final http.Response response = await _serviceHttpClient.get(endpoint);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => MelihatJadwalResponseModel.fromMap(json)).toList();
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            'Gagal memuat jadwal: ${response.statusCode} - ${errorBody['message'] ?? 'Kesalahan tidak diketahui'}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil jadwal: $e');
    }
  }

  /// Mengambil detail jadwal berdasarkan ID.
  ///
  /// ServiceHttpClient akan secara otomatis menyertakan token otorisasi jika tersedia.
  ///
  /// Mengembalikan [MelihatJadwalResponseModel] jika berhasil.
  /// Melemparkan [Exception] jika terjadi kesalahan (misalnya, jadwal tidak ditemukan).
  Future<MelihatJadwalResponseModel> getJadwalById(int id) async {
    final String endpoint = 'jadwals/$id'; // Cukup berikan endpoint
    try {
      final http.Response response = await _serviceHttpClient.get(endpoint);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        return MelihatJadwalResponseModel.fromMap(jsonMap);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            'Gagal memuat detail jadwal: ${response.statusCode} - ${errorBody['message'] ?? 'Kesalahan tidak diketahui'}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil detail jadwal: $e');
    }
  }

  /// Menambahkan jadwal baru.
  ///
  /// [request] adalah objek [TambahJadwalRequestModel] yang berisi data jadwal baru.
  /// ServiceHttpClient akan secara otomatis menyertakan token otorisasi.
  ///
  /// Mengembalikan [TambahJadwalResponseModel] jika berhasil.
  /// Melemparkan [Exception] jika terjadi kesalahan.
  Future<TambahJadwalResponseModel> addJadwal(TambahJadwalRequestModel request) async {
    const String endpoint = 'jadwals'; // Cukup berikan endpoint
    try {
      final http.Response response = await _serviceHttpClient.post(
        endpoint,
        request.toMap(), // Gunakan toMap() untuk body yang diharapkan Map<String, dynamic>
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        return TambahJadwalResponseModel.fromMap(jsonMap);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            'Gagal menambahkan jadwal: ${response.statusCode} - ${errorBody['message'] ?? 'Kesalahan tidak diketahui'}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat menambahkan jadwal: $e');
    }
  }

  /// Mengedit jadwal yang sudah ada.
  ///
  /// [id] adalah ID jadwal yang akan diedit.
  /// [request] adalah objek [EditJadwalRequestModel] yang berisi data yang akan diupdate.
  /// ServiceHttpClient akan secara otomatis menyertakan token otorisasi.
  ///
  /// Mengembalikan [EditJadwalResponseModel] jika berhasil.
  /// Melemparkan [Exception] jika terjadi kesalahan.
  Future<EditJadwalResponseModel> editJadwal(int id, EditJadwalRequestModel request) async {
    final String endpoint = 'jadwals/$id'; // Cukup berikan endpoint
    try {
      final http.Response response = await _serviceHttpClient.put(
        endpoint,
        request.toMap(), // Gunakan toMap() untuk body yang diharapkan Map<String, dynamic>
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> dynamicMap = json.decode(response.body);
        return EditJadwalResponseModel.fromMap(dynamicMap);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            'Gagal mengedit jadwal: ${response.statusCode} - ${errorBody['message'] ?? 'Kesalahan tidak diketahui'}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengedit jadwal: $e');
    }
  }

  /// Menghapus jadwal.
  ///
  /// [id] adalah ID jadwal yang akan dihapus.
  /// ServiceHttpClient akan secara otomatis menyertakan token otorisasi.
  ///
  /// Mengembalikan [true] jika berhasil dihapus.
  /// Melemparkan [Exception] jika terjadi kesalahan.
  Future<bool> deleteJadwal(int id) async {
    final String endpoint = 'jadwals/$id'; // Cukup berikan endpoint
    try {
      final http.Response response = await _serviceHttpClient.delete(endpoint);

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            'Gagal menghapus jadwal: ${response.statusCode} - ${errorBody['message'] ?? 'Kesalahan tidak diketahui'}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat menghapus jadwal: $e');
    }
  }
}