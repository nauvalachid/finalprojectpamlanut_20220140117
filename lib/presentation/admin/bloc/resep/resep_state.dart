// finalproject/presentation/admin/bloc/resep/resep_state.dart
import 'package:finalproject/data/model/response/admin/editresep_response_model.dart';
import 'package:finalproject/data/model/response/admin/tambahresep_response_model.dart';
import 'package:finalproject/data/model/response/pasien/melihatreseppasien_response_model.dart';

abstract class ResepState {
  const ResepState();
}

class ResepInitial extends ResepState {}

class ResepLoading extends ResepState {}

class ResepAddSuccess extends ResepState {
  final TambahResepResponseModel response;
  const ResepAddSuccess(this.response);
}

class ResepEditSuccess extends ResepState {
  final EditResepResponseModel response;
  const ResepEditSuccess(this.response);
}

class ResepLoadSuccess extends ResepState {
  final LihatResepPasienResponseModel response;
  const ResepLoadSuccess(this.response);
}

class ResepLoadEmpty extends ResepState {
  const ResepLoadEmpty();
}

class ResepError extends ResepState {
  final String message;
  const ResepError(this.message);
}