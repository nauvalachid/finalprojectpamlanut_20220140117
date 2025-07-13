// import 'package:equatable/equatable.dart'; // Equatable tidak lagi digunakan

// Base class untuk semua PasienProfileState
// Tidak lagi extends Equatable
import 'package:finalproject/data/model/response/pasien/editprofilepasien_response_model.dart';
import 'package:finalproject/data/model/response/pasien/melihatprofilepasien_response_model.dart';
import 'package:finalproject/data/model/response/pasien/tambahprofilepasien_response_model.dart';

abstract class PasienProfileState {
  const PasienProfileState();

  // Karena tidak menggunakan Equatable, tidak perlu mengoverride props
}

// State awal saat BLoC pertama kali diinisialisasi
class PasienProfileInitial extends PasienProfileState {}

// State saat operasi sedang berlangsung (misalnya, fetching data)
class PasienProfileLoading extends PasienProfileState {}

// State saat profil pasien berhasil dimuat
class PasienProfileLoaded extends PasienProfileState {
  final MelihatProfilePasienResponseModel profile;

  const PasienProfileLoaded(this.profile);

  // Tidak perlu override props
}

// State saat profil pasien berhasil dibuat
class PasienProfileCreated extends PasienProfileState {
  final TambahProfilePasienResponseModel response;

  const PasienProfileCreated(this.response);

  // Tidak perlu override props
}

// State saat profil pasien berhasil diperbarui
class PasienProfileUpdated extends PasienProfileState {
  final EditProfilePasienResponseModel response;

  const PasienProfileUpdated(this.response);

  // Tidak perlu override props
}

// State saat profil pasien berhasil dihapus
class PasienProfileDeleted extends PasienProfileState {
  final String message; // Bisa juga tidak ada data, hanya pesan sukses

  const PasienProfileDeleted(this.message);

  // Tidak perlu override props
}

// State saat terjadi error
class PasienProfileError extends PasienProfileState {
  final String message;

  const PasienProfileError(this.message);

  // Tidak perlu override props
}
