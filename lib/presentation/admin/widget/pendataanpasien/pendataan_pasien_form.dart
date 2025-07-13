// presentation/admin/widgets/pendataanpasien/pendataan_pasien_form.dart

import 'package:finalproject/maps/map_page.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/data/model/request/admin/editpasien_request_model.dart';
import 'package:finalproject/data/model/request/admin/tambahpasien_request_model.dart';
import 'package:finalproject/data/model/response/admin/melihatpasien_response_model.dart';
import 'package:intl/intl.dart';

class PasienFormContent extends StatefulWidget {
  final MelihatPasienResponseModel? pasien;
  final Function(dynamic request) onSave; // Callback untuk mengirim data kembali

  const PasienFormContent({
    super.key,
    this.pasien,
    required this.onSave,
  });

  @override
  State<PasienFormContent> createState() => _PasienFormContentState();
}

class _PasienFormContentState extends State<PasienFormContent> {
  // Pengendali untuk setiap kolom input
  late TextEditingController _namaController;
  late TextEditingController _tanggalLahirController;
  String? _selectedKelamin;
  late TextEditingController _alamatController;
  late TextEditingController _nomorTeleponController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;

  DateTime? _selectedDate;
  String? _kelaminToSendToBackend; // Nilai yang akan dikirim ke backend

  // Kunci global untuk validasi formulir
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Inisialisasi pengendali dengan data pasien jika ada
    _namaController = TextEditingController(text: widget.pasien?.nama);
    _tanggalLahirController = TextEditingController(
      text: widget.pasien?.tanggalLahir != null
          ? DateFormat('dd/MM/yyyy').format(widget.pasien!.tanggalLahir!)
          : '',
    );

    // Menyesuaikan nilai jenis kelamin dari API ke format tampilan dropdown
    if (widget.pasien?.kelamin != null) {
      final normalizedKelamin = widget.pasien!.kelamin!.trim().toLowerCase();
      if (normalizedKelamin == 'laki-laki') {
        _selectedKelamin = 'Laki-laki';
        _kelaminToSendToBackend = 'laki-laki';
      } else if (normalizedKelamin == 'perempuan') {
        _selectedKelamin = 'Perempuan';
        _kelaminToSendToBackend = 'perempuan';
      }
    }

    _alamatController = TextEditingController(text: widget.pasien?.alamat);
    _nomorTeleponController =
        TextEditingController(text: widget.pasien?.nomorTelepon);
    _latitudeController =
        TextEditingController(text: widget.pasien?.latitude);
    _longitudeController =
        TextEditingController(text: widget.pasien?.longitude);

    _selectedDate = widget.pasien?.tanggalLahir;

