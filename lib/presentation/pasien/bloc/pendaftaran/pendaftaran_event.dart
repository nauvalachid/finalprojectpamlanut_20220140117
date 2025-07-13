part of 'pendaftaran_bloc.dart';

abstract class PendaftaranPasienEvent {}

/// Event untuk memuat semua pendaftaran.
class FetchAllPendaftaran extends PendaftaranPasienEvent {}

/// Event untuk memuat detail pendaftaran berdasarkan ID.
class FetchPendaftaranById extends PendaftaranPasienEvent {
  final int id;

  FetchPendaftaranById(this.id);
}

/// Event untuk menambahkan pendaftaran baru.
class AddPendaftaran extends PendaftaranPasienEvent {
  final TambahPendaftaranRequestModel request;

  AddPendaftaran(this.request);
}

/// Event untuk mengedit pendaftaran yang sudah ada.
class EditPendaftaran extends PendaftaranPasienEvent {
  final int id;
  final EditPendaftaranRequestModel request;

  EditPendaftaran(this.id, this.request);
}

/// Event untuk mengubah status pendaftaran.
class ChangePendaftaranStatus extends PendaftaranPasienEvent {
  final int id;
  final EditStatusRequestModel request; // Asumsi ada model EditStatusRequestModel

  ChangePendaftaranStatus(this.id, this.request);
}

/// Event untuk menghapus pendaftaran.
class DeletePendaftaran extends PendaftaranPasienEvent {
  final int id;

  DeletePendaftaran(this.id);
}