import 'dart:io';
// Request Model (optional, but good practice for larger applications)
class ResepRequest {
  final int patientId;
  final String diagnosa;
  final File? potoObat; // Made nullable as it's a file
  final int? pendaftaranId;
  final String keteranganObat;

  ResepRequest({
    required this.patientId,
    required this.diagnosa,
    this.potoObat,
    this.pendaftaranId,
    required this.keteranganObat,
  });

  // You might not directly use this toFormData for http.MultipartRequest,
  // but it's good for understanding the structure.
  Map<String, String> toFormData() {
    return {
      'patient_id': patientId.toString(),
      'diagnosa': diagnosa,
      'pendaftaran_id': pendaftaranId.toString(),
      'keterangan_obat': keteranganObat,
    };
  }
}

