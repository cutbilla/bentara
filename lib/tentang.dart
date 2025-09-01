import 'package:flutter/material.dart';

class TentangPage extends StatelessWidget {
  const TentangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFCEE3FF), // kiri
                      Color(0xFF628ECB), // tengah
                      Color(0xFFCEE3FF), // kanan
                    ],
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

              SizedBox(height: 10),

                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Versi 1.0.0",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF395886),
                            ),
                          ),
                        ],
                      ),
                    ),

              // Isi konten
              const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "BENTARA (Kalkulator Bentangan & Informasi Gardu Untuk Akselerasi PB/PD)",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF395886),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "BENTARA adalah aplikasi mobile berbasis Flutter yang dikembangkan "
                      "untuk membantu perhitungan jarak pelanggan ke gardu serta manajemen data trafo. "
                      "Aplikasi ini bekerja secara offline, semua data disimpan langsung di dalam perangkat"
                      "masing-masing, sehingga setiap pengguna dapat menyimpan dan mengelola data yang berbeda.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF395886),
                      ),
                    ),
                    SizedBox(height: 20),

                    Text(
                      "✨ Fitur Utama",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF395886),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "1. Hitung Jarak Satu Trafo\n"
                      "   Pilih trafo, masukkan koordinat pelanggan, lalu aplikasi akan menghitung jarak pelanggan ke trafo tersebut.\n",
                      style: TextStyle(fontSize: 15, color: Color(0xFF395886)),
                    ),
                    Text(
                      "2. Hitung Jarak Manual\n"
                      "   Pengguna dapat memasukkan lintang (latitude) dan bujur (longitude) secara manual untuk menghitung jarak.\n",
                      style: TextStyle(fontSize: 15, color: Color(0xFF395886)),
                    ),
                    Text(
                      "3. Cari Lima Trafo Terdekat\n"
                      "   Masukkan koordinat pelanggan, aplikasi akan otomatis menampilkan 5 trafo dengan jarak terdekat.\n",
                      style: TextStyle(fontSize: 15, color: Color(0xFF395886)),
                    ),
                    Text(
                      "4. Manajemen Data\n"
                      "   - Tambah atau hapus data trafo\n"
                      "   - Upload data baru menggunakan format CSV/Excel yang sudah disediakan\n"
                      "   - Data yang ditampilkan meliputi:\n"
                      "     UNIT UP, NOMOR GARDU, NAMA GARDU, ALAMAT,\n"
                      "     LATITUDE, LONGITUDE, KAPASITAS TRAFO (kVA), FEEDER,\n"
                      "     Pemakaian (%), I rata-rata (A), Unbalanced (%), Update\n",
                      style: TextStyle(fontSize: 15, color: Color(0xFF395886)),
                    ),
                    Text(
                      "5. Informasi Letak Astronomis ULP\n"
                      "   Menampilkan daftar ULP beserta informasi koordinat geografis wilayahnya.\n",
                      style: TextStyle(fontSize: 15, color: Color(0xFF395886)),
                    ),
                    SizedBox(height: 20),

                    Text(
                      "📐 Tentang Rumus Haversine",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF395886),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Untuk menghitung jarak antara titik pelanggan dengan trafo, aplikasi ini menggunakan Rumus Haversine.\n\n"
                      "Secara sederhana, cara kerjanya adalah:\n"
                      "• Lokasi di bumi dinyatakan dengan koordinat lintang (latitude) dan bujur (longitude).\n"
                      "• Pertama, aplikasi menghitung selisih lintang dan bujur antara dua titik.\n"
                      "• Selisih itu kemudian diolah menggunakan fungsi trigonometri (sin dan cos) "
                      "untuk memperhitungkan kelengkungan bumi.\n"
                      "• Hasilnya berupa jarak sudut di atas bola bumi.\n"
                      "• Terakhir, jarak tersebut dikalikan dengan jari-jari bumi (± 6.371 km) "
                      "untuk mendapatkan jarak dalam kilometer.\n\n"
                      "Dengan cara ini, aplikasi dapat memberikan hasil yang lebih akurat dibanding sekadar menghitung jarak lurus di atas peta.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 15, color: Color(0xFF395886)),
                    ),

                    SizedBox(height: 40),

                    // Footer versi
                    Center(
                      child: Column(
                        children: [
                          SizedBox(height: 4),
                          Text(
                            "NPS LSM x IT PNL 2025",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF395886),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
