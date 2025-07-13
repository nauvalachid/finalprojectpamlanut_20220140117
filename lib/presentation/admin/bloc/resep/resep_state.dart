// finalproject/presentation/admin/bloc/resep/resep_state.dart
import 'package:finalproject/data/model/response/admin/editresep_response_model.dart';
import 'package:finalproject/data/model/response/admin/tambahresep_response_model.dart';
import 'package:finalproject/data/model/response/pasien/melihatreseppasien_response_model.dart';

// Tambahkan equatable jika Anda ingin membandingkan state dengan mudah
// import 'package:equatable/equatable.dart';

// Jika menggunakan equatable, tambahkan 'extends Equatable'
// abstract class ResepState extends Equatable {
//   const ResepState();
//   @override
//   List<Object> get props => [];
// }

// Jika tidak menggunakan equatable (seperti kode Anda saat ini):
abstract class ResepState {
  const ResepState();
}


class ResepInitial extends ResepState {}

class ResepLoading extends ResepState {}

class ResepAddSuccess extends ResepState {
  final TambahResepResponseModel response;
  const ResepAddSuccess(this.response);
  // @override List<Object> get props => [response]; // Untuk Equatable
}

class ResepEditSuccess extends ResepState {
  final EditResepResponseModel response;
  const ResepEditSuccess(this.response);
  // @override List<Object> get props => [response]; // Untuk Equatable
}

class ResepLoadSuccess extends ResepState {
  final LihatResepPasienResponseModel response;
  const ResepLoadSuccess(this.response);
  // @override List<Object> get props => [response]; // Untuk Equatable
}

class ResepLoadEmpty extends ResepState {
  const ResepLoadEmpty();
}

class ResepError extends ResepState {
  final String message;
  const ResepError(this.message); // Jika ini juga dipanggil dengan named parameter, ubah menjadi {required this.message}
  // @override List<Object> get props => [message]; // Untuk Equatable
}

class ResepPdfLoading extends ResepState {}

class ResepPdfSuccess extends ResepState {
  final String filePath; // Path file PDF yang disimpan
  const ResepPdfSuccess({required this.filePath}); // Sudah benar (named parameter)
  // @override List<Object> get props => [filePath]; // Untuk Equatable
}

class ResepPdfError extends ResepState {
  final String message;
  // <<<--- UBAH BARIS INI: dari positional menjadi named parameter --->>>
  const ResepPdfError({required this.message}); // Ini yang benar agar sesuai dengan pemanggilan di BLoC
  // @override List<Object> get props => [message]; // Untuk Equatable
}