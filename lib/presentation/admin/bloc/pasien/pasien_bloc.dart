import 'package:finalproject/presentation/admin/bloc/pasien/pasien_event.dart';
import 'package:finalproject/presentation/admin/bloc/pasien/pasien_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/data/repository/pasien_repository.dart';

/// BLoC untuk mengelola semua logika bisnis terkait entitas Pasien.
class PasienBloc extends Bloc<PasienEvent, PasienState> {
  final PasienRepository pasienRepository;

  PasienBloc({required this.pasienRepository}) : super(PasienInitial()) {
    on<GetPasienEvent>(_onGetPasien);
    on<GetPasienDetailEvent>(_onGetPasienDetail);
    on<AddPasienEvent>(_onAddPasien);
    on<EditPasienEvent>(_onEditPasien);
    on<DeletePasienEvent>(_onDeletePasien);
  }

  /// Handler untuk event [GetPasienEvent].
  /// Memuat semua data pasien dari repository dan memancarkan state yang sesuai.
  Future<void> _onGetPasien(GetPasienEvent event, Emitter<PasienState> emit) async {
    emit(PasienLoading());
    try {
      final pasienList = await pasienRepository.getPasien();
      emit(PasienLoaded(pasienList));
    } catch (e) {
      emit(PasienError('Gagal memuat daftar pasien: ${e.toString()}'));
    }
  }

  /// Handler untuk event [GetPasienDetailEvent].
  /// Memuat detail pasien berdasarkan ID dan memancarkan state yang sesuai.
  Future<void> _onGetPasienDetail(GetPasienDetailEvent event, Emitter<PasienState> emit) async {
    emit(PasienLoading());
    try {
      final pasien = await pasienRepository.getPasienById(event.id);
      emit(PasienDetailLoaded(pasien));
    } catch (e) {
      emit(PasienError('Gagal memuat detail pasien: ${e.toString()}'));
    }
  }

  /// Handler untuk event [AddPasienEvent].
  /// Menambahkan pasien baru dan memancarkan state yang sesuai.
  Future<void> _onAddPasien(AddPasienEvent event, Emitter<PasienState> emit) async {
    emit(PasienLoading());
    try {
      final newPasien = await pasienRepository.addPasien(event.request);
      emit(PasienAdded(newPasien));
    } catch (e) {
      emit(PasienError('Gagal menambahkan pasien: ${e.toString()}'));
    }
  }

  /// Handler untuk event [EditPasienEvent].
  /// Mengedit data pasien dan memancarkan state yang sesuai.
  Future<void> _onEditPasien(EditPasienEvent event, Emitter<PasienState> emit) async {
    emit(PasienLoading());
    try {
      final updatedPasien = await pasienRepository.editPasien(event.id, event.request);
      emit(PasienEdited(updatedPasien));
    } catch (e) {
      emit(PasienError('Gagal mengedit pasien: ${e.toString()}'));
    }
  }

  /// Handler untuk event [DeletePasienEvent].
  /// Menghapus pasien dan memancarkan state yang sesuai.
  Future<void> _onDeletePasien(DeletePasienEvent event, Emitter<PasienState> emit) async {
    emit(PasienLoading());
    try {
      final success = await pasienRepository.deletePasien(event.id);
      if (success) {
        emit(const PasienDeleted('Pasien berhasil dihapus.'));
      } else {
        emit(const PasienError('Gagal menghapus pasien.'));
      }
    } catch (e) {
      emit(PasienError('Terjadi kesalahan saat menghapus pasien: ${e.toString()}'));
    }
  }
}