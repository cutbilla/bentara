import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'data_service.dart'; // path sesuai proyekmu

class KelolaDataPage extends StatefulWidget {
  const KelolaDataPage({super.key});

  @override
  State<KelolaDataPage> createState() => _KelolaDataPageState();
}

class _KelolaDataPageState extends State<KelolaDataPage> {
  int _jumlahData = 0;
  String? _fileName;
  String? _tanggal;

  @override
  void initState() {
    super.initState();
    _loadCSV();
  }

  Future<void> _loadCSV() async {
    try {
      final rows = await DataService.loadData();
      final meta = await DataService.loadMetadata(); // 🔹 ambil metadata juga
      setState(() {
        _jumlahData = rows.length > 1 ? rows.length - 1 : 0;
        _fileName = meta['fileName'];
        _tanggal = meta['tanggal'];
      });
    } catch (_) {
      setState(() {
        _jumlahData = 0;
        _fileName = null;
        _tanggal = null;
      });
    }
  }

  Future<void> _uploadCSV() async {
    // 🔹 cek dulu apakah ada data lama
    if (_jumlahData > 0) {
      _showSnackBar("Data lama masih ada! Harap bersihkan dulu sebelum upload baru.");
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx'],
    );
    if (result == null || result.files.single.path == null) return;

    final picked = File(result.files.single.path!);

    try {
      final parsed = await DataService.parseFile(picked);
      final rows = parsed['rows'] as List<List<dynamic>>;
      final fileName = parsed['fileName'] as String;
      final tanggal = parsed['tanggal'] as String;

      // validasi jumlah kolom
      final wrong = rows.indexWhere((r) => r.length != DataService.expectedHeader.length);
      if (wrong != -1) {
        _showSnackBar("Jumlah kolom di baris ${wrong + 1} tidak sesuai template.");
        return;
      }

      await DataService.saveData(rows);
      await DataService.saveMetadata(fileName, tanggal); // 🔹 simpan metadata

      setState(() {
        _fileName = fileName;
        _tanggal = tanggal;
      });

      _showSnackBar("Upload data berhasil!");
      _loadCSV();
    } catch (e) {
      _showSnackBar("Gagal memproses file: $e");
    }
  }

  Future<void> _bersihkanData() async {
    await DataService.clearData();
    await DataService.clearMetadata(); // 🔹 hapus metadata juga
    setState(() {
      _jumlahData = 0;
      _fileName = null;
      _tanggal = null;
    });
    _showSnackBar("Semua data terhapus!");
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

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

              // Card jumlah data trafo + info file
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                    const SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "Nama File : ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF395886),
                            ),
                          ),
                          TextSpan(
                            text: _fileName ?? '-',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF395886),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "Tanggal : ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF395886),
                            ),
                          ),
                          TextSpan(
                            text: _tanggal ?? '-',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF395886),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Tombol Upload Data
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 250,
                  child: ElevatedButton.icon(
                    onPressed: _uploadCSV,
                    icon: const Icon(Icons.upload, size: 25),
                    label: const Text(
                      "Upload Data Gardu",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF86E49F),
                      foregroundColor: const Color(0xFF395886),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                  width: 250,
                  child: ElevatedButton.icon(
                    onPressed: _bersihkanData,
                    icon: const Icon(Icons.delete_forever, size: 25),
                    label: const Text(
                      "Bersihkan data",
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFA5B5B),
                      foregroundColor: const Color(0xFFFFFFD5),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
