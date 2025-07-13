// lib/presentation/admin/bloc/profile/profile_admin_bloc.dart

import 'package:finalproject/data/model/response/admin/editprofileadmin_response_model.dart';
import 'package:finalproject/data/model/response/admin/melihatprofileadmin_response_model.dart';
import 'package:finalproject/data/model/response/admin/tambahadminprofile_response_model.dart';
import 'package:finalproject/data/repository/admin_profile_repository.dart';
import 'package:finalproject/presentation/admin/bloc/profile/profile_admin_event.dart';
import 'package:finalproject/presentation/admin/bloc/profile/profile_admin_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Asumsi nama BLoC Anda adalah AdminProfileBloc, bukan ProfileAdminBloc
class AdminProfileBloc extends Bloc<AdminProfileEvent, AdminProfileState> {
  final AdminProfileRepository adminProfileRepository;

  AdminProfileBloc({required this.adminProfileRepository}) : super(AdminProfileInitial()) {
    on<GetAdminProfile>(_onGetAdminProfile);
    on<AddAdminProfile>(_onAddAdminProfile);
    on<UpdateAdminProfile>(_onUpdateAdminProfile);
  }

  Future<void> _onGetAdminProfile(GetAdminProfile event, Emitter<AdminProfileState> emit) async {
    emit(AdminProfileLoading());
    try {
      final MelihatAdminProfileResponseModel response = await adminProfileRepository.getAdminProfile(event.adminId);
      if (response.data != null) {
        emit(AdminProfileLoaded(response.data!)); // response.data sekarang bertipe AdminProfileData
      } else {
        emit(const AdminProfileError('Data profil admin tidak ditemukan.'));
      }
    } catch (e) {
      emit(AdminProfileError('Gagal memuat profil admin: ${e.toString()}'));
    }
  }

  Future<void> _onAddAdminProfile(AddAdminProfile event, Emitter<AdminProfileState> emit) async {
    emit(AdminProfileLoading());
    try {
      final TambahAdminProfileResponseModel response = await adminProfileRepository.addAdminProfile(event.request);
      if (response.data != null) {
        emit(AdminProfileAdded(response.data!)); // response.data sekarang bertipe AdminProfileData
      } else {
        emit(const AdminProfileError('Gagal menambahkan profil admin: Data respons kosong.'));
      }
    } catch (e) {
      emit(AdminProfileError('Gagal menambahkan profil admin: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateAdminProfile(UpdateAdminProfile event, Emitter<AdminProfileState> emit) async {
    emit(AdminProfileLoading());
    try {
      final UpdateAdminProfileResponseModel response = await adminProfileRepository.updateAdminProfile(event.adminId, event.request);
      if (response.data != null) {
        emit(AdminProfileUpdated(response.data!)); // response.data sekarang bertipe AdminProfileData
      } else {
        emit(const AdminProfileError('Gagal mengupdate profil admin: Data respons kosong.'));
      }
    } catch (e) {
      emit(AdminProfileError('Gagal mengupdate profil admin: ${e.toString()}'));
    }
  }
}