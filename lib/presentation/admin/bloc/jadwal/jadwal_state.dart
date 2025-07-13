import 'package:finalproject/data/model/response/melihatjadwal_response_model.dart';

/// Kelas dasar abstrak untuk semua state terkait jadwal.
/// Tanpa Equatable, perbandingan objek akan menggunakan default Dart (perbandingan referensi).
abstract class JadwalState {
  const JadwalState();
}

/// State awal ketika BLoC baru diinisialisasi.
class JadwalInitial extends JadwalState {}

/// State ketika data jadwal sedang dimuat.
class JadwalLoading extends JadwalState {}

/// State ketika daftar jadwal berhasil dimuat.
class JadwalLoaded extends JadwalState {
  final List<MelihatJadwalResponseModel> jadwals;

  const JadwalLoaded(this.jadwals);

  // Tanpa Equatable, tidak perlu mengimplementasikan props atau operator ==
}

/// State ketika detail jadwal tunggal berhasil dimuat.
class JadwalDetailLoaded extends JadwalState {
  final MelihatJadwalResponseModel jadwal;

  const JadwalDetailLoaded(this.jadwal);

  // Tanpa Equatable
}

/// State ketika operasi jadwal (add, edit, delete) berhasil.
class JadwalActionSuccess extends JadwalState {
  final String message;

  const JadwalActionSuccess(this.message);

  // Tanpa Equatable
}

/// State ketika terjadi kesalahan dalam operasi jadwal.
class JadwalError extends JadwalState {
  final String message;

  const JadwalError(this.message);

  // Tanpa Equatable
}
