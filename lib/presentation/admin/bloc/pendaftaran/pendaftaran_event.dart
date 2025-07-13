// file: lib/presentation/admin/bloc/pendaftaran/pendaftaran_event.dart
// (Atau sesuaikan path Anda)

part of 'pendaftaran_bloc.dart';

@immutable
abstract class PendaftaranEvent {}

class LoadAllPendaftaran extends PendaftaranEvent {}

class LoadPendaftaranById extends PendaftaranEvent {
  final int id;
  LoadPendaftaranById(this.id);
}

class AddNewPendaftaran extends PendaftaranEvent {
  final TambahPendaftaranRequestModel request;
  AddNewPendaftaran(this.request);
}

class EditExistingPendaftaran extends PendaftaranEvent {
  final int id;
  final EditPendaftaranRequestModel request;
  EditExistingPendaftaran(this.id, this.request);
}

class EditPendaftaranStatus extends PendaftaranEvent {
  final int id;
  final EditStatusRequestModel request;
  EditPendaftaranStatus(this.id, this.request);
}

class DeleteExistingPendaftaran extends PendaftaranEvent {
  final int id;
  DeleteExistingPendaftaran(this.id);
}