abstract class RegisterEvent {}

// Event untuk menginisiasi registrasi
class RegisterRequested extends RegisterEvent {
  final String name;
  final String email;
  final String password;

  // Konstruktor untuk mengambil inputan nama, email, dan password
  RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
  });
}
