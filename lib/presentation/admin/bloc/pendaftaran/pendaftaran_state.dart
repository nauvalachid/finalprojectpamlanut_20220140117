part of 'pendaftaran_bloc.dart';

@immutable
abstract class PendaftaranState {}

/// State awal atau idle.
class PendaftaranInitial extends PendaftaranState {}

/// State ketika operasi sedang berlangsung (misalnya, memuat data).
class PendaftaranLoading extends PendaftaranState {}

/// State ketika operasi berhasil.
class PendaftaranLoaded extends PendaftaranState {
  final List<MelihatPendaftaranResponseModel> pendaftarans;
  PendaftaranLoaded(this.pendaftarans);
}

/// State ketika detail pendaftaran tunggal berhasil dimuat.
class PendaftaranDetailLoaded extends PendaftaranState {
  final MelihatPendaftaranResponseModel pendaftaran;
  PendaftaranDetailLoaded(this.pendaftaran);
}

/// State ketika operasi penambahan berhasil.
class PendaftaranAdded extends PendaftaranState {
  final TambahPendaftaranResponseModel response;
  PendaftaranAdded(this.response);
}

/// State ketika operasi edit (detail atau status) berhasil.
class PendaftaranEdited extends PendaftaranState {
  final dynamic response; // Bisa EditPendaftaranResponseModel atau EditStatusResponseModel
  PendaftaranEdited(this.response);
}

/// State ketika operasi penghapusan berhasil.
class PendaftaranDeleted extends PendaftaranState {
  final int id;
  PendaftaranDeleted(this.id);
}

/// State ketika terjadi kesalahan dalam operasi.
class PendaftaranError extends PendaftaranState {
  final String message;
  PendaftaranError(this.message);
}