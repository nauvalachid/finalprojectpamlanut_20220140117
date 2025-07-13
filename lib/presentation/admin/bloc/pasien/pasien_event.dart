import 'package:finalproject/data/model/request/admin/editpasien_request_model.dart';
import 'package:finalproject/data/model/request/admin/tambahpasien_request_model.dart';

/// Kelas dasar abstrak untuk semua event terkait Pasien.
abstract class PasienEvent {
  const PasienEvent();
}

/// Event untuk memuat semua daftar pasien.
class GetPasienEvent extends PasienEvent {
  const GetPasienEvent();
}

/// Event untuk memuat detail pasien berdasarkan ID.
class GetPasienDetailEvent extends PasienEvent {
  final int id;

  const GetPasienDetailEvent(this.id);
}

/// Event untuk menambahkan pasien baru.
class AddPasienEvent extends PasienEvent {
  final TambahPasienRequestModel request;

  const AddPasienEvent(this.request);
}

/// Event untuk mengedit data pasien yang sudah ada.
class EditPasienEvent extends PasienEvent {
  final int id;
  final EditPasienRequestModel request;

  const EditPasienEvent(this.id, this.request);
}

/// Event untuk menghapus pasien berdasarkan ID.
class DeletePasienEvent extends PasienEvent {
  final int id;

  const DeletePasienEvent(this.id);
}