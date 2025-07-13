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
  final String token; // <<< PROPERTI TOKEN DITAMBAHKAN KEMBALI

  const LoginSuccess({
    required this.message,
    required this.userRole,
    required this.userName,
    required this.token, // <<< DIWAJIBKAN DI KONSTRUKTOR
  });

  // Jika Anda ingin perbandingan yang lebih ketat tanpa Equatable:
  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is LoginSuccess &&
  //         runtimeType == other.runtimeType &&
  //         message == other.message &&
  //         userRole == other.userRole &&
  //         userName == other.userName &&
  //         token == other.token; // Jangan lupa bandingkan token juga

  // @override
  // int get hashCode => message.hashCode ^ userRole.hashCode ^ userName.hashCode ^ token.hashCode;
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

class LogoutSuccess extends LoginState {} // <<< TAMBAHAN STATE LOGOUT
