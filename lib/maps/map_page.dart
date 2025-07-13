import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _ctrl = Completer();
  Marker? _pickedMarker;
  String? _pickedAddress;
  String? _currentAddress;
  CameraPosition? _initialCamera;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _setupLocation();
  }

  // Penting: Pastikan untuk membatalkan operasi asinkron yang sedang berjalan
  // jika widget di-dispose sebelum operasi selesai.
  // Untuk kasus ini, _ctrl Completer akan di-dispose secara otomatis,
  // tetapi jika ada StreamSubscription atau Future yang tidak di-await,
  // perlu dibersihkan di dispose.
  @override
  void dispose() {
    // Tidak perlu memanggil _ctrl.close() karena Completer tidak memiliki metode close.
    // GoogleMapController akan di-dispose oleh Google Maps package.
    super.dispose();
  }

  Future<void> _setupLocation() async {
    try {
      final pos = await getPermissions();
      _currentPosition = pos;
      _initialCamera = CameraPosition(
        target: LatLng(pos.latitude, pos.longitude),
        zoom: 10,
      );

      final placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      final p = placemarks.first;
      _currentAddress = '${p.name}, ${p.locality}, ${p.country}';

      // Pastikan widget masih mounted sebelum memanggil setState
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      // Pastikan widget masih mounted sebelum memanggil setState atau ScaffoldMessenger
      if (!mounted) {
        print('Error: Widget unmounted during _setupLocation: $e');
        return;
      }
      _initialCamera = const CameraPosition(target: LatLng(0, 0), zoom: 2);
      setState(() {});
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<Position> getPermissions() async {
    // 1. Cek service GPS
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw 'Location service belum aktif';
    }

    // 2. Cek & minta permission
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) {
        throw 'Izin lokasi ditolak';
      }
    }
    if (perm == LocationPermission.deniedForever) {
      throw 'Izin lokasi ditolak secara permanen';
    }

    // 3. Semua oke, ambil posisi
    return Geolocator.getCurrentPosition();
  }

  Future<void> _onTap(LatLng latlng) async {
    final placemarks = await placemarkFromCoordinates(
      latlng.latitude,
      latlng.longitude,
    );

    final p = placemarks.first;

    // Pastikan widget masih mounted sebelum memanggil setState
    if (!mounted) return;

    setState(() {
      _pickedMarker = Marker(
        markerId: const MarkerId('picked'),
        position: latlng,
        infoWindow: InfoWindow(
          title: p.name?.isNotEmpty == true ? p.name : 'Lokasi Dipilih',
          snippet: '${p.street}, ${p.locality}',
        ),
      );
    });
    final ctrl = await _ctrl.future;
    await ctrl.animateCamera(CameraUpdate.newLatLngZoom(latlng, 16));

    // Pastikan widget masih mounted sebelum memanggil setState
    if (!mounted) return;

    setState(() {
      _pickedAddress =
          '${p.name},${p.street},${p.locality},${p.country},${p.postalCode}';
    });
  }

  void _confirmSelection() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog( // Menggunakan dialogContext
        title: const Text('Konfirmasi Alamat'),
        content: Text(_pickedAddress ?? 'Alamat tidak dipilih.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext), // Menggunakan dialogContext
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // =========================================================================
              // INI ADALAH TEMPAT UNTUK MENAMBAHKAN mounted CHECK
              // Sebelum Navigator.pop(context) yang kedua
              // =========================================================================
              Navigator.pop(dialogContext); // Tutup AlertDialog terlebih dahulu

              if (!mounted) {
                print('MapPage sudah di-unmount, tidak bisa mengembalikan data.');
                return; // Keluar dari fungsi jika widget sudah tidak mounted
              }
              // =========================================================================

              if (_pickedAddress != null && _pickedMarker != null) {
                // Baris ini adalah yang menyebabkan error sebelumnya (map_page.dart:121)
                Navigator.pop(
                  context, // Menggunakan context dari _MapPageState
                  {
                    'address': _pickedAddress,
                    'latitude': _pickedMarker!.position.latitude,
                    'longitude': _pickedMarker!.position.longitude,
                  },
                );
              } else {
                // Pastikan widget masih mounted sebelum memanggil ScaffoldMessenger
                if (!mounted) {
                  print('MapPage sudah di-unmount, tidak bisa menampilkan SnackBar.');
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Silakan pilih lokasi di peta terlebih dahulu.')),
                );
              }
            },
            child: const Text('Pilih'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_initialCamera == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Alamat')),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialCamera!,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              rotateGesturesEnabled: true,
              trafficEnabled: true,
              buildingsEnabled: true,
              indoorViewEnabled: true,
              onMapCreated: (GoogleMapController ctrl) {
                _ctrl.complete(ctrl);
              },
              markers: _pickedMarker != null ? {_pickedMarker!} : {},
              onTap: _onTap,
            ),
            Positioned(
              top: 25,
              left: 25,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(_currentAddress ?? 'Kosong'),
              ),
            ),
            if (_pickedAddress != null)
              Positioned(
                bottom: 120,
                left: 16,
                right: 16,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      _pickedAddress!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          if (_pickedAddress != null)
            FloatingActionButton.extended(
              onPressed: _confirmSelection,
              heroTag: 'confirm',
              label: const Text("Pilih Alamat"),
            ),
          const SizedBox(height: 8),
          if (_pickedAddress != null)
            // clear
            FloatingActionButton.extended(
              heroTag: 'clear',
              label: const Text('Hapus Alamat'),
              onPressed: () {
                setState(() {
                  _pickedAddress = null;
                  _pickedMarker = null;
                });
              },
            ),
        ],
      ),
    );
  }
}
