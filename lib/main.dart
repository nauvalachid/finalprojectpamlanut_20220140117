import 'package:finalproject/data/repository/admin_profile_repository.dart';
import 'package:finalproject/data/repository/auth_repository.dart';
import 'package:finalproject/data/repository/pasien_repository.dart';
import 'package:finalproject/data/repository/pendaftaran_repository.dart';
import 'package:finalproject/data/repository/jadwal_repository.dart';
import 'package:finalproject/data/repository/resep_repository.dart';
import 'package:finalproject/presentation/admin/bloc/jadwal/jadwal_bloc.dart';

import 'package:finalproject/presentation/admin/bloc/profile/profile_admin_bloc.dart';
import 'package:finalproject/presentation/admin/home/admin_home_screen.dart';
import 'package:finalproject/presentation/admin/bloc/pendaftaran/pendaftaran_bloc.dart';
import 'package:finalproject/presentation/auth/bloc/login/login_bloc.dart';
import 'package:finalproject/presentation/admin/bloc/pasien/pasien_bloc.dart';
import 'package:finalproject/presentation/admin/bloc/resep/resep_bloc.dart';

import 'package:finalproject/presentation/auth/login_screen.dart';
import 'package:finalproject/presentation/pasien/home/homescreen_pasien.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/service/service_http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:developer';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Metode ini sekarang langsung membaca token dari SharedPreferences
  Future<String?> _getInitialToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    log('Main: _getInitialToken - Token dari SharedPreferences: ${token != null ? token.substring(0, 10) + '...' : 'null'}');
    return token;
  }

  // Metode ini sekarang langsung membaca peran dari SharedPreferences
  Future<String?> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('user_role');
    log('Main: _getUserRole - Peran dari SharedPreferences: $role');
    return role;
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ServiceHttpClient>(
          create: (context) => ServiceHttpClient(),
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(
            httpClient: RepositoryProvider.of<ServiceHttpClient>(context),
          ),
        ),
        RepositoryProvider<PasienRepository>(
          create: (context) => PasienRepository(
            RepositoryProvider.of<ServiceHttpClient>(context),
          ),
        ),
        RepositoryProvider<PendaftaranRepository>(
          create: (context) => PendaftaranRepository(
            RepositoryProvider.of<ServiceHttpClient>(context),
          ),
        ),
        RepositoryProvider<AdminProfileRepository>(
          create: (context) => AdminProfileRepository(
            serviceHttpClient: RepositoryProvider.of<ServiceHttpClient>(context),
          ),
        ),
        RepositoryProvider<ResepRepository>(
          create: (context) => ResepRepository(
            RepositoryProvider.of<ServiceHttpClient>(context),
          ),
        ),
        RepositoryProvider<JadwalRepository>(
          create: (context) => JadwalRepository(
            RepositoryProvider.of<ServiceHttpClient>(context),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
            ),
          ),
          BlocProvider<PasienBloc>(
            create: (context) => PasienBloc(
              pasienRepository: RepositoryProvider.of<PasienRepository>(context),
            ),
          ),
          BlocProvider<PendaftaranBloc>(
            create: (context) => PendaftaranBloc(
              RepositoryProvider.of<PendaftaranRepository>(context),
            ),
          ),
          BlocProvider<AdminProfileBloc>(
            create: (context) => AdminProfileBloc(
              adminProfileRepository: RepositoryProvider.of<AdminProfileRepository>(context),
            ),
          ),
          BlocProvider<ResepBloc>(
            create: (context) => ResepBloc(
              resepRepository: RepositoryProvider.of<ResepRepository>(context),
            ),
          ),
          BlocProvider<JadwalBloc>(
            create: (context) => JadwalBloc(
              RepositoryProvider.of<JadwalRepository>(context),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: FutureBuilder<String?>(
            future: _getInitialToken(), // Memuat token terlebih dahulu
            builder: (context, tokenSnapshot) {
              if (tokenSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (tokenSnapshot.hasData && tokenSnapshot.data != null) {
                // Jika ada token, cek peran pengguna
                return FutureBuilder<String?>(
                  future: _getUserRole(), // Memuat peran pengguna
                  builder: (context, roleSnapshot) {
                    if (roleSnapshot.connectionState == ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    } else if (roleSnapshot.hasData && roleSnapshot.data == 'pasien') {
                      log('Main: Mengarahkan ke PasienHomeScreen karena peran: pasien');
                      return const PasienHomeScreen();
                    } else if (roleSnapshot.hasData && roleSnapshot.data == 'admin') {
                      log('Main: Mengarahkan ke AdminHomeScreen karena peran: admin');
                      return const AdminHomeScreen();
                    } else {
                      log('Main: Token ada, tapi peran tidak ditemukan atau tidak valid, mengarahkan ke LoginScreen.');
                      return const LoginScreen();
                    }
                  },
                );
              } else {
                // Jika tidak ada token sama sekali
                log('Main: Tidak ada token, mengarahkan ke LoginScreen.');
                return const LoginScreen();
              }
            },
          ),
        ),
      ),
    );
  }
}
