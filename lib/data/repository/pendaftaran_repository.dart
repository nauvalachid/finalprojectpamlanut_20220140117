import 'dart:convert';
import 'package:finalproject/data/model/request/admin/editstatus_request_model.dart';
import 'package:finalproject/data/model/request/pasien/editpendaftaran_request_model.dart';
import 'package:finalproject/data/model/request/pasien/tambahpendaftaran_request_model.dart';
import 'package:finalproject/data/model/response/admin/editstatus_response_model.dart';
import 'package:finalproject/data/model/response/admin/melihatpendaftaran_response_model.dart';
import 'package:finalproject/data/model/response/pasien/editpendaftaran_response_model.dart';
import 'package:finalproject/data/model/response/pasien/tambahpendaftaran_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:finalproject/service/service_http_client.dart'; // Sesuaikan path

/// Kelas repository untuk mengelola operasi API terkait Pendaftaran.
/// Kelas ini bertanggung jawab untuk berkomunikasi dengan backend Laravel.
class PendaftaranRepository {
  final ServiceHttpClient _serviceHttpClient;

  /// Konstruktor untuk PendaftaranRepository.
  /// Membutuhkan instance [ServiceHttpClient] untuk melakukan permintaan HTTP.
  PendaftaranRepository(this._serviceHttpClient);

  /// Mengambil daftar semua pendaftaran.
  ///
  /// `ServiceHttpClient` akan secara otomatis menyertakan token otorisasi jika tersedia.
  ///
  /// Mengembalikan [List<MelihatPendaftaranResponseModel>] jika berhasil.
  /// Melemparkan [Exception] jika terjadi kesalahan.
  Future<List<MelihatPendaftaranResponseModel>> getAllPendaftaran() async {
    const String endpoint = 'pendaftaran'; // Sesuai dengan route resource
    try {
      final http.Response response = await _serviceHttpClient.get(endpoint);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => MelihatPendaftaranResponseModel.fromMap(json)).toList();
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            'Gagal memuat daftar pendaftaran: ${response.statusCode} - ${errorBody['message'] ?? 'Kesalahan tidak diketahui'}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil daftar pendaftaran: $e');
    }
  }

  /// Mengambil detail pendaftaran berdasarkan ID.
  ///
  /// `ServiceHttpClient` akan secara otomatis menyertakan token otorisasi jika tersedia.
  ///
  /// Mengembalikan [MelihatPendaftaranResponseModel] jika berhasil.
  /// Melemparkan [Exception] jika terjadi kesalahan (misalnya, pendaftaran tidak ditemukan).
  Future<MelihatPendaftaranResponseModel> getPendaftaranById(int id) async {
    final String endpoint = 'pendaftaran/$id'; // Sesuai dengan route resource '{id}'
    try {
      final http.Response response = await _serviceHttpClient.get(endpoint);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        return MelihatPendaftaranResponseModel.fromMap(jsonMap);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            'Gagal memuat detail pendaftaran: ${response.statusCode} - ${errorBody['message'] ?? 'Kesalahan tidak diketahui'}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil detail pendaftaran: $e');
    }
  }

  /// Menambahkan pendaftaran baru.
  ///
  /// [request] adalah objek [TambahPendaftaranRequestModel] yang berisi data pendaftaran baru.
  /// `ServiceHttpClient` akan secara otomatis menyertakan token otorisasi.
  ///
  /// Mengembalikan [TambahPendaftaranResponseModel] jika berhasil.
  /// Melemparkan [Exception] jika terjadi kesalahan.
  Future<TambahPendaftaranResponseModel> addPendaftaran(TambahPendaftaranRequestModel request) async {
    const String endpoint = 'pendaftaran'; // Sesuai dengan route resource
    try {
      final http.Response response = await _serviceHttpClient.post(
        endpoint,
        request.toMap(), // Gunakan toMap() untuk body yang diharapkan Map<String, dynamic>
      );

      if (response.statusCode == 201) { // Biasanya 201 Created untuk operasi POST yang berhasil
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        return TambahPendaftaranResponseModel.fromMap(jsonMap);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            'Gagal menambahkan pendaftaran: ${response.statusCode} - ${errorBody['message'] ?? 'Kesalahan tidak diketahui'}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat menambahkan pendaftaran: $e');
    }
  }

  /// Mengedit detail pendaftaran yang sudah ada.
  ///
  /// [id] adalah ID pendaftaran yang akan diedit.
  /// [request] adalah objek [EditPendaftaranRequestModel] yang berisi data yang akan diupdate.
  /// `ServiceHttpClient` akan secara otomatis menyertakan token otorisasi.
  ///
  /// Mengembalikan [EditPendaftaranResponseModel] jika berhasil.
  /// Melemparkan [Exception] jika terjadi kesalahan.
  Future<EditPendaftaranResponseModel> editPendaftaran(int id, EditPendaftaranRequestModel request) async {
    final String endpoint = 'pendaftaran/$id'; // Sesuai dengan route resource '{id}'
    try {
      final http.Response response = await _serviceHttpClient.put(
        endpoint,
        request.toMap(), // Gunakan toMap() untuk body yang diharapkan Map<String, dynamic>
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        return EditPendaftaranResponseModel.fromMap(jsonMap);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            'Gagal mengedit pendaftaran: ${response.statusCode} - ${errorBody['message'] ?? 'Kesalahan tidak diketahui'}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengedit pendaftaran: $e');
    }
  }

  /// Mengubah status pendaftaran.
  ///
  /// [id] adalah ID pendaftaran yang statusnya akan diubah.
  /// [request] adalah objek [EditStatusRequestModel] yang berisi status baru.
  /// `ServiceHttpClient` akan secara otomatis menyertakan token otorisasi.
  ///
  /// Mengembalikan [EditStatusResponseModel] jika berhasil.
  /// Melemparkan [Exception] jika terjadi kesalahan.
  Future<EditStatusResponseModel> editStatusPendaftaran(int id, EditStatusRequestModel request) async {
    final String endpoint = 'pendaftaran/$id'; // Endpoint khusus untuk update status
    try {
      final http.Response response = await _serviceHttpClient.put(
        endpoint,
        request.toMap(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        return EditStatusResponseModel.fromMap(jsonMap);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            'Gagal mengubah status pendaftaran: ${response.statusCode} - ${errorBody['message'] ?? 'Kesalahan tidak diketahui'}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengubah status pendaftaran: $e');
    }
  }


  /// Menghapus pendaftaran.
  ///
  /// [id] adalah ID pendaftaran yang akan dihapus.
  /// `ServiceHttpClient` akan secara otomatis menyertakan token otorisasi.
  ///
  /// Mengembalikan [true] jika berhasil dihapus.
  /// Melemparkan [Exception] jika terjadi kesalahan.
  Future<bool> deletePendaftaran(int id) async {
    final String endpoint = 'pendaftaran/$id'; // Sesuai dengan route resource '{id}'
    try {
      final http.Response response = await _serviceHttpClient.delete(endpoint);

      if (response.statusCode == 200) {
        // Asumsi API mengembalikan 200 OK untuk delete sukses tanpa body spesifik
        return true;
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            'Gagal menghapus pendaftaran: ${response.statusCode} - ${errorBody['message'] ?? 'Kesalahan tidak diketahui'}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat menghapus pendaftaran: $e');
    }
  }
}