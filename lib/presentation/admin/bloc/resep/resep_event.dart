// finalproject/presentation/admin/bloc/resep/resep_event.dart

import 'dart:io';

abstract class ResepEvent {
  const ResepEvent();
}

class AddResep extends ResepEvent {
  final int patientId;
  final String diagnosa;
  final int pendaftaranId;
  final String keteranganObat;
  final File? potoObatFile;

  const AddResep({
    required this.patientId,
    required this.diagnosa,
    required this.pendaftaranId,
    required this.keteranganObat,
    this.potoObatFile,
  });
}

class EditResep extends ResepEvent {
  final int resepId;
  final int? patientId;
  final String diagnosa;
  final String? keteranganObat;
  final int? pendaftaranId;
  final File? potoObatFile;

  const EditResep({
    required this.resepId,
    this.patientId,
    required this.diagnosa,
    this.keteranganObat,
    this.pendaftaranId,
    this.potoObatFile,
  });
}

class LoadResepByPatientId extends ResepEvent {
  final int patientId;
  const LoadResepByPatientId({required this.patientId});
}

class LoadResepByPendaftaranId extends ResepEvent {
  final int pendaftaranId;
  const LoadResepByPendaftaranId({required this.pendaftaranId});
}

// **EVENT BARU UNTUK PASIEN**
class LoadResepForAuthenticatedPasien extends ResepEvent {
  const LoadResepForAuthenticatedPasien();
}

class ExportResepPdf extends ResepEvent {
  final int resepId;
  const ExportResepPdf({required this.resepId});
}