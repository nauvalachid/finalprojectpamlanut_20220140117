// login_state.dart
// import 'package:equatable/equatable.dart'; // Hapus ini jika tidak digunakan

abstract class LoginState {
  const LoginState();

  // Karena tidak menggunakan Equatable, Anda bisa menghapus `props` atau
  // jika Anda ingin perbandingan yang lebih ketat, Anda perlu mengimplementasikan
  // operator == dan hashCode secara manual.
  // @override
  // List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String message;
  final String userRole;
  final String userName;

  const LoginSuccess({required this.message, required this.userRole, required this.userName});

  // Jika Anda ingin perbandingan yang lebih ketat tanpa Equatable:
  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is LoginSuccess &&
  //         runtimeType == other.runtimeType &&
  //         message == other.message &&
  //         userRole == other.userRole &&
  //         userName == other.userName;

  // @override
  // int get hashCode => message.hashCode ^ userRole.hashCode ^ userName.hashCode;
}

class LoginFailure extends LoginState {
  final String errorMessage;

  const LoginFailure({required this.errorMessage});

  // Jika Anda ingin perbandingan yang lebih ketat tanpa Equatable:
  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is LoginFailure &&
  //         runtimeType == other.runtimeType &&
  //         errorMessage == other.errorMessage;

  // @override
  // int get hashCode => errorMessage.hashCode;
}

class LogoutSuccess extends LoginState {}