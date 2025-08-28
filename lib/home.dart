import 'package:flutter/material.dart';
import 'hitung_jarak.dart';
import 'hitung_jarak_manual.dart';
import 'cari_gardu.dart';
import 'kelola_data.dart';
import 'informasi_ulp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BENTARA',
      theme: ThemeData(
        fontFamily: 'Sen',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF395886)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView( // biar bisa discroll
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

              const SizedBox(height: 20),
              // Selamat Datang
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Selamat Datang di",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF395886),
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      "BENTARA!",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF395886),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Temukan perhitungan jarak & informasi gardu dengan cepat dan akurat.",
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Color(0xFFA5B2C6),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // Menu cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _menuCard(
                      icon: Icons.location_on,
                      title: "Hitung Jarak",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HitungJarakPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    _menuCard(
                      icon: Icons.location_searching,
                      title: "Hitung Jarak Manual",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HitungJarakManualPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    _menuCard(
                      icon: Icons.search,
                      title: "Cari 5 Gardu terdekat",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CariTrafoPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    _menuCard(
                      icon: Icons.article,
                      title: "Informasi ULP",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InformasiULPPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    _bottomMenu(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // === Helper widgets (di dalam HomePage) ===

  Widget _menuCard({
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F3FA),
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
            Icon(icon, size: 40, color: const Color(0xFF395886)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF395886),
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Color(0xFF395886)),
          ],
        ),
      ),
    );
  }

  Widget _bottomMenu(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF395886).withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _bottomItem(
            Icons.menu_book,
            "Panduan\nPenggunaan",
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PanduanPage(),
                ),
              );
            },
          ),
          _bottomItem(
            Icons.table_chart,
            "Kelola\nData",
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const KelolaDataPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _bottomItem(IconData icon, String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: const Color(0xFFE0FDFF),
            child: Icon(icon, color: const Color(0xFF395886), size: 35),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF395886),
            ),
          ),
        ],
      ),
    );
  }
}

// ================== Dummy Pages ==================

class PanduanPage extends StatelessWidget {
  const PanduanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Panduan Penggunaan")),
      body: const Center(child: Text("Isi panduan penggunaan di sini")),
    );
  }
}


