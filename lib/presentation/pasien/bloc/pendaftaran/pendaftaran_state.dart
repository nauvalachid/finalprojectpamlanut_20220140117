part of 'pendaftaran_bloc.dart';

abstract class PendaftaranPasienState {}

/// State awal atau ketika tidak ada operasi yang berlangsung.
class PendaftaranInitial extends PendaftaranPasienState {}

/// State ketika operasi sedang berlangsung (misal: memuat data, mengirim data).
class PendaftaranLoading extends PendaftaranPasienState {}

/// State ketika operasi berhasil.
class PendaftaranSuccess<T> extends PendaftaranPasienState {
  final T data;

  PendaftaranSuccess(this.data);
}

/// State ketika terjadi kesalahan dalam operasi.
class PendaftaranError extends PendaftaranPasienState {
  final String message;

  PendaftaranError(this.message);
}