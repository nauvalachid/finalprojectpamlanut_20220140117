// lib/repositories/admin_profile_repository.dart

import 'dart:io';
import 'dart:convert';
import 'package:finalproject/data/model/request/admin/editadminprofile_request_model.dart';
import 'package:finalproject/data/model/request/admin/tambahadminprofile_request_model.dart';
import 'package:finalproject/data/model/response/admin/editprofileadmin_response_model.dart'; // Jika ini model untuk Update, pastikan namanya konsisten (UpdateAdminProfileResponseModel)
import 'package:finalproject/data/model/response/admin/melihatprofileadmin_response_model.dart';
import 'package:finalproject/data/model/response/admin/tambahadminprofile_response_model.dart';
import 'package:path/path.dart' as path;

import 'package:finalproject/service/service_http_client.dart';
import 'package:http/http.dart' as http;

class AdminProfileRepository {
  final ServiceHttpClient _serviceHttpClient;

  // PERUBAHAN DI SINI: Konstruktor dengan parameter bernama required
  AdminProfileRepository({required ServiceHttpClient serviceHttpClient})
      : _serviceHttpClient = serviceHttpClient;

  Future<TambahAdminProfileResponseModel> addAdminProfile(AddAdminProfileRequest request) async {
    final url = Uri.parse("${_serviceHttpClient.baseUrl}admin");
    var multipartRequest = http.MultipartRequest('POST', url);
    multipartRequest.fields.addAll(request.toFormData());

    if (request.fotoProfil != null && await request.fotoProfil!.exists()) {
      multipartRequest.files.add(
        await http.MultipartFile.fromPath(
          'foto_profil',
          request.fotoProfil!.path,
          filename: path.basename(request.fotoProfil!.path),
        ),
      );
    }

    try {
      final http.Response response = await _serviceHttpClient.sendMultipartRequest(multipartRequest);
      print('AdminProfileRepository - addAdminProfile: Status ${response.statusCode}, Body: ${response.body}'); // Debugging
      if (response.statusCode == 200 || response.statusCode == 201) {
        return TambahAdminProfileResponseModel.fromJson(response.body);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            'Gagal menambahkan profil admin: ${response.statusCode} - ${errorBody['message'] ?? 'Kesalahan tidak diketahui'}');
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Mohon periksa koneksi Anda.');
    } on http.ClientException catch (e) {
      throw Exception('Kesalahan klien HTTP: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga saat menambahkan profil admin: $e');
    }
  }

  Future<UpdateAdminProfileResponseModel> updateAdminProfile(int adminId, UpdateAdminProfileRequest request) async {
    final url = Uri.parse("${_serviceHttpClient.baseUrl}admin/$adminId");
    var multipartRequest = http.MultipartRequest('POST', url); // Gunakan POST untuk metode PUT dengan _method
    multipartRequest.fields.addAll(request.toFormData());

    if (request.fotoProfil != null && await request.fotoProfil!.exists()) {
      multipartRequest.files.add(
        await http.MultipartFile.fromPath(
          'foto_profil',
          request.fotoProfil!.path,
          filename: path.basename(request.fotoProfil!.path),
        ),
      );
    }

    try {
      final http.Response response = await _serviceHttpClient.sendMultipartRequest(multipartRequest);
      print('AdminProfileRepository - updateAdminProfile: Status ${response.statusCode}, Body: ${response.body}'); // Debugging
      if (response.statusCode == 200) {
        // Asumsi EditProfileAdminResponseModel adalah UpdateAdminProfileResponseModel
        return UpdateAdminProfileResponseModel.fromJson(response.body);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            'Gagal mengupdate profil admin: ${response.statusCode} - ${errorBody['message'] ?? 'Kesalahan tidak diketahui'}');
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Mohon periksa koneksi Anda.');
    } on http.ClientException catch (e) {
      throw Exception('Kesalahan klien HTTP: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga saat mengupdate profil admin: $e');
    }
  }

  /// Mengambil detail profil admin dari backend berdasarkan ID.
  /// [adminId] adalah ID dari tabel 'admin' (bukan user_id dari tabel 'users').
  Future<MelihatAdminProfileResponseModel> getAdminProfile(int adminId) async {
    // PERUBAHAN: Pastikan endpoint ini sesuai dengan API Anda yang mengambil id dari tabel admin
    final String endpoint = 'admin/$adminId'; // Contoh: /api/admin/{admin_id}
    print('AdminProfileRepository - getAdminProfile: Memanggil GET ke URL: ${_serviceHttpClient.baseUrl}$endpoint'); // Debugging
    try {
      final http.Response response = await _serviceHttpClient.get(endpoint);
      print('AdminProfileRepository - getAdminProfile: Respon Status ${response.statusCode}, Body: ${response.body}'); // Debugging

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        return MelihatAdminProfileResponseModel.fromMap(jsonMap);
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
            'Gagal memuat profil admin: ${response.statusCode} - ${errorBody['message'] ?? 'Kesalahan tidak diketahui'}');
      }
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Mohon periksa koneksi Anda.');
    } on http.ClientException catch (e) {
      throw Exception('Kesalahan klien HTTP: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga saat melihat profil admin: $e');
    }
  }
}