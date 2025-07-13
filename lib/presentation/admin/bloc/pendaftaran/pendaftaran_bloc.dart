import 'package:bloc/bloc.dart';
import 'package:finalproject/data/model/request/admin/editstatus_request_model.dart';
import 'package:finalproject/data/model/request/pasien/editpendaftaran_request_model.dart';
import 'package:finalproject/data/model/request/pasien/tambahpendaftaran_request_model.dart';
import 'package:finalproject/data/model/response/admin/melihatpendaftaran_response_model.dart';
import 'package:finalproject/data/model/response/pasien/tambahpendaftaran_response_model.dart';
import 'package:finalproject/data/repository/pendaftaran_repository.dart';
import 'package:meta/meta.dart';

part 'pendaftaran_event.dart';
part 'pendaftaran_state.dart';

class PendaftaranBloc extends Bloc<PendaftaranEvent, PendaftaranState> {
  final PendaftaranRepository _pendaftaranRepository;

  PendaftaranBloc(this._pendaftaranRepository) : super(PendaftaranInitial()) {
    on<LoadAllPendaftaran>(_onLoadAllPendaftaran);
    on<LoadPendaftaranById>(_onLoadPendaftaranById);
    on<AddNewPendaftaran>(_onAddNewPendaftaran);
    on<EditExistingPendaftaran>(_onEditExistingPendaftaran);
    on<EditPendaftaranStatus>(_onEditPendaftaranStatus);
    on<DeleteExistingPendaftaran>(_onDeleteExistingPendaftaran);
  }

  Future<void> _onLoadAllPendaftaran(
    LoadAllPendaftaran event,
    Emitter<PendaftaranState> emit,
  ) async {
    emit(PendaftaranLoading());
    try {
      final pendaftarans = await _pendaftaranRepository.getAllPendaftaran();
      emit(PendaftaranLoaded(pendaftarans));
    } catch (e) {
      emit(PendaftaranError('Gagal memuat daftar pendaftaran: ${e.toString()}'));
    }
  }

  Future<void> _onLoadPendaftaranById(
    LoadPendaftaranById event,
    Emitter<PendaftaranState> emit,
  ) async {
    emit(PendaftaranLoading());
    try {
      final pendaftaran = await _pendaftaranRepository.getPendaftaranById(event.id);
      emit(PendaftaranDetailLoaded(pendaftaran));
    } catch (e) {
      emit(PendaftaranError('Gagal memuat detail pendaftaran: ${e.toString()}'));
    }
  }

  Future<void> _onAddNewPendaftaran(
    AddNewPendaftaran event,
    Emitter<PendaftaranState> emit,
  ) async {
    emit(PendaftaranLoading());
    try {
      final response = await _pendaftaranRepository.addPendaftaran(event.request);
      emit(PendaftaranAdded(response));
      // Opsional: Setelah menambah, bisa langsung memuat ulang daftar
      // add(LoadAllPendaftaran());
    } catch (e) {
      emit(PendaftaranError('Gagal menambahkan pendaftaran: ${e.toString()}'));
    }
  }

  Future<void> _onEditExistingPendaftaran(
    EditExistingPendaftaran event,
    Emitter<PendaftaranState> emit,
  ) async {
    emit(PendaftaranLoading());
    try {
      final response = await _pendaftaranRepository.editPendaftaran(event.id, event.request);
      emit(PendaftaranEdited(response));
      // Opsional: Setelah mengedit, bisa langsung memuat ulang detail atau daftar
      // add(LoadPendaftaranById(event.id));
    } catch (e) {
      emit(PendaftaranError('Gagal mengedit pendaftaran: ${e.toString()}'));
    }
  }

  Future<void> _onEditPendaftaranStatus(
    EditPendaftaranStatus event,
    Emitter<PendaftaranState> emit,
  ) async {
    emit(PendaftaranLoading());
    try {
      final response = await _pendaftaranRepository.editStatusPendaftaran(event.id, event.request);
      emit(PendaftaranEdited(response));
      // Opsional: Setelah mengedit status, bisa langsung memuat ulang detail atau daftar
      // add(LoadPendaftaranById(event.id));
    } catch (e) {
      emit(PendaftaranError('Gagal mengubah status pendaftaran: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteExistingPendaftaran(
    DeleteExistingPendaftaran event,
    Emitter<PendaftaranState> emit,
  ) async {
    emit(PendaftaranLoading());
    try {
      final success = await _pendaftaranRepository.deletePendaftaran(event.id);
      if (success) {
        emit(PendaftaranDeleted(event.id));
        // Opsional: Setelah menghapus, bisa langsung memuat ulang daftar
        // add(LoadAllPendaftaran());
      } else {
        emit(PendaftaranError('Pendaftaran gagal dihapus (respons API tidak sukses).'));
      }
    } catch (e) {
      emit(PendaftaranError('Gagal menghapus pendaftaran: ${e.toString()}'));
    }
  }
}