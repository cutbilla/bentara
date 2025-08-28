import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'data_service.dart'; // pake service yg udah kamu buat

class KelolaDataPage extends StatefulWidget {
  const KelolaDataPage({super.key});

  @override
  State<KelolaDataPage> createState() => _KelolaDataPageState();
}

class _KelolaDataPageState extends State<KelolaDataPage> {
  int _jumlahData = 0;

  @override
  void initState() {
    super.initState();
    _loadCSV();
  }

  // ======== LOAD CSV via DataService ========
  Future<void> _loadCSV() async {
    try {
      final rows = await DataService.loadData();
      setState(() {
        _jumlahData = rows.length > 1 ? rows.length - 1 : 0; // skip header
      });
    } catch (_) {
      setState(() => _jumlahData = 0);
    }
  }

  // ======== UPLOAD (pakai DataService) ========
  Future<void> _uploadCSV() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx'],
    );
    if (result == null || result.files.single.path == null) return;

    final picked = File(result.files.single.path!);

    try {
      // parsing isi file (csv/xlsx)
      final rows = await DataService.parseFile(picked);

      // validasi jumlah kolom
      final wrong = rows.indexWhere((r) => r.length != DataService.expectedHeader.length);
      if (wrong != -1) {
        _showSnackBar("Jumlah kolom di baris ${wrong + 1} tidak sesuai template.");
        return;
      }

      // simpan data ke lokal
      await DataService.saveData(rows);

      _showSnackBar("Upload data berhasil!");
      _loadCSV();
    } catch (e) {
      _showSnackBar("Gagal memproses file: $e");
    }
  }

  // ======== HAPUS DATA ========
  Future<void> _bersihkanData() async {
    await DataService.clearData();
    setState(() => _jumlahData = 0);
    _showSnackBar("Semua data terhapus!");
  }

  // ======== SNACKBAR ========
  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  // ======== POPUP UPLOAD ========
  void _showUploadDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F4FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_upload, size: 80, color: Color(0xFF395886)),
                const SizedBox(height: 10),
                const Text(
                  "Masukkan Data Baru",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF395886)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF395886),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _uploadCSV();
                  },
                  child: const Text("Upload data"),
                ),
                const SizedBox(height: 8),
                const Text("*CSV (.csv) atau Excel (.xlsx)", style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        );
      },
    );
  }

  // ======== POPUP HAPUS ========
  void _showHapusDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.delete_forever, size: 80, color: Colors.red),
                const SizedBox(height: 10),
                const Text(
                  "Semua Data Akan Terhapus",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Yakin ingin tetap melakukan pembersihan data?",
                  style: TextStyle(color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _bersihkanData();
                  },
                  child: const Text("Hapus data"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ======== UI ========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFCEE3FF), Color(0xFF628ECB), Color(0xFFCEE3FF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "BENTARA",
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFEFFAF),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Judul
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.table_chart, color: Color(0xFF395886), size: 50),
                  SizedBox(width: 8),
                  Text(
                    "Kelola Data",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF395886),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Card jumlah data trafo
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFD5),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bar_chart, size: 70, color: Color(0xFF395886)),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Jumlah Data Trafo",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF395886),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "$_jumlahData data",
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF395886),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Tombol Update Data
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 230,
                  child: ElevatedButton.icon(
                    onPressed: _showUploadDialog,
                    icon: const Icon(Icons.upload, size: 25),
                    label: const Text("Update data", style: TextStyle(fontSize: 20)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF86E49F),
                      foregroundColor: const Color(0xFF395886),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Tombol Bersihkan Data
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 230,
                  child: ElevatedButton.icon(
                    onPressed: _showHapusDialog,
                    icon: const Icon(Icons.delete_forever, size: 25),
                    label: const Text("Bersihkan data", style: TextStyle(fontSize: 20)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFA5B5B),
                      foregroundColor: const Color(0xFFFFFFD5),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
