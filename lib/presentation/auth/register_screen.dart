// finalproject/presentation/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/presentation/auth/bloc/register/register_bloc.dart';
import 'package:finalproject/presentation/auth/bloc/register/register_event.dart';
import 'package:finalproject/presentation/auth/bloc/register/register_state.dart';
import 'package:finalproject/data/repository/auth_repository.dart';
import 'package:finalproject/presentation/auth/login_screen.dart';
import 'package:finalproject/service/service_http_client.dart'; // Import ServiceHttpClient

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    // Inisialisasi ServiceHttpClient di sini agar bisa di-pass ke AuthRepository
    final ServiceHttpClient serviceHttpClient = ServiceHttpClient();

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        // Pass ServiceHttpClient ke AuthRepository di create RegisterBloc
        create: (context) => RegisterBloc(
          authRepository: AuthRepository(httpClient: serviceHttpClient), // <-- PERBAIKAN DI SINI
        ),
        child: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            } else if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 150),
                    Center(
                      child: Image.asset(
                        'assets/images/iconn.png',
                        height: 100,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        "Daftar Akun Baru",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2980B9),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        "Bergabung untuk memulai",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Name Input Field
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F8FB),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _nameController,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          labelText: "Nama Lengkap",
                          labelStyle: TextStyle(
                            color: Color(0xFF2980B9),
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Icon(Icons.person, color: Color(0xFF2980B9)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Email Input Field
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F8FB),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            color: Color(0xFF2980B9),
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF2980B9)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Masukkan email yang valid';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Password Input Field
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F8FB),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: obscurePassword,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: const TextStyle(
                            color: Color(0xFF2980B9),
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF2980B9)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: const Color(0xFF2980B9),
                            ),
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          if (value.length < 6) {
                            return 'Password minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Register Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF2980B9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        onPressed: state is RegisterLoading
                            ? null // Nonaktifkan tombol saat loading
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<RegisterBloc>().add(
                                        RegisterRequested(
                                          name: _nameController.text,
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        ),
                                      );
                                }
                              },
                        child: state is RegisterLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Daftar',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Link ke Login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Sudah punya akun? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            );
                          },
                          child: const Text(
                            "Login Sekarang",
                            style: TextStyle(
                              color: Color(0xFF2980B9),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}