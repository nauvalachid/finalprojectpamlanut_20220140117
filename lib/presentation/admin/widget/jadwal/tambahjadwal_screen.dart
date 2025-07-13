import 'package:flutter/material.dart';
import 'package:finalproject/data/model/request/admin/tambahjadwal_request_model.dart';
import 'package:finalproject/data/repository/jadwal_repository.dart';
import 'package:finalproject/service/service_http_client.dart';
import 'package:intl/intl.dart';

class AddJadwalScreen extends StatefulWidget {
  const AddJadwalScreen({super.key});

  @override
  State<AddJadwalScreen> createState() => _AddJadwalScreenState();
}

class _AddJadwalScreenState extends State<AddJadwalScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaBidanController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  late final JadwalRepository _jadwalRepository;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final ServiceHttpClient serviceHttpClient = ServiceHttpClient();
    _jadwalRepository = JadwalRepository(serviceHttpClient);
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
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
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

  Future<void> _submitForm() async {
    String? tanggalError = _tanggalController.text.isEmpty ? 'Tanggal tidak boleh kosong' : null;
    if (tanggalError == null) {
      try {
        DateTime.parse(_tanggalController.text);
      } catch (e) {
        tanggalError = 'Format tanggal tidak valid (YYYY-MM-DD)';
      }
    }

    String? startTimeError = _startTimeController.text.isEmpty ? 'Waktu Mulai tidak boleh kosong' : null;
    if (startTimeError == null && !RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$').hasMatch(_startTimeController.text)) {
      startTimeError = 'Format waktu mulai tidak valid (HH:MM)';
    }

    String? endTimeError = _endTimeController.text.isEmpty ? 'Waktu Selesai tidak boleh kosong' : null;
    if (endTimeError == null && !RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$').hasMatch(_endTimeController.text)) {
      endTimeError = 'Format waktu selesai tidak valid (HH:MM)';
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      DateTime? parsedDate;
      try {
        parsedDate = DateTime.parse(_tanggalController.text);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Format tanggal tidak valid: ${_tanggalController.text}')),
          );
        }
        setState(() {
          _isSaving = false;
        });
        return;
      }

      final newJadwalRequest = TambahJadwalRequestModel(
        namaBidan: _namaBidanController.text,
        tanggal: parsedDate,
        startTime: _startTimeController.text,
        endTime: _endTimeController.text,
      );

      try {
        await _jadwalRepository.addJadwal(newJadwalRequest);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Jadwal berhasil ditambahkan!')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = 'Gagal menambahkan jadwal: ${e.toString()}';
          if (e.toString().contains('422')) {
             errorMessage = 'Gagal menambahkan jadwal: Pastikan format waktu adalah HH:MM (misal: 14:30) dan semua field terisi dengan benar.';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _buildCustomTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    final OutlineInputBorder transparentBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );

    final OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF2980B9), width: 2),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              labelText: labelText,
              labelStyle: const TextStyle(
                color: Color(0xFF2980B9),
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Icon(prefixIcon, color: const Color(0xFF2980B9)),
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              suffixIcon: suffixIcon,

              border: transparentBorder,
              enabledBorder: transparentBorder,
              focusedBorder: focusedBorder,
              errorStyle: const TextStyle(height: 0, fontSize: 0),
            ),
            validator: (value) {
              final errorText = validator?.call(value);
              return errorText != null ? ' ' : null;
            },
          ),
        ),
        // Menampilkan pesan error di luar TextFormField
        // Kondisi ini bisa disesuaikan lebih lanjut jika ada state manajemen form
        if (controller.text.isEmpty && validator?.call(controller.text) != null)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 4.0),
            child: Text(
              validator!.call(controller.text)!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Jadwal Baru',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1976D2), // Warna biru gelap yang konsisten dengan gradient
            )),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton( // Mengubah icon back
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded, // Ikon panah belakang yang lebih elegan
            color: Color(0xFF1976D2), // Warna biru gelap yang konsisten
            size: 28.0, // Ukuran ikon sedikit lebih besar
          ),
          onPressed: () {
            Navigator.pop(context); // Fungsi default untuk kembali
          },
          tooltip: 'Kembali', // Tooltip untuk UX
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              _buildCustomTextFormField(
                controller: _namaBidanController,
                labelText: 'Nama Bidan',
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Bidan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              _buildCustomTextFormField(
                controller: _tanggalController,
                labelText: 'Tanggal',
                prefixIcon: Icons.calendar_today,
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal tidak boleh kosong';
                  }
                  return null;
                },
              ),
              _buildCustomTextFormField(
                controller: _startTimeController,
                labelText: 'Waktu Mulai',
                prefixIcon: Icons.access_time,
                readOnly: true,
                onTap: () => _selectTime(context, _startTimeController),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Waktu Mulai tidak boleh kosong';
                  }
                  return null;
                },
              ),
              _buildCustomTextFormField(
                controller: _endTimeController,
                labelText: 'Waktu Selesai ',
                prefixIcon: Icons.access_time,
                readOnly: true,
                onTap: () => _selectTime(context, _endTimeController),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Waktu Selesai tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSaving ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2980B9),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Simpan Jadwal',
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}