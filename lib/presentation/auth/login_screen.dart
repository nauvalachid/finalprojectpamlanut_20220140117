import 'package:finalproject/presentation/pasien/home/homescreen_pasien.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Tetap import ini jika ada widget lain yang menggunakannya secara langsung, tapi tidak lagi untuk menyimpan token di sini.
import 'dart:developer'; // Import untuk log

// Import untuk halaman setelah login
import 'package:finalproject/presentation/admin/home/admin_home_screen.dart';


// Import untuk Bloc dan Repository
import 'package:finalproject/presentation/auth/bloc/login/login_bloc.dart';
import 'package:finalproject/presentation/auth/bloc/login/login_event.dart';
import 'package:finalproject/presentation/auth/bloc/login/login_state.dart';
import 'package:finalproject/data/repository/auth_repository.dart';
import 'package:finalproject/service/service_http_client.dart'; // Pastikan ini diimpor

// Import untuk halaman register
import 'package:finalproject/presentation/auth/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Kontroler untuk input email dan password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // GlobalKey untuk mengelola state form dan validasi
  final _formKey = GlobalKey<FormState>();

  // State untuk mengontrol visibilitas password
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    // Inisialisasi ServiceHttpClient.
    // Penting untuk menginisialisasi di sini atau melalui Dependency Injection
    // agar dapat di-pass ke AuthRepository.
    final ServiceHttpClient serviceHttpClient = ServiceHttpClient();

    return Scaffold(
      body: Container(
        color: Colors.white, // Latar belakang putih untuk keseluruhan body
        child: BlocProvider(
          // Menyediakan instance LoginBloc ke widget tree.
          // LoginBloc membutuhkan AuthRepository, yang pada gilirannya membutuhkan ServiceHttpClient.
          create: (context) => LoginBloc(
            authRepository: AuthRepository(httpClient: serviceHttpClient),
          ),
          child: BlocConsumer<LoginBloc, LoginState>(
            // Listener untuk bereaksi terhadap perubahan state LoginBloc
            listener: (context, state) { // Hapus 'async' karena tidak ada 'await' di sini lagi
              if (state is LoginSuccess) {
                // Menampilkan SnackBar sukses
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );

                // --- LOGIKA PENYIMPANAN TOKEN DAN DATA PENGGUNA TELAH DIPINDAHKAN KE LOGINBLOC ---
                // Anda tidak perlu lagi menyimpan token, user_name, dan user_role di sini.
                // Logika ini sekarang ditangani oleh LoginBloc.
                // log('LoginScreen: Token disimpan: ${state.token.substring(0, 10)}...'); // Hapus log ini juga
                // log('LoginScreen: Nama pengguna disimpan: ${state.userName}');
                // log('LoginScreen: Peran pengguna disimpan: ${state.userRole}');
                // --- AKHIR LOGIKA PENYIMPANAN ---

                // Navigasi kondisional berdasarkan peran pengguna
                if (state.userRole == 'pasien') {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const PasienHomeScreen()),
                  );
                } else if (state.userRole == 'admin') {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
                  );
                } else {
                  // Fallback jika peran tidak dikenal atau tidak ada
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Peran pengguna tidak dikenal: ${state.userRole}.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  // Anda bisa memilih untuk tetap di layar login atau mengarahkan ke layar default lainnya.
                }
              } else if (state is LoginFailure) {
                // Menampilkan SnackBar error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            // Builder untuk membangun UI berdasarkan state LoginBloc
            builder: (context, state) {
              return Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                    child: Form(
                      key: _formKey, // Menghubungkan GlobalKey ke Form
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/images/iconn.png', // Logo aplikasi
                              height: 100,
                              width: 500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Center(
                            child: Text(
                              "Selamat Datang!",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2980B9), // Warna biru tema
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Center(
                            child: Text(
                              "Login untuk melanjutkan",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Input Email
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F8FB), // Warna latar belakang input
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
                                border: InputBorder.none, // Menghilangkan border default
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
                          // Input Password
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
                              obscureText: obscurePassword, // Mengontrol visibilitas teks
                              keyboardType: TextInputType.text,
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
                                    obscurePassword
                                        ? Icons.visibility_off // Ikon mata tertutup
                                        : Icons.visibility, // Ikon mata terbuka
                                    color: const Color(0xFF2980B9),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword; // Mengubah state visibilitas password
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
                          const SizedBox(height: 10),
                          // Tombol Lupa Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Aksi untuk Lupa Password (belum diimplementasi di sini)
                              },
                              child: const Text(
                                "Lupa Password?",
                                style: TextStyle(color: Color(0xFF2980B9)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          // Tombol Login
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
                              onPressed: state is LoginLoading // Nonaktifkan tombol saat loading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        // Kirim event LoginRequested ke LoginBloc
                                        context.read<LoginBloc>().add(
                                              LoginRequested(
                                                email: _emailController.text,
                                                password: _passwordController.text,
                                              ),
                                            );
                                      }
                                    },
                              child: state is LoginLoading
                                  ? const CircularProgressIndicator(color: Colors.white) // Tampilkan loading spinner
                                  : const Text(
                                      'Login',
                                      style: TextStyle(fontSize: 18, color: Colors.white),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          // Opsi Daftar Sekarang
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Tidak mempunyai akun? "),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const RegisterScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Daftar Sekarang",
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
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Pastikan kontroler dihapus saat widget dibuang untuk mencegah memory leak
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
