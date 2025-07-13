import 'package:finalproject/data/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;

  RegisterBloc({required this.authRepository}) : super(RegisterInitial()) {
    // Menangani event RegisterRequested
    on<RegisterRequested>(_onRegisterRequested);
  }

  // Fungsi untuk menangani event RegisterRequested
  Future<void> _onRegisterRequested(
      RegisterRequested event, Emitter<RegisterState> emit) async {
    try {
      // Memulai loading saat proses registrasi
      emit(RegisterLoading());
      
      // Memanggil authRepository untuk register
      var response = await authRepository.register(
        event.name,
        event.email,
        event.password,
      );

      // Jika registrasi berhasil, mengirimkan state RegisterSuccess
      emit(RegisterSuccess(message: response['message']));
    } catch (e) {
      // Jika registrasi gagal, mengirimkan state RegisterFailure
      emit(RegisterFailure(errorMessage: e.toString()));
    }
  }
}
