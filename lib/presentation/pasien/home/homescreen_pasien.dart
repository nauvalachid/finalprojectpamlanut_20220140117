import 'package:finalproject/data/repository/auth_repository.dart'; 
import 'package:finalproject/presentation/auth/login_screen.dart'; 
import 'package:finalproject/presentation/pasien/screen/melihatjadwal_screen.dart';
import 'package:finalproject/presentation/pasien/screen/melihatresep_screen.dart';
import 'package:finalproject/presentation/pasien/screen/pasienprofile_screen.dart';
import 'package:finalproject/presentation/pasien/screen/tambahpendaftaran_screen.dart';
import 'package:finalproject/presentation/pasien/widget/appheader_pasien.dart'; 
import 'package:finalproject/presentation/pasien/widget/bottomnavbar_pasien.dart';
import 'package:finalproject/presentation/pasien/widget/selamatdatangpasien.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http; 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'dart:developer'; 


import 'package:finalproject/data/repository/pasien_profile_repository.dart';
import 'package:finalproject/presentation/pasien/bloc/profilepasien/profilepasien_bloc.dart';

class PasienHomeScreen extends StatefulWidget {
  const PasienHomeScreen({super.key});

  @override
  State<PasienHomeScreen> createState() => _PasienHomeScreenState();
}

class _PasienHomeScreenState extends State<PasienHomeScreen> {
  int _selectedIndex = 0;
  String _loggedInUserName = 'Memuat...'; 
  String _userRole = 'Memuat...'; 
  String? _authToken; // Variabel untuk menyimpan token otentikasi
  int _currentPage = 0;

  final List<String> _sliderImages = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
  ];

  late PageController _pageController; // Tambahkan PageController
  late List<Widget> _screens; 

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex); // Inisialisasi PageController
    _loadUserData(); // Memuat nama, peran, dan token
  }

  @override
  void dispose() {
    _pageController.dispose(); // Pastikan PageController di-dispose
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userName = prefs.getString('user_name');
    final String? userRole = prefs.getString('user_role');
    // Pastikan kunci 'auth_token' ini konsisten dengan kunci yang digunakan saat menyimpan token setelah login.
    final String? authToken = prefs.getString('auth_token'); // Memuat token otentikasi

    log('PasienHomeScreen: Nama dimuat dari SharedPreferences: $userName');
    log('PasienHomeScreen: Peran dimuat dari SharedPreferences: $userRole');
    log('PasienHomeScreen: Token dimuat dari SharedPreferences: ${authToken != null ? authToken.substring(0, 10) + '...' : 'null'}'); // Log sebagian token

    setState(() {
      if (userName != null && userName.isNotEmpty) {
        _loggedInUserName = userName;
      } else {
        _loggedInUserName = 'Pengguna'; 
      }

      if (userRole != null && userRole.isNotEmpty) {
        _userRole = userRole;
      } else {
        _userRole = 'Tidak Diketahui'; 
      }

      _authToken = authToken; // Simpan token

      // Inisialisasi _screens setelah token dimuat
      // Jika _authToken masih null, tampilkan indikator loading atau pesan error.
      // Jika _authToken tidak null, baru inisialisasi PasienProfileScreen.
      _screens = [
        _buildHomeContent(), 
        const MelihatJadwalPasienScreen(),
        _authToken != null
            ? BlocProvider(
                create: (context) => PasienProfileBloc(
                  pasienProfileRepository: PasienProfileRepositoryImpl(client: http.Client()),
                ),
                child: PasienProfileScreen(authToken: _authToken!), // Teruskan token
              )
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Memuat profil atau token tidak ditemukan...'),
                  ],
                ),
              ),
      ];
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index); // Pindah halaman di PageView
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppHeader(), 

          SelamatDatangPasienCard(userName: _loggedInUserName),

          const SizedBox(height: 16),

          SizedBox(
            height: 180,
            child: PageView.builder(
              itemCount: _sliderImages.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: AssetImage(_sliderImages[index]),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          Center(
            child: DotsIndicator(
              dotsCount: _sliderImages.length,
              position: _currentPage,
              decorator: DotsDecorator(
                size: const Size.square(9.0),
                activeSize: const Size(18.0, 9.0),
                activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                color: Colors.grey,
                activeColor: const Color(0xFF2980B9),
              ),
            ),
          ),

          const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Beranda Sehat ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2980B9),
                  ),
                ),
                const SizedBox(height: 0.1),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    _buildFeatureCard(
                      context,
                      icon: Icons.calendar_today,
                      title: 'Janji Temu',
                      description: 'Lihat riwayat dan buat janji temu baru.',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PendaftaranScreen(), 
                          ),
                        ).then((result) {
                          if (result == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Pendaftaran janji temu berhasil!'),
                                backgroundColor: Colors.blue,
                              ),
                            );
                          }
                        });
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      icon: Icons.receipt_long,
                      title: 'Riwayat Medis',
                      description: 'Akses catatan dan resep medis Anda.',
                      onTap: () {
                       Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MelihatResepScreen(), 
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Pastikan _screens sudah diinisialisasi sebelum digunakan
    // Jika _authToken masih null, tampilkan indikator loading.
    // Ini penting karena _screens baru diinisialisasi setelah _authToken dimuat.
    if (_authToken == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: _selectedIndex == 0 ? null : AppBar(
        title: _selectedIndex == 1
            ? const Text('Janji Temu')
            : _selectedIndex == 2
                ? const Text('Profil Pasien') // Judul untuk halaman profil
                : const Text(''), // Default atau judul lain
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(_loggedInUserName), 
              accountEmail: Text(_userRole), 
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.blue),
              ),
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                _onItemTapped(0); 
                Navigator.pop(context); 
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                _performLogout(context);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: PageView( // Menggunakan PageView untuk menampung halaman
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Nonaktifkan geser manual
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _screens, // Daftar halaman yang akan ditampilkan
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // Fungsi pembantu untuk logout
  void _performLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    await prefs.remove('user_role');
    await prefs.remove('auth_token'); // Hapus juga token saat logout

    try {
      // Pastikan AuthRepository disediakan di atas widget tree
      final authRepo = RepositoryProvider.of<AuthRepository>(context);
      await authRepo.logout();
      log('User logged out successfully and data cleared.');
    } catch (e) {
      log('Error during logout process (server-side/secure storage): $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during logout: $e. Data lokal dihapus.')),
      );
    }
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: const Color(0xFF2980B9),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2980B9),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}