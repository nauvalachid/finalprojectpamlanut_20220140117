import 'package:finalproject/data/model/response/admin/editpasien_response_model.dart';
import 'package:finalproject/data/model/response/admin/melihatpasien_response_model.dart';
import 'package:finalproject/data/model/response/admin/tambahpasien_response_model.dart';


/// Kelas dasar abstrak untuk semua state terkait Pasien.
abstract class PasienState {
  const PasienState();
}

/// State awal ketika BLoC belum melakukan apa-apa.
class PasienInitial extends PasienState {}

/// State ketika operasi sedang berlangsung (misalnya, memuat data, mengirim data).
class PasienLoading extends PasienState {}

/// State ketika daftar pasien berhasil dimuat.
class PasienLoaded extends PasienState {
  final List<MelihatPasienResponseModel> pasien;

  const PasienLoaded(this.pasien);
}

/// State ketika detail pasien berhasil dimuat.
class PasienDetailLoaded extends PasienState {
  final MelihatPasienResponseModel pasien;

  const PasienDetailLoaded(this.pasien);
}

/// State ketika pasien berhasil ditambahkan.
class PasienAdded extends PasienState {
  final TambahPasienResponseModel pasien;

  const PasienAdded(this.pasien);
}

/// State ketika pasien berhasil diedit.
class PasienEdited extends PasienState {
  final EditPasienResponseModel pasien;

  const PasienEdited(this.pasien);
}

/// State ketika pasien berhasil dihapus.
class PasienDeleted extends PasienState {
  final String message;

  const PasienDeleted(this.message);
}

/// State ketika terjadi kesalahan dalam operasi.
class PasienError extends PasienState {
  final String message;

  const PasienError(this.message);
}