import 'package:finalproject/presentation/admin/widget/bottom_navigation_bar.dart';
import 'package:finalproject/presentation/admin/screens/jadwal_screen.dart';
import 'package:finalproject/presentation/admin/widget/homescreen_admin.dart';
import 'package:finalproject/presentation/admin/screens/pendataan_pasien_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(debugLabel: 'HomeTabNav'),
    GlobalKey<NavigatorState>(debugLabel: 'AppointmentTabNav'),
    GlobalKey<NavigatorState>(debugLabel: 'PatientPortalTabNav'),
    GlobalKey<NavigatorState>(debugLabel: 'AccountTabNav'),
  ];

  String? _authToken;
  int? _currentAdminProfileId; 
  List<Widget> _pages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print('AdminHomeScreen: initState dipanggil.'); 
    _loadAuthTokenAndInitializePages();
  }

  Future<void> _loadAuthTokenAndInitializePages() async {
    print('AdminHomeScreen: _loadAuthTokenAndInitializePages dipanggil.'); 
    try {
      final prefs = await SharedPreferences.getInstance();
      _authToken = prefs.getString('token');
      final adminProfileIdString = prefs.getString('adminProfileId');
      _currentAdminProfileId = int.tryParse(adminProfileIdString ?? '');

      print('AdminHomeScreen: Token dari SharedPreferences: $_authToken'); 
      print('AdminHomeScreen: Fetched adminProfileIdString from SharedPreferences: $adminProfileIdString'); 
      print('AdminHomeScreen: Parsed _currentAdminProfileId (int?): $_currentAdminProfileId'); 

      if (_currentAdminProfileId == null) {
        print('AdminHomeScreen: Peringatan! _currentAdminProfileId adalah NULL. Pastikan adminProfileId disimpan dengan benar di SharedPreferences.'); 
      }

      if (mounted) {
        setState(() {
          _pages = [
            _buildTabNavigator(
              _navigatorKeys[0],
              const HomeScreenContent(),
            ),
            _buildTabNavigator(
              _navigatorKeys[1],
              JadwalScreen(authToken: _authToken ?? ''),
            ),
            _buildTabNavigator(
              _navigatorKeys[2],
              const PasienScreen(),
            ),
          ];
          _isLoading = false;
          print('AdminHomeScreen: _authToken, _currentAdminProfileId, dan _pages berhasil diinisialisasi. _isLoading = $_isLoading'); 
        });
      } else {
        print('AdminHomeScreen: Widget tidak lagi mounted saat mencoba setState.'); 
      }
    } catch (e) {
      print('AdminHomeScreen: Error saat memuat token atau menginisialisasi halaman: $e'); 
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  static Widget _buildTabNavigator(GlobalKey<NavigatorState> navigatorKey, Widget child) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('AdminHomeScreen: build dipanggil. _isLoading: $_isLoading, _authToken: $_authToken, _pages.isEmpty: ${_pages.isEmpty}'); 

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }
}