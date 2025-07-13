import 'package:finalproject/data/model/request/admin/editjadwal_request_model.dart';
import 'package:finalproject/data/model/request/admin/tambahjadwal_request_model.dart';

/// Kelas dasar abstrak untuk semua event terkait jadwal.
/// Tanpa Equatable, perbandingan objek akan menggunakan default Dart (perbandingan referensi).
abstract class JadwalEvent {
  const JadwalEvent();
}

/// Event untuk memuat daftar jadwal.
class LoadJadwals extends JadwalEvent {
  const LoadJadwals();
}

/// Event untuk menambahkan jadwal baru.
class AddJadwal extends JadwalEvent {
  final TambahJadwalRequestModel request;

  const AddJadwal(this.request);
}

/// Event untuk mengedit jadwal yang sudah ada.
class EditJadwal extends JadwalEvent {
  final int id;
  final EditJadwalRequestModel request;

  const EditJadwal(this.id, this.request);
}

/// Event untuk menghapus jadwal.
class DeleteJadwal extends JadwalEvent {
  final int id;

  const DeleteJadwal(this.id);
}

/// Event untuk memuat detail jadwal tunggal.
class LoadJadwalDetail extends JadwalEvent {
  final int id;

  const LoadJadwalDetail(this.id);
}
