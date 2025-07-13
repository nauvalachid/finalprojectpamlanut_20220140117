// import 'package:equatable/equatable.dart'; // Equatable tidak lagi digunakan

// Base class untuk semua PasienProfileEvent
// Tidak lagi extends Equatable
import 'package:finalproject/data/model/request/pasien/editprofilepasien_request_model.dart';
import 'package:finalproject/data/model/request/pasien/tambahprofilepasien_request_model.dart';

abstract class PasienProfileEvent {
  const PasienProfileEvent();

  // Karena tidak menggunakan Equatable, tidak perlu mengoverride props
  // Jika Anda ingin perbandingan kustom, Anda perlu mengimplementasikan == dan hashCode secara manual
}

// Event untuk mengambil profil pasien
class GetPasienProfileEvent extends PasienProfileEvent {
  final String token;

  const GetPasienProfileEvent(this.token);

  // Tidak perlu override props
}

// Event untuk membuat profil pasien
class CreatePasienProfileEvent extends PasienProfileEvent {
  final String token;
  final TambahProfilePasienRequestModel requestModel;

  const CreatePasienProfileEvent({required this.token, required this.requestModel});

  // Tidak perlu override props
}

// Event untuk memperbarui profil pasien
class UpdatePasienProfileEvent extends PasienProfileEvent {
  final String token;
  final EditProfilePasienRequestModel requestModel;

  const UpdatePasienProfileEvent({required this.token, required this.requestModel});

  // Tidak perlu override props
}

// Event untuk menghapus profil pasien
class DeletePasienProfileEvent extends PasienProfileEvent {
  final String token;

  const DeletePasienProfileEvent(this.token);

  // Tidak perlu override props
}
