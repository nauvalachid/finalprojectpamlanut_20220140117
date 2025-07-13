import 'package:bloc/bloc.dart';
import 'package:finalproject/data/model/request/admin/editstatus_request_model.dart';
import 'package:finalproject/data/model/request/pasien/editpendaftaran_request_model.dart';
import 'package:finalproject/data/model/request/pasien/tambahpendaftaran_request_model.dart';
import 'package:finalproject/data/model/response/admin/editstatus_response_model.dart';
import 'package:finalproject/data/model/response/admin/melihatpendaftaran_response_model.dart';
import 'package:finalproject/data/model/response/pasien/editpendaftaran_response_model.dart';
import 'package:finalproject/data/model/response/pasien/tambahpendaftaran_response_model.dart';
import 'package:finalproject/data/repository/pendaftaran_repository.dart';
// Hapus atau sesuaikan import ini jika memang tidak diperlukan atau duplikasi
// import 'package:finalproject/presentation/admin/bloc/pendaftaran/pendaftaran_bloc.dart';

part 'pendaftaran_event.dart';
part 'pendaftaran_state.dart';

class PendaftaranPasienBloc extends Bloc<PendaftaranPasienEvent, PendaftaranPasienState> {
  final PendaftaranRepository repository;

  PendaftaranPasienBloc(this.repository) : super(PendaftaranInitial()) {
    on<FetchAllPendaftaran>(_onFetchAllPendaftaran);
    on<FetchPendaftaranById>(_onFetchPendaftaranById);
    on<AddPendaftaran>(_onAddPendaftaran);
    on<EditPendaftaran>(_onEditPendaftaran);
    on<ChangePendaftaranStatus>(_onChangePendaftaranStatus);
    on<DeletePendaftaran>(_onDeletePendaftaran);
  }

  Future<void> _onFetchAllPendaftaran(
    FetchAllPendaftaran event,
    Emitter<PendaftaranPasienState> emit, // Diperbarui
  ) async {
    emit(PendaftaranLoading());
    try {
      final List<MelihatPendaftaranResponseModel> pendaftarans = await repository.getAllPendaftaran();
      emit(PendaftaranSuccess<List<MelihatPendaftaranResponseModel>>(pendaftarans));
    } catch (e) {
      emit(PendaftaranError('Gagal memuat semua pendaftaran: ${e.toString()}'));
    }
  }

  Future<void> _onFetchPendaftaranById(
    FetchPendaftaranById event,
    Emitter<PendaftaranPasienState> emit, // Diperbarui
  ) async {
    emit(PendaftaranLoading());
    try {
      final MelihatPendaftaranResponseModel pendaftaran = await repository.getPendaftaranById(event.id);
      emit(PendaftaranSuccess<MelihatPendaftaranResponseModel>(pendaftaran));
    } catch (e) {
      emit(PendaftaranError('Gagal memuat detail pendaftaran: ${e.toString()}'));
    }
  }

  Future<void> _onAddPendaftaran(
    AddPendaftaran event,
    Emitter<PendaftaranPasienState> emit, // Diperbarui
  ) async {
    emit(PendaftaranLoading());
    try {
      final TambahPendaftaranResponseModel response = await repository.addPendaftaran(event.request);
      emit(PendaftaranSuccess<TambahPendaftaranResponseModel>(response));
    } catch (e) {
      emit(PendaftaranError('Gagal menambahkan pendaftaran: ${e.toString()}'));
    }
  }

  Future<void> _onEditPendaftaran(
    EditPendaftaran event,
    Emitter<PendaftaranPasienState> emit, // Diperbarui
  ) async {
    emit(PendaftaranLoading());
    try {
      final EditPendaftaranResponseModel response = await repository.editPendaftaran(event.id, event.request);
      emit(PendaftaranSuccess<EditPendaftaranResponseModel>(response));
    } catch (e) {
      emit(PendaftaranError('Gagal mengedit pendaftaran: ${e.toString()}'));
    }
  }

  Future<void> _onChangePendaftaranStatus(
    ChangePendaftaranStatus event,
    Emitter<PendaftaranPasienState> emit, // Diperbarui
  ) async {
    emit(PendaftaranLoading());
    try {
      final EditStatusResponseModel response = await repository.editStatusPendaftaran(event.id, event.request);
      emit(PendaftaranSuccess<EditStatusResponseModel>(response));
    } catch (e) {
      emit(PendaftaranError('Gagal mengubah status pendaftaran: ${e.toString()}'));
    }
  }

  Future<void> _onDeletePendaftaran(
    DeletePendaftaran event,
    Emitter<PendaftaranPasienState> emit, // Diperbarui
  ) async {
    emit(PendaftaranLoading());
    try {
      final bool success = await repository.deletePendaftaran(event.id);
      if (success) {
        emit(PendaftaranSuccess<String>('Pendaftaran berhasil dihapus.'));
      } else {
        emit(PendaftaranError('Gagal menghapus pendaftaran.'));
      }
    } catch (e) {
      emit(PendaftaranError('Gagal menghapus pendaftaran: ${e.toString()}'));
    }
  }
}