// login_bloc.dart
import 'package:finalproject/data/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

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

      final String? userName = result['user_name'] as String?;
      final String? userRole = result['user_role'] as String?;
      final String message = result['message'] as String? ?? 'Login berhasil';

      if (userName != null && userRole != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', userName);
        await prefs.setString('user_role', userRole);
        log('LoginBloc: Nama ($userName) dan Peran ($userRole) berhasil disimpan ke SharedPreferences.');

        emit(LoginSuccess(
            message: message,
            userRole: userRole.toLowerCase(),
            userName: userName));
      } else {
        log('LoginBloc: Nama atau peran pengguna tidak ditemukan dalam hasil login yang diproses. Hasil lengkap: $result');
        emit(LoginFailure(
            errorMessage: 'Login successful, but user name or role not found.'));
      }
    } catch (e) {
      log('LoginBloc: Login error: $e');
      emit(LoginFailure(errorMessage: e.toString()));
    }
  }
}