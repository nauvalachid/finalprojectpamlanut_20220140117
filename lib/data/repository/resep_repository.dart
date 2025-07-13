import 'dart:io';
import 'dart:typed_data'; // Penting: Tambahkan ini untuk Uint8List
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

import 'package:finalproject/data/model/request/admin/tambahresep_request.model.dart';
import 'package:finalproject/data/model/response/admin/editresep_response_model.dart';
import 'package:finalproject/data/model/response/admin/tambahresep_response_model.dart';
import 'package:finalproject/data/model/response/pasien/melihatreseppasien_response_model.dart';
import 'package:finalproject/service/service_http_client.dart'; // Pastikan path ini benar

class ResepRepository {
  final ServiceHttpClient _serviceHttpClient;

  ResepRepository(this._serviceHttpClient);

  /// Mengirim permintaan untuk menambahkan resep baru.
  Future<TambahResepResponseModel> tambahResep(ResepRequest request) async {
    final uri = Uri.parse('${_serviceHttpClient.baseUrl}resep');
    var multipartRequest = http.MultipartRequest('POST', uri);

    multipartRequest.fields['patient_id'] = request.patientId.toString();
    multipartRequest.fields['diagnosa'] = request.diagnosa;
    multipartRequest.fields['pendaftaran_id'] = request.pendaftaranId.toString();
    multipartRequest.fields['keterangan_obat'] = request.keteranganObat;

    if (request.potoObat != null) {
      multipartRequest.files.add(await http.MultipartFile.fromPath(
        'poto_obat', // <--- PENTING: Pastikan ini 'poto_obat' (snake_case)
        request.potoObat!.path,
        filename: basename(request.potoObat!.path),
      ));
    }

    try {
      final response = await _serviceHttpClient.sendMultipartRequest(multipartRequest);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TambahResepResponseModel.fromJson(response.body);
      } else {
        throw Exception(
            'Failed to add resep: Status ${response.statusCode} - Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding resep: $e');
    }
  }

