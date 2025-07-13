// lib/bloc/admin_profile/admin_profile_event.dart

import 'package:finalproject/data/model/request/admin/editadminprofile_request_model.dart';
import 'package:finalproject/data/model/request/admin/tambahadminprofile_request_model.dart';

/// Abstract class dasar untuk semua event terkait Admin Profile.
abstract class AdminProfileEvent {
  const AdminProfileEvent();

  // Karena tidak menggunakan equatable, kita bisa memilih untuk tidak mengoverride == dan hashCode
  // jika setiap event baru dianggap unik dan selalu perlu diproses.
  // Jika Anda ingin event yang sama (dengan data yang sama) tidak diproses berulang,
  // Anda perlu mengimplementasikan == dan hashCode secara manual di setiap subclass.
}

/// Event untuk memuat/melihat detail profil admin berdasarkan ID.
class GetAdminProfile extends AdminProfileEvent {
  final int adminId;

  const GetAdminProfile(this.adminId);

  // Implementasi manual untuk kesetaraan event (opsional, tergantung kebutuhan)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetAdminProfile &&
          runtimeType == other.runtimeType &&
          adminId == other.adminId;

  @override
  int get hashCode => adminId.hashCode;
}

/// Event untuk menambahkan profil admin baru.
class AddAdminProfile extends AdminProfileEvent {
  final AddAdminProfileRequest request;

  const AddAdminProfile(this.request);

  // Implementasi manual untuk kesetaraan event (opsional)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddAdminProfile &&
          runtimeType == other.runtimeType &&
          request == other.request; // Membutuhkan operator == pada AddAdminProfileRequest

  @override
  int get hashCode => request.hashCode;
}

/// Event untuk mengupdate profil admin yang sudah ada.
class UpdateAdminProfile extends AdminProfileEvent {
  final int adminId;
  final UpdateAdminProfileRequest request;

  const UpdateAdminProfile({required this.adminId, required this.request});

  // Implementasi manual untuk kesetaraan event (opsional)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateAdminProfile &&
          runtimeType == other.runtimeType &&
          adminId == other.adminId &&
          request == other.request; // Membutuhkan operator == pada UpdateAdminProfileRequest

  @override
  int get hashCode => adminId.hashCode ^ request.hashCode;
}