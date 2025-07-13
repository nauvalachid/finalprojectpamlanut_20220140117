// lib/presentation/admin/bloc/profile/profile_admin_state.dart

import 'package:finalproject/data/model/adminprofile_data.dart';
import 'package:flutter/material.dart'; // Tetap ada jika Anda menggunakannya

@immutable
abstract class AdminProfileState {
  const AdminProfileState();
}

class AdminProfileInitial extends AdminProfileState {}

class AdminProfileLoading extends AdminProfileState {}

class AdminProfileLoaded extends AdminProfileState {
  final AdminProfileData adminProfile; // <--- Ganti 'Data' menjadi 'AdminProfileData'

  const AdminProfileLoaded(this.adminProfile);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminProfileLoaded &&
          runtimeType == other.runtimeType &&
          adminProfile == other.adminProfile;

  @override
  int get hashCode => adminProfile.hashCode;

  AdminProfileLoaded copyWith({
    AdminProfileData? adminProfile,
  }) {
    return AdminProfileLoaded(
      adminProfile ?? this.adminProfile,
    );
  }
}

class AdminProfileAdded extends AdminProfileState {
  final AdminProfileData newAdminProfile; // <--- Ganti 'Data' menjadi 'AdminProfileData'

  const AdminProfileAdded(this.newAdminProfile);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminProfileAdded &&
          runtimeType == other.runtimeType &&
          newAdminProfile == other.newAdminProfile;

  @override
  int get hashCode => newAdminProfile.hashCode;

  AdminProfileAdded copyWith({
    AdminProfileData? newAdminProfile,
  }) {
    return AdminProfileAdded(
      newAdminProfile ?? this.newAdminProfile,
    );
  }
}

class AdminProfileUpdated extends AdminProfileState {
  final AdminProfileData updatedAdminProfile; // <--- Ganti 'Data' menjadi 'AdminProfileData'

  const AdminProfileUpdated(this.updatedAdminProfile);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminProfileUpdated &&
          runtimeType == other.runtimeType &&
          updatedAdminProfile == other.updatedAdminProfile;

  @override
  int get hashCode => updatedAdminProfile.hashCode;

  AdminProfileUpdated copyWith({
    AdminProfileData? updatedAdminProfile,
  }) {
    return AdminProfileUpdated(
      updatedAdminProfile ?? this.updatedAdminProfile,
    );
  }
}

class AdminProfileError extends AdminProfileState {
  final String message;

  const AdminProfileError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminProfileError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}