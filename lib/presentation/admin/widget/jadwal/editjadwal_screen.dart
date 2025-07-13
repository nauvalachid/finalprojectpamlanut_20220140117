import 'package:flutter/material.dart';
import 'package:finalproject/data/model/request/admin/editjadwal_request_model.dart';
import 'package:finalproject/data/model/response/melihatjadwal_response_model.dart';
import 'package:intl/intl.dart';

/// Widget terpisah untuk dialog form edit jadwal.
class EditJadwalDialog extends StatefulWidget {
  final MelihatJadwalResponseModel jadwal;
  final Function(EditJadwalRequestModel request) onSave;

  const EditJadwalDialog({
    super.key,
    required this.jadwal,
    required this.onSave,
  });

  @override
  State<EditJadwalDialog> createState() => _EditJadwalDialogState();
}

class _EditJadwalDialogState extends State<EditJadwalDialog> {
  late TextEditingController _namaBidanController;
  late TextEditingController _tanggalController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;

  DateTime? _selectedDate;

  // Mendefinisikan gaya border yang konsisten
  final OutlineInputBorder _transparentBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
  );

  final OutlineInputBorder _focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFF2980B9), width: 2),
  );

  @override
  void initState() {
    super.initState();
    _namaBidanController = TextEditingController(text: widget.jadwal.namaBidan);
    _tanggalController = TextEditingController(
      text: widget.jadwal.tanggal != null
          ? DateFormat('yyyy-MM-dd').format(widget.jadwal.tanggal!)
          : '',
    );
    _startTimeController = TextEditingController(text: widget.jadwal.startTime);
    _endTimeController = TextEditingController(text: widget.jadwal.endTime);

    _selectedDate = widget.jadwal.tanggal;
  }

  @override
  void dispose() {
    _namaBidanController.dispose();
    _tanggalController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _tanggalController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final DateTime now = DateTime.now();
      final DateTime dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      final String finalFormattedTime = DateFormat('HH:mm').format(dt);

      setState(() {
        controller.text = finalFormattedTime;
      });
    }
  }

  // Helper method untuk membangun TextFormField dengan gaya kustom
  Widget _buildStyledTextFormField({
    required TextEditingController controller,
    required String labelText, // Ini akan digunakan sebagai label di luar TextFormField
    required IconData prefixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 4.0), // Padding untuk label
          child: Text(
            labelText,
            style: const TextStyle(
              color: Color(0xFF2980B9),
              fontWeight: FontWeight.w500,
              fontSize: 14, // Ukuran font label
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 0.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            decoration: InputDecoration(
              // labelText dihilangkan dari sini
              prefixIcon: Icon(prefixIcon, color: const Color(0xFF2980B9)),
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              suffixIcon: suffixIcon,
              border: _transparentBorder,
              enabledBorder: _transparentBorder,
              focusedBorder: _focusedBorder,
              // errorStyle tidak lagi menyembunyikan teks error, biarkan default atau atur sesuai kebutuhan
              // Jika Anda menggunakan validator di sini, pesan error akan muncul di bawah field
            ),
          ),
        ),
        const SizedBox(height: 16.0), // Spasi antar field
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ubah Jadwal', 
      style: TextStyle(color: Color(0xFF2980B9), 
      fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStyledTextFormField(
              controller: _namaBidanController,
              labelText: 'Nama Bidan',
              prefixIcon: Icons.person_outline,
            ),
            _buildStyledTextFormField(
              controller: _tanggalController,
              labelText: 'Tanggal',
              prefixIcon: Icons.calendar_today,
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            _buildStyledTextFormField(
              controller: _startTimeController,
              labelText: 'Waktu Mulai',
              prefixIcon: Icons.access_time,
              readOnly: true,
              onTap: () => _selectTime(context, _startTimeController),
            ),
            _buildStyledTextFormField(
              controller: _endTimeController,
              labelText: 'Waktu Selesai',
              prefixIcon: Icons.access_time,
              readOnly: true,
              onTap: () => _selectTime(context, _endTimeController),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Row( // Menggunakan Row untuk menempatkan tombol sejajar
          mainAxisAlignment: MainAxisAlignment.end, // Menjajarkan tombol ke kanan
          children: [
            Container( // Tambahkan Container untuk shadow pada tombol Batal
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ElevatedButton( // Ubah TextButton menjadi ElevatedButton
                child: const Text(
                  'Batal',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Warna merah
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24), // Padding yang sama dengan tombol Simpan
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Border radius yang sama
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8), // Memberi sedikit spasi antar tombol
            Container( // Tetap bungkus ElevatedButton dengan Container untuk shadow
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Validasi dasar
                  if (_namaBidanController.text.isEmpty ||
                      _tanggalController.text.isEmpty ||
                      _startTimeController.text.isEmpty ||
                      _endTimeController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Harap lengkapi semua field.')),
                    );
                    return;
                  }

                  DateTime? parsedDate;
                  try {
                    parsedDate = DateFormat('yyyy-MM-dd').parse(_tanggalController.text);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Format tanggal tidak valid (YYYY-MM-DD).')),
                    );
                    return;
                  }

                  final editJadwalRequest = EditJadwalRequestModel(
                    namaBidan: _namaBidanController.text,
                    tanggal: parsedDate,
                    startTime: _startTimeController.text,
                    endTime: _endTimeController.text,
                  );
                  widget.onSave(editJadwalRequest); // Panggil callback onSave
                  Navigator.of(context).pop(); // Tutup dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2), // Warna biru solid
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24), // Sesuaikan padding horizontal
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Border radius yang lebih besar
                  ),
                  // minimumSize: const Size(double.infinity, 0), // DIHAPUS: Agar tombol tidak mengambil lebar penuh
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
