import 'package:finalproject/presentation/admin/widget/resep/editresep_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/presentation/admin/bloc/resep/resep_bloc.dart';
import 'package:finalproject/presentation/admin/bloc/resep/resep_event.dart';
import 'package:finalproject/presentation/admin/bloc/resep/resep_state.dart';
import 'package:finalproject/presentation/admin/widget/resep/resep_card.dart'; // Import ResepCard yang baru

class ResepByPendaftaranScreen extends StatefulWidget {
  final int pendaftaranId;

  const ResepByPendaftaranScreen({Key? key, required this.pendaftaranId}) : super(key: key);

  @override
  State<ResepByPendaftaranScreen> createState() => _ResepByPendaftaranScreenState();
}

class _ResepByPendaftaranScreenState extends State<ResepByPendaftaranScreen> {
  @override
  void initState() {
    super.initState();
    // Memuat resep saat layar pertama kali dibuat
    context.read<ResepBloc>().add(LoadResepByPendaftaranId(pendaftaranId: widget.pendaftaranId));
    print('initState: Requesting resep for pendaftaran ID: ${widget.pendaftaranId}');
  }

  // Fungsi untuk refresh data resep
  void _refreshResep() {
    print('Refreshing resep for pendaftaran ID: ${widget.pendaftaranId}');
    context.read<ResepBloc>().add(LoadResepByPendaftaranId(pendaftaranId: widget.pendaftaranId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resep Pendaftaran ID: ${widget.pendaftaranId}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshResep,
          ),
        ],
      ),
      body: BlocBuilder<ResepBloc, ResepState>(
        builder: (context, state) {
          if (state is ResepLoading) {
            print('BlocState: ResepLoading - Displaying CircularProgressIndicator');
            return const Center(child: CircularProgressIndicator());
          } else if (state is ResepLoadSuccess) {
            print('BlocState: ResepLoadSuccess - Data received. Total items: ${state.response.data?.length ?? 0}');

            if (state.response.data == null || state.response.data!.isEmpty) {
              print('BlocState: ResepLoadSuccess - No resep found for this pendaftaran.');
              return const Center(child: Text('Belum ada resep untuk pendaftaran ini.'));
            }
            return ListView.builder(
              itemCount: state.response.data!.length,
              itemBuilder: (context, index) {
                final resep = state.response.data![index]; // Ini bertipe Datum

                return ResepCard(
                  resep: resep,
                  onEdit: () async {
                    // NAVIGASI KE EDITRESEPSCREEN
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditResepScreen(resep: resep), // Kirim objek resep
                      ),
                    );
                    // Jika EditResepScreen mengembalikan `true`, refresh data
                    if (result == true) {
                      _refreshResep();
                    }
                  },
                );
              },
            );
          } else if (state is ResepLoadEmpty) {
            print('BlocState: ResepLoadEmpty - Displaying "No resep found" message.');
            return const Center(child: Text('Tidak ada resep yang ditemukan untuk pendaftaran ini.'));
          } else if (state is ResepError) {
            print('BlocState: ResepError - Displaying error message: ${state.message}');
            return Center(child: Text('Error: ${state.message}'));
          }
          print('BlocState: Initial/Unknown State - Displaying default message.');
          return const Center(child: Text('Muat resep berdasarkan ID pendaftaran.'));
        },
      ),
    );
  }
}