    debugPrint('Nilai kelamin dari API: ${widget.pasien?.kelamin}');
    debugPrint('Nilai _selectedKelamin untuk Dropdown: $_selectedKelamin');
    debugPrint('Nilai _kelaminToSendToBackend: $_kelaminToSendToBackend');
  }

  @override
  void dispose() {
    // Membuang pengendali saat widget dibuang untuk mencegah kebocoran memori
    _namaController.dispose();
    _tanggalLahirController.dispose();
    _alamatController.dispose();
    _nomorTeleponController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  // Fungsi untuk memilih lokasi dari peta
  Future<void> _pickLocationOnMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapPage(),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _alamatController.text = result['address'] ?? '';
        _latitudeController.text =
            (result['latitude'] as double?)?.toString() ?? '';
        _longitudeController.text =
            (result['longitude'] as double?)?.toString() ?? '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lokasi berhasil dipilih dari peta.')),
      );
    }
  }

  // Fungsi pembantu untuk membuat dekorasi input yang konsisten
  InputDecoration _buildInputDecoration(String labelText, {Widget? prefixIcon, Widget? suffixIcon, String? errorText}) {
    return InputDecoration(
      labelText: labelText,
      hintText: 'Masukkan $labelText', // Teks petunjuk
      fillColor: Colors.white, // Warna latar belakang field
      filled: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      // Styling border saat normal
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0), // Sudut membulat
        borderSide: BorderSide.none, // Tanpa garis border
      ),
      // Styling border saat diaktifkan (tidak fokus)
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      // Styling border saat fokus
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Color(0xFF1E88E5), width: 2.0), // Border biru saat fokus
      ),
      // Styling border saat ada error
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.red, width: 2.0), // Border merah saat error
      ),
      // Styling border saat fokus dan ada error
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
      ),
      prefixIcon: prefixIcon, // Ikon di awal input
      suffixIcon: suffixIcon, // Ikon di akhir input
      errorText: errorText, // Menampilkan teks error di bawah field
      errorStyle: const TextStyle(color: Colors.red, fontSize: 12), // Gaya teks error
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form( // Membungkus dengan widget Form untuk validasi
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // TextFormField untuk Nama
          TextFormField(
            controller: _namaController,
            decoration: _buildInputDecoration(
              'Nama',
              prefixIcon: const Icon(Icons.person, color: Colors.grey), // Ikon orang
              // errorText: _namaController.text.isEmpty ? 'Nama tidak boleh kosong' : null, // Contoh error teks langsung
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nama tidak boleh kosong';
              }
              return null;
            },
          ),
          const SizedBox(height: 12), // Jarak antar field
          // TextFormField untuk Tanggal Lahir
          TextFormField(
            controller: _tanggalLahirController,
            readOnly: true, // Hanya bisa dipilih melalui date picker
            decoration: _buildInputDecoration(
              'Tanggal Lahir',
              prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey), // Ikon kalender
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_drop_down, color: Colors.grey), // Ikon dropdown untuk menunjukkan bisa dibuka
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                      _tanggalLahirController.text =
                          DateFormat('dd/MM/yyyy').format(pickedDate);
                    });
                  }
                },
              ),
              // errorText: _selectedDate == null ? 'Tanggal lahir tidak boleh kosong' : null,
            ),
            validator: (value) {
              if (_selectedDate == null) { // Validasi berdasarkan _selectedDate
                return 'Tanggal lahir tidak boleh kosong';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          // DropdownButtonFormField untuk Kelamin
          DropdownButtonFormField<String>(
            value: _selectedKelamin,
            decoration: _buildInputDecoration(
              'Kelamin',
              prefixIcon: const Icon(Icons.people, color: Colors.grey), // Ikon kelamin
              // errorText: _selectedKelamin == null ? 'Jenis kelamin tidak boleh kosong' : null,
            ),
            items: const <String>['Laki-laki', 'Perempuan']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedKelamin = newValue;
                _kelaminToSendToBackend = newValue?.toLowerCase();
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Jenis kelamin tidak boleh kosong';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          // TextFormField Alamat dengan tombol Peta
          TextFormField(
            controller: _alamatController,
            readOnly: true, // Hanya bisa diisi via peta
            decoration: _buildInputDecoration(
              'Alamat',
              prefixIcon: const Icon(Icons.location_on, color: Colors.grey), // Ikon lokasi
              suffixIcon: IconButton(
                icon: const Icon(Icons.map, color: Colors.grey),
                onPressed: _pickLocationOnMap, // Panggil fungsi untuk membuka peta
              ),
              // errorText: _alamatController.text.isEmpty ? 'Alamat tidak boleh kosong' : null,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Alamat tidak boleh kosong';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          // TextFormField Latitude
          TextFormField(
            controller: _latitudeController,
            keyboardType: TextInputType.number,
            decoration: _buildInputDecoration(
              'Latitude',
              prefixIcon: const Icon(Icons.satellite_alt, color: Colors.grey), // Ikon satelit/koordinat
              // errorText: _latitudeController.text.isEmpty ? 'Latitude tidak boleh kosong' : null,
            ),
            readOnly: true, // Biasanya read-only jika diisi dari peta
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Latitude tidak boleh kosong';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          // TextFormField Longitude
          TextFormField(
            controller: _longitudeController,
            keyboardType: TextInputType.number,
            decoration: _buildInputDecoration(
              'Longitude',
              prefixIcon: const Icon(Icons.satellite_alt, color: Colors.grey), // Ikon satelit/koordinat
              // errorText: _longitudeController.text.isEmpty ? 'Longitude tidak boleh kosong' : null,
            ),
            readOnly: true, // Biasanya read-only jika diisi dari peta
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Longitude tidak boleh kosong';
              }
              return null;
            },
          ),
          const SizedBox(height: 12), // Spasi sebelum nomor telepon
          // TextFormField Nomor Telepon
          TextFormField(
            controller: _nomorTeleponController,
            keyboardType: TextInputType.phone,
            decoration: _buildInputDecoration(
              'Nomor Telepon',
              prefixIcon: const Icon(Icons.phone, color: Colors.grey), // Ikon telepon
              // errorText: _nomorTeleponController.text.isEmpty ? 'Nomor telepon tidak boleh kosong' : null,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nomor telepon tidak boleh kosong';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          // Tombol Aksi
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[700], // Warna teks abu-abu
                ),
                child: const Text('Batal'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(width: 8), // Jarak antar tombol
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5), // Warna biru dari gambar
                  foregroundColor: Colors.white, // Warna teks putih
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Sudut membulat untuk tombol
                  ),
                  elevation: 0, // Tanpa bayangan
                ),
                child: Text(widget.pasien == null ? 'Tambah' : 'Simpan'),
                onPressed: () {
                  // Validasi semua field dalam form
                  if (_formKey.currentState!.validate()) {
                    // Jika semua field valid, lanjutkan dengan menyimpan data
                    if (widget.pasien == null) {
                      final request = TambahPasienRequestModel(
                        nama: _namaController.text,
                        tanggalLahir: _selectedDate,
                        kelamin: _kelaminToSendToBackend,
                        alamat: _alamatController.text,
                        latitude: double.tryParse(_latitudeController.text),
                        longitude: double.tryParse(_longitudeController.text),
                        nomorTelepon: _nomorTeleponController.text,
                      );
                      widget.onSave(request);
                    } else {
                      final request = EditPasienRequestModel(
                        nama: _namaController.text,
                        tanggalLahir: _selectedDate,
                        kelamin: _kelaminToSendToBackend,
                        alamat: _alamatController.text,
                        latitude: double.tryParse(_latitudeController.text),
                        longitude: double.tryParse(_longitudeController.text),
                        nomorTelepon: _nomorTeleponController.text,
                      );
                      widget.onSave(request);
                    }
                    // Navigator.of(context).pop(); // Ini akan ditangani oleh halaman pemanggil
                  } else {
                    // Tampilkan SnackBar jika ada field yang belum diisi atau tidak valid
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Harap lengkapi semua data yang wajib.')),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}