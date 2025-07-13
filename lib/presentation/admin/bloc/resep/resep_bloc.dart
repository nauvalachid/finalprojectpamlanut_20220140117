import 'package:bloc/bloc.dart';
import 'package:finalproject/data/model/request/admin/tambahresep_request.model.dart';
import 'package:finalproject/data/repository/resep_repository.dart';
import 'package:finalproject/presentation/admin/bloc/resep/resep_event.dart';
import 'package:finalproject/presentation/admin/bloc/resep/resep_state.dart';
import 'dart:developer'; // Untuk log
import 'package:path_provider/path_provider.dart'; // <<<--- TAMBAH INI
import 'dart:io'; // <<<--- TAMBAH INI
import 'dart:typed_data'; // <<<--- TAMBAH INI (untuk Uint8List)

class ResepBloc extends Bloc<ResepEvent, ResepState> {
  final ResepRepository _resepRepository;

  ResepBloc({required ResepRepository resepRepository})
      : _resepRepository = resepRepository,
        super(ResepInitial()) {
    on<AddResep>(_onAddResep);
    on<EditResep>(_onEditResep);
    on<LoadResepByPatientId>(_onLoadResepByPatientId);
    on<LoadResepByPendaftaranId>(_onLoadResepByPendaftaranId);
    on<LoadResepForAuthenticatedPasien>(_onLoadResepForAuthenticatedPasien);
    on<ExportResepPdf>(_onExportResepPdf); // <<<--- Sudah ada, bagus!
  }

  Future<void> _onAddResep(AddResep event, Emitter<ResepState> emit) async {
    emit(ResepLoading());
    try {
      final resepRequest = ResepRequest(
        patientId: event.patientId,
        diagnosa: event.diagnosa,
        pendaftaranId: event.pendaftaranId,
        keteranganObat: event.keteranganObat,
        potoObat: event.potoObatFile,
      );

      final responseData = await _resepRepository.tambahResep(resepRequest);

      if (responseData.message != null && responseData.message!.contains("berhasil")) {
        emit(ResepAddSuccess(responseData));
      } else {
        emit(ResepError(responseData.message ?? 'Gagal menambahkan resep.'));
      }
    } catch (e) {
      log('ResepBloc: Error menambahkan resep: $e');
      emit(ResepError('Gagal menambahkan resep: $e'));
    }
  }

  Future<void> _onEditResep(EditResep event, Emitter<ResepState> emit) async {
    emit(ResepLoading());
    try {
      final responseData = await _resepRepository.editResep(
        resepId: event.resepId,
        patientId: event.patientId!,
        diagnosa: event.diagnosa,
        keteranganObat: event.keteranganObat,
        pendaftaranId: event.pendaftaranId,
        potoObatFile: event.potoObatFile,
      );

      if (responseData.message != null && responseData.message!.contains("berhasil")) {
        emit(ResepEditSuccess(responseData));
      } else {
        emit(ResepError(responseData.message ?? 'Gagal mengedit resep.'));
      }
    } catch (e) {
      log('ResepBloc: Error mengedit resep: $e');
      emit(ResepError('Gagal mengedit resep: $e'));
    }
  }

  Future<void> _onLoadResepByPatientId(
      LoadResepByPatientId event, Emitter<ResepState> emit) async {
    emit(ResepLoading());
    try {
      log('ResepBloc: Memuat resep berdasarkan Patient ID (Kemungkinan untuk Admin): ${event.patientId}');
      final responseData = await _resepRepository.getResepByPatientId(event.patientId);

      if (responseData.data == null || responseData.data!.isEmpty) {
        emit(ResepLoadEmpty());
      } else {
        emit(ResepLoadSuccess(responseData));
      }
    } catch (e) {
      log('ResepBloc: Gagal memuat resep berdasarkan Patient ID: $e');
      emit(ResepError('Gagal memuat resep: $e'));
    }
  }

  Future<void> _onLoadResepForAuthenticatedPasien(
      LoadResepForAuthenticatedPasien event, Emitter<ResepState> emit) async {
    emit(ResepLoading());
    try {
      log('ResepBloc: Memuat resep untuk Pasien yang login.');
      final responseData = await _resepRepository.getResepForAuthenticatedPasien();

      if (responseData.data == null || responseData.data!.isEmpty) {
        emit(ResepLoadEmpty());
      } else {
        emit(ResepLoadSuccess(responseData));
      }
    } catch (e) {
      log('ResepBloc: Gagal memuat resep untuk Pasien yang login: $e');
      emit(ResepError('Gagal memuat resep: $e'));
    }
  }

  Future<void> _onLoadResepByPendaftaranId(
      LoadResepByPendaftaranId event, Emitter<ResepState> emit) async {
    emit(ResepLoading());
    try {
      log('ResepBloc: Memuat resep berdasarkan ID Pendaftaran: ${event.pendaftaranId}');
      final responseData = await _resepRepository.getResepByPendaftaranId(event.pendaftaranId);

      if (responseData.data == null || responseData.data!.isEmpty) {
        emit(ResepLoadEmpty());
      } else {
        emit(ResepLoadSuccess(responseData));
      }
    } catch (e) {
      log('ResepBloc: Gagal memuat resep berdasarkan ID pendaftaran: $e');
      emit(ResepError('Gagal memuat resep berdasarkan ID pendaftaran: $e'));
    }
  }

  // <<<--- HANDLER UNTUK EXPORT PDF - KOREKSI DI SINI --->>>
  Future<void> _onExportResepPdf(ExportResepPdf event, Emitter<ResepState> emit) async {
    emit(ResepPdfLoading()); // Emit loading state
    try {
      log('ResepBloc: Memulai export PDF untuk resep ID: ${event.resepId}');
      // Panggil repository untuk mendapatkan byte data PDF
      final Uint8List pdfBytes = await _resepRepository.exportResepPdf(event.resepId); // <-- Asumsi ini mengembalikan Uint8List

      if (pdfBytes.isNotEmpty) {
        // Simpan file PDF secara lokal
        final directory = await getApplicationDocumentsDirectory();
        // Pastikan nama file unik atau relevan, contoh: resep_123.pdf
        final String filePath = '${directory.path}/resep_${event.resepId}.pdf';
        final File file = File(filePath);
        await file.writeAsBytes(pdfBytes);

        log('ResepBloc: PDF berhasil disimpan di: $filePath');
        emit(ResepPdfSuccess(filePath: filePath)); // Emit success state dengan path file
      } else {
        log('ResepBloc: Data PDF kosong dari repository.');
        emit(ResepPdfError(message: 'Data PDF kosong dari server.')); // Tambah named parameter
      }
    } catch (e) {
      log('ResepBloc: Gagal export PDF: $e');
      emit(ResepPdfError(message: 'Gagal mengekspor resep ke PDF: ${e.toString()}')); // Tambah named parameter
    }
  }
}