  /// Mengambil daftar resep berdasarkan ID pasien (ini untuk Admin).
  Future<LihatResepPasienResponseModel> getResepByPatientId(int patientId) async {
    try {
      log('ResepRepository: Memanggil endpoint Admin: resep/pasien/$patientId');
      final response = await _serviceHttpClient.get('resep/pasien/$patientId');

      if (response.statusCode == 200) {
        return LihatResepPasienResponseModel.fromJson(response.body);
      } else {
        throw Exception(
            'Failed to load resep: Status ${response.statusCode} - Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting resep by patient ID: $e');
    }
  }

  /// Mengambil daftar resep untuk pasien yang sedang login.
  Future<LihatResepPasienResponseModel> getResepForAuthenticatedPasien() async {
    try {
      log('ResepRepository: Memanggil endpoint Pasien: resep'); // Log untuk debugging
      final response = await _serviceHttpClient.get('resep'); // Endpoint yang benar untuk pasien

      if (response.statusCode == 200) {
        return LihatResepPasienResponseModel.fromJson(response.body);
      } else {
        log('ResepRepository: Gagal memuat resep untuk pasien. Status: ${response.statusCode}, Body: ${response.body}');
        String errorMessage = 'Failed to load resep for authenticated patient';
        try {
          final errorBody = json.decode(response.body);
          errorMessage = errorBody['message'] ?? errorMessage;
        } catch (_) {
          // Abaikan jika tidak bisa parsing JSON
        }
        throw Exception('$errorMessage: Status ${response.statusCode} - Body: ${response.body}');
      }
    } catch (e) {
      log('ResepRepository: Error fetching resep for authenticated patient: $e');
      throw Exception('Error getting resep for authenticated patient: $e');
    }
  }

  /// Mengambil detail resep berdasarkan ID resep.
  Future<TambahResepResponseModel> getResepById(int resepId) async {
    try {
      final response = await _serviceHttpClient.get('resep/$resepId');

      if (response.statusCode == 200) {
        return TambahResepResponseModel.fromJson(response.body);
      } else {
        throw Exception(
            'Failed to load resep: Status ${response.statusCode} - Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting resep by ID: $e');
    }
  }

  /// Mengirim permintaan untuk mengedit resep yang sudah ada.
  Future<EditResepResponseModel> editResep({
    required int resepId,
    required int patientId,
    required String diagnosa,
    String? keteranganObat,
    int? pendaftaranId,
    File? potoObatFile,
  }) async {
    final uri = Uri.parse('${_serviceHttpClient.baseUrl}resep/$resepId');
    final multipartRequest = http.MultipartRequest('POST', uri);

    multipartRequest.fields['diagnosa'] = diagnosa;
    multipartRequest.fields['patient_id'] = patientId.toString();

    if (keteranganObat != null && keteranganObat.isNotEmpty) {
      multipartRequest.fields['keterangan_obat'] = keteranganObat;
    }
    if (pendaftaranId != null) {
      multipartRequest.fields['pendaftaran_id'] = pendaftaranId.toString();
    }

    multipartRequest.fields['_method'] = 'PUT'; // Metode spoofing untuk PUT

    if (potoObatFile != null) {
      final mimeTypeData = lookupMimeType(potoObatFile.path)?.split('/');
      multipartRequest.files.add(await http.MultipartFile.fromPath(
        'poto_obat',
        potoObatFile.path,
        contentType: mimeTypeData != null && mimeTypeData.length == 2
            ? MediaType(mimeTypeData[0], mimeTypeData[1])
            : null,
      ));
    }

    try {
      final response = await _serviceHttpClient.sendMultipartRequest(multipartRequest);

      if (response.statusCode == 200) {
        return EditResepResponseModel.fromJson(response.body);
      } else {
        throw Exception(
            'Failed to edit resep: Status ${response.statusCode} - Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error editing resep: $e');
    }
  }

  /// Menghapus resep berdasarkan ID.
  Future<Map<String, dynamic>> deleteResep(int resepId) async {
    try {
      final response = await _serviceHttpClient.delete('resep/$resepId');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to delete resep: Status ${response.statusCode} - Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting resep: $e');
    }
  }

  /// Mengambil daftar resep berdasarkan ID Pendaftaran.
  Future<LihatResepPasienResponseModel> getResepByPendaftaranId(int pendaftaranId) async {
    try {
      final response = await _serviceHttpClient.get('resep/pendaftaran/$pendaftaranId');

      if (response.statusCode == 200) {
        return LihatResepPasienResponseModel.fromJson(response.body);
      } else {
        if (response.statusCode == 404) {
           return LihatResepPasienResponseModel(
               message: "Tidak ada resep ditemukan untuk pendaftaran ID $pendaftaranId",
               data: []);
        }
        throw Exception(
            'Failed to load resep by pendaftaran ID: Status ${response.statusCode} - Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting resep by pendaftaran ID: $e');
    }
  }

  /// Mengambil data PDF resep sebagai byte.
  // Pastikan ServiceHttpClient.get dengan returnRawResponse: true mengembalikan data byte
  Future<Uint8List> exportResepPdf(int resepId) async {
    try {
      log('ResepRepository: Mengambil data PDF untuk resep ID $resepId...');
      
      // Panggil metode GET dari ServiceHttpClient, meminta raw response (byte)
      final response = await _serviceHttpClient.get(
        'resep/$resepId/export-pdf', // Sesuaikan dengan endpoint API Anda
        returnRawResponse: true, // Ini penting agar bodyBytes dikembalikan
      );

      if (response.statusCode == 200) {
        // Langsung kembalikan bodyBytes yang diterima dari ServiceHttpClient
        if (response.bodyBytes.isNotEmpty) {
          log('ResepRepository: Data PDF berhasil diterima untuk resep ID $resepId. Ukuran: ${response.bodyBytes.length} bytes');
          return response.bodyBytes;
        } else {
          throw Exception('Received empty PDF data from server.');
        }
      } else {
        // Tangani error berdasarkan status code
        String errorMessage = 'Failed to get PDF. Status: ${response.statusCode}';
        try {
          // Coba parse body respons jika itu JSON error
          final errorBody = json.decode(response.body);
          errorMessage += ' - ${errorBody['message'] ?? response.body}';
        } catch (_) {
          // Jika bukan JSON, gunakan body mentah
          errorMessage += ' - ${response.body}';
        }
        log('ResepRepository: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      log('ResepRepository: Error fetching PDF for resep ID $resepId: $e');
      throw Exception('Error fetching PDF for resep ID $resepId: $e');
    }
  }
}