import 'package:finalproject/data/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      final Map<String, dynamic> result =
          await authRepository.login(event.email, event.password);
      log('LoginBloc: Result from AuthRepository (after parsing): $result');

      final String? token = result['token'] as String?; // <<< AMBIL TOKEN DARI HASIL
      final String? userName = result['user_name'] as String?;
      final String? userRole = result['user_role'] as String?;
      final String message = result['message'] as String? ?? 'Login berhasil';

      if (token != null && userName != null && userRole != null) {
        // --- SIMPAN TOKEN DAN DATA PENGGUNA KE SHARED PREFERENCES DI SINI ---
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token); // Simpan token
        await prefs.setString('user_name', userName); // Simpan nama pengguna
        await prefs.setString('user_role', userRole); // Simpan peran pengguna
        log('LoginBloc: Token (${token.substring(0, 10)}...), Nama ($userName) dan Peran ($userRole) berhasil disimpan ke SharedPreferences.');
        // --- AKHIR SIMPAN DATA ---

        emit(LoginSuccess(
            message: message,
            userRole: userRole.toLowerCase(),
            userName: userName,
            token: token)); // <<< TERUSKAN TOKEN KE STATE
      } else {
        log('LoginBloc: Token, nama, atau peran pengguna tidak ditemukan dalam hasil login yang diproses. Hasil lengkap: $result');
        emit(LoginFailure(
            errorMessage: 'Login successful, but token, user name or role not found.'));
      }
    } catch (e) {
      log('LoginBloc: Login error: $e');
      emit(LoginFailure(errorMessage: e.toString()));
    }
  }
}
