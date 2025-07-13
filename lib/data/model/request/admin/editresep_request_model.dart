import 'dart:io'; // Untuk File
import 'package:finalproject/service/service_http_client.dart'; // Import service_http_client Anda
import 'package:http/http.dart' as http; // Tetap diperlukan untuk MultipartFile dan MultipartRequest
import 'package:http_parser/http_parser.dart'; // Untuk MediaType
import 'package:mime/mime.dart'; // Untuk lookupMimeType
import 'dart:convert'; // Untuk jsonDecode jika Anda ingin parsing respons JSON

class ResepService {
  final ServiceHttpClient _serviceHttpClient;
  final String _authToken; // Token otentikasi Anda, jika ServiceHttpClient tidak mengelolanya secara otomatis

  // Konstruktor tunggal yang menerima ServiceHttpClient dan authToken
  ResepService({
    required ServiceHttpClient serviceHttpClient,
    required String authToken, // Pastikan authToken juga diterima di sini
  })  : _serviceHttpClient = serviceHttpClient,
        _authToken = authToken;

  Future<Map<String, dynamic>> editResep({
    required int resepId,
    required int patientId,
    required String diagnosa,
    String? keteranganObat,
    int? pendaftaranId,
    File? potoObatFile, // Ini adalah objek File untuk gambar
  }) async {
    // URL endpoint relatif terhadap base URL yang dikelola oleh ServiceHttpClient
    final String path = '/resep/$resepId';
    
    // Karena kita mengirim file, kita masih perlu menggunakan http.MultipartRequest secara langsung.
    // ServiceHttpClient mungkin memiliki wrapper untuk ini, tapi untuk kasus umum ini,
    // kita akan membangun MultipartRequest di sini dan mengirimkannya melalui serviceHttpClient jika memungkinkan,
    // atau menggunakan http.MultipartRequest dan mengambil base URL dari serviceHttpClient.

    // Mengambil base URL dari ServiceHttpClient jika tersedia
    // Jika ServiceHttpClient Anda memiliki properti baseUrl:
    // final url = Uri.parse('${_serviceHttpClient.baseUrl}$path');
    // Jika tidak, Anda bisa membiarkan path saja dan berharap serviceHttpClient yang menanganinya
    // atau mengelola baseUrl di ServiceHttpClient dengan cara lain.
    // Untuk contoh ini, saya akan asumsikan ServiceHttpClient memiliki method untuk mengirim MultipartRequest.

    final request = http.MultipartRequest('POST', Uri.parse('${_serviceHttpClient.baseUrl}$path')); // Menggunakan baseUrl dari ServiceHttpClient

    // Tambahkan header otentikasi
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $_authToken', // Menggunakan _authToken yang diterima di konstruktor
    });

    // --- Tambahkan field teks ---
    request.fields['diagnosa'] = diagnosa;
    request.fields['patient_id'] = patientId.toString();

    if (keteranganObat != null && keteranganObat.isNotEmpty) {
      request.fields['keterangan_obat'] = keteranganObat;
    }
    if (pendaftaranId != null) {
      request.fields['pendaftaran_id'] = pendaftaranId.toString();
    }

    // --- PENTING: Tambahkan _method untuk spoofing PUT ---
    request.fields['_method'] = 'PUT';

    // --- Tambahkan file gambar jika ada ---
    if (potoObatFile != null) {
      final mimeTypeData = lookupMimeType(potoObatFile.path)?.split('/');
      
      request.files.add(await http.MultipartFile.fromPath(
        'poto_obat',
        potoObatFile.path,
        contentType: mimeTypeData != null && mimeTypeData.length == 2
            ? MediaType(mimeTypeData[0], mimeTypeData[1])
            : null,
      ));
    }

    try {
      // Mengirim request menggunakan service_http_client Anda
      // Anda perlu mengadaptasi bagian ini sesuai dengan metode yang ada di ServiceHttpClient Anda.
      // Contoh: Jika ServiceHttpClient Anda punya method `sendMultipartRequest(http.MultipartRequest request)`
      // final streamedResponse = await _serviceHttpClient.sendMultipartRequest(request);
      // Atau jika tidak ada method khusus, Anda tetap bisa pakai request.send()
      // karena ServiceHttpClient mungkin hanya membungkus konfigurasi dasar.

      final streamedResponse = await request.send(); // Menggunakan http.MultipartRequest.send()
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body), // Parsing respons JSON
          'statusCode': response.statusCode,
        };
      } else {
        String errorMessage = 'Gagal mengedit resep: ${response.statusCode}';
        try {
          final errorData = jsonDecode(response.body);
          if (errorData is Map && errorData.containsKey('message')) {
            errorMessage = errorData['message'];
          } else {
            errorMessage = response.body; // Tampilkan seluruh body jika bukan JSON message
          }
        } catch (e) {
          // Gagal parsing JSON error
          errorMessage = response.body;
        }

        return {
          'success': false,
          'message': errorMessage,
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan jaringan atau tak terduga: $e',
        'statusCode': 500,
      };
    }
  }
}