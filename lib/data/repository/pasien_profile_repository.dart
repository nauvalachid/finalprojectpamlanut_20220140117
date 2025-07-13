import 'dart:convert';
import 'package:finalproject/data/model/request/pasien/editprofilepasien_request_model.dart';
import 'package:finalproject/data/model/request/pasien/tambahprofilepasien_request_model.dart';
import 'package:finalproject/data/model/response/pasien/editprofilepasien_response_model.dart';
import 'package:finalproject/data/model/response/pasien/melihatprofilepasien_response_model.dart';
import 'package:finalproject/data/model/response/pasien/tambahprofilepasien_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

abstract class PasienProfileRepository {
  Future<MelihatProfilePasienResponseModel> getAuthenticatedPasienProfile(String token);
  Future<TambahProfilePasienResponseModel> createAuthenticatedPasienProfile(String token, TambahProfilePasienRequestModel requestModel);
  Future<EditProfilePasienResponseModel> updateAuthenticatedPasienProfile(String token, EditProfilePasienRequestModel requestModel);
  Future<void> deleteAuthenticatedPasienProfile(String token);
}

class PasienProfileRepositoryImpl implements PasienProfileRepository {
  final http.Client client;
  final String baseUrl;

  PasienProfileRepositoryImpl({
    required this.client,
    this.baseUrl = 'http://localhost:8000/api',
  });

  @override
  Future<MelihatProfilePasienResponseModel> getAuthenticatedPasienProfile(String token) async {
    final uri = Uri.parse('$baseUrl/pasien/profile'); 

    try {
      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return MelihatProfilePasienResponseModel.fromJson(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid or expired token.');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: Akses ditolak. Hanya pasien yang dapat melihat profil mereka sendiri.');
      } else if (response.statusCode == 404) {
        throw Exception('Profil pasien tidak ditemukan untuk pengguna ini. Harap lengkapi profil Anda.');
      } else {
        final errorBody = json.decode(response.body);
        throw Exception('Gagal memuat profil: ${errorBody['message'] ?? response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching pasien profile: $e');
      throw Exception('Gagal terhubung ke server atau mengurai respons: $e');
    }
  }

  @override
  Future<TambahProfilePasienResponseModel> createAuthenticatedPasienProfile(String token, TambahProfilePasienRequestModel requestModel) async {
    final uri = Uri.parse('$baseUrl/pasien/profile'); 

    try {
      final response = await client.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestModel.toJson(), 
      );

      if (response.statusCode == 201) { 
        return TambahProfilePasienResponseModel.fromJson(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid or expired token.');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: Akses ditolak. Hanya pasien yang dapat membuat atau melengkapi profil mereka sendiri.');
      } else if (response.statusCode == 409) { 
        final errorBody = json.decode(response.body);
        throw Exception('Konflik: ${errorBody['message'] ?? 'Anda sudah memiliki profil pasien. Gunakan endpoint update untuk memperbarui.'}');
      } else {
        final errorBody = json.decode(response.body);
        throw Exception('Gagal membuat profil: ${errorBody['message'] ?? response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error creating pasien profile: $e');
      throw Exception('Gagal terhubung ke server atau mengurai respons: $e');
    }
  }

  @override
  Future<EditProfilePasienResponseModel> updateAuthenticatedPasienProfile(String token, EditProfilePasienRequestModel requestModel) async {
    final uri = Uri.parse('$baseUrl/pasien/profile'); 

    try {
      final response = await client.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestModel.toJson(), 
      );

      if (response.statusCode == 200) { 
        return EditProfilePasienResponseModel.fromJson(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid or expired token.');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: Akses ditolak. Hanya pasien yang dapat memperbarui profil mereka sendiri.');
      } else if (response.statusCode == 404) {
        final errorBody = json.decode(response.body);
        throw Exception('Tidak Ditemukan: ${errorBody['message'] ?? 'Profil pasien tidak ditemukan untuk pengguna ini. Tidak dapat memperbarui.'}');
      } else {
        final errorBody = json.decode(response.body);
        throw Exception('Gagal memperbarui profil: ${errorBody['message'] ?? response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error updating pasien profile: $e');
      throw Exception('Gagal terhubung ke server atau mengurai respons: $e');
    }
  }

  @override
  Future<void> deleteAuthenticatedPasienProfile(String token) async {
    final uri = Uri.parse('$baseUrl/pasien/profile');

    try {
      final response = await client.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) { 
        debugPrint('Profil pasien berhasil dihapus.');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid or expired token.');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: Akses ditolak. Hanya pasien yang dapat menghapus profil mereka sendiri.');
      } else if (response.statusCode == 404) {
        final errorBody = json.decode(response.body);
        throw Exception('Tidak Ditemukan: ${errorBody['message'] ?? 'Profil pasien tidak ditemukan untuk pengguna ini. Tidak dapat menghapus.'}');
      } else {
        final errorBody = json.decode(response.body);
        throw Exception('Gagal menghapus profil: ${errorBody['message'] ?? response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error deleting pasien profile: $e');
      throw Exception('Gagal terhubung ke server atau mengurai respons: $e');
    }
  }
}
