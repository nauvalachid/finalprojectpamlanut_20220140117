import 'package:finalproject/data/repository/jadwal_repository.dart';
import 'package:finalproject/presentation/admin/bloc/jadwal/jadwal_event.dart';
import 'package:finalproject/presentation/admin/bloc/jadwal/jadwal_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer'; // Untuk log

/// JadwalBloc bertanggung jawab untuk mengelola state terkait jadwal.
/// Ini menerima JadwalEvent, berinteraksi dengan JadwalRepository,
/// dan memancarkan JadwalState baru.
class JadwalBloc extends Bloc<JadwalEvent, JadwalState> {
  final JadwalRepository jadwalRepository;

  JadwalBloc(this.jadwalRepository) : super(JadwalInitial()) {
    // Mendaftarkan handler untuk setiap event
    on<LoadJadwals>(_onLoadJadwals);
    on<AddJadwal>(_onAddJadwal);
    on<EditJadwal>(_onEditJadwal);
    on<DeleteJadwal>(_onDeleteJadwal);
    on<LoadJadwalDetail>(_onLoadJadwalDetail);
  }

  /// Handler untuk event [LoadJadwals].
  /// Memuat semua jadwal dan memancarkan JadwalLoaded atau JadwalError.
  Future<void> _onLoadJadwals(LoadJadwals event, Emitter<JadwalState> emit) async {
    emit(JadwalLoading()); // Memancarkan state loading
    try {
      final jadwals = await jadwalRepository.getJadwals();
      log('BLoC Success LoadJadwals: ${jadwals.length} items');
      emit(JadwalLoaded(jadwals)); // Memancarkan state loaded
    } catch (e) {
      log('BLoC Error LoadJadwals: $e');
      emit(JadwalError(e.toString())); // Memancarkan state error
    }
  }

  /// Handler untuk event [AddJadwal].
  /// Menambahkan jadwal baru dan memancarkan JadwalActionSuccess atau JadwalError.
  Future<void> _onAddJadwal(AddJadwal event, Emitter<JadwalState> emit) async {
    // Anda bisa memilih untuk tidak memancarkan loading di sini
    // jika Anda ingin UI tetap menampilkan data lama sampai aksi selesai.
    // emit(JadwalLoading());
    try {
      final response = await jadwalRepository.addJadwal(event.request);
      log('BLoC Success AddJadwal: ID ${response.id}');
      emit(const JadwalActionSuccess('Jadwal berhasil ditambahkan!'));
      // Setelah sukses, muat ulang daftar jadwal untuk memperbarui UI
      add(const LoadJadwals());
    } catch (e) {
      log('BLoC Error AddJadwal: $e');
      emit(JadwalError(e.toString()));
    }
  }

  /// Handler untuk event [EditJadwal].
  /// Mengedit jadwal dan memancarkan JadwalActionSuccess atau JadwalError.
  Future<void> _onEditJadwal(EditJadwal event, Emitter<JadwalState> emit) async {
    // emit(JadwalLoading()); // Opsional
    try {
      final response = await jadwalRepository.editJadwal(event.id, event.request);
      log('BLoC Success EditJadwal: ID ${response.id}');
      emit(const JadwalActionSuccess('Jadwal berhasil diperbarui!'));
      // Setelah sukses, muat ulang daftar jadwal untuk memperbarui UI
      add(const LoadJadwals());
    } catch (e) {
      log('BLoC Error EditJadwal: $e');
      emit(JadwalError(e.toString()));
    }
  }

  /// Handler untuk event [DeleteJadwal].
  /// Menghapus jadwal dan memancarkan JadwalActionSuccess atau JadwalError.
  Future<void> _onDeleteJadwal(DeleteJadwal event, Emitter<JadwalState> emit) async {
    // emit(JadwalLoading()); // Opsional
    try {
      final success = await jadwalRepository.deleteJadwal(event.id);
      if (success) {
        log('BLoC Success DeleteJadwal: ID ${event.id}');
        emit(const JadwalActionSuccess('Jadwal berhasil dihapus!'));
        // Setelah sukses, muat ulang daftar jadwal untuk memperbarui UI
        add(const LoadJadwals());
      } else {
        // Ini mungkin terjadi jika deleteJadwal mengembalikan false tanpa melempar exception
        // Meskipun repository sekarang melempar exception, ini adalah fallback yang baik.
        log('BLoC Error DeleteJadwal: Gagal menghapus (respons false)');
        emit(const JadwalError('Gagal menghapus jadwal.'));
      }
    } catch (e) {
      log('BLoC Error DeleteJadwal: $e');
      emit(JadwalError(e.toString()));
    }
  }

  /// Handler untuk event [LoadJadwalDetail].
  /// Memuat detail jadwal tunggal dan memancarkan JadwalDetailLoaded atau JadwalError.
  Future<void> _onLoadJadwalDetail(LoadJadwalDetail event, Emitter<JadwalState> emit) async {
    emit(JadwalLoading());
    try {
      final jadwal = await jadwalRepository.getJadwalById(event.id);
      log('BLoC Success LoadJadwalDetail: ID ${jadwal.id}');
      emit(JadwalDetailLoaded(jadwal));
    } catch (e) {
      log('BLoC Error LoadJadwalDetail: $e');
      emit(JadwalError(e.toString()));
    }
  }
}