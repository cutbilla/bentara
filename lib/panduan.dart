import 'package:flutter/material.dart';

// ================== MODEL ==================
class StepItem {
  final String text;
  final List<String> images;

  StepItem({
    required this.text,
    required this.images,
  });
}

// ================== MAIN PANDUAN PAGE ==================
class PanduanPage extends StatelessWidget {
  const PanduanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ===== Header =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFCEE3FF),
                      Color(0xFF628ECB),
                      Color(0xFFCEE3FF),
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
              const SizedBox(height: 24),

              // ===== Judul =====
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.help_outline, color: Color(0xFF395886), size: 50),
                  SizedBox(width: 8),
                  Text(
                    "Panduan \nPenggunaan",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF395886),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ===== Daftar Menu Panduan =====
              PanduanMenu(
                title: "Hitung Jarak \n(Parameter Gardu)",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPanduanPage(
                        title: "Hitung Jarak \n(Parameter Gardu)",
                        steps: [
                          StepItem(
                            text: "Pilih menu Hitung Jarak.",
                            images: ["assets/images/hitung_jarak/step1.png"],
                          ),
                          StepItem(
                            text: "Pilih Gardu dari daftar gardu yang tersedia.",
                            images: [
                              "assets/images/hitung_jarak/step2.png",
                              "assets/images/hitung_jarak/step2-2.png",
                            ],
                          ),
                          StepItem(
                            text: "Masukkan koordinat pelanggan (Latitude & Longitude).",
                            images: ["assets/images/hitung_jarak/step3.png"],
                          ),
                          StepItem(
                            text: "Klik tombol Hitung Jarak.",
                            images: ["assets/images/hitung_jarak/step4.png"],
                          ),
                          StepItem(
                            text: "Aplikasi menampilkan hasil perhitungan jarak pelanggan ke gardu.",
                            images: ["assets/images/hitung_jarak/step5.png"],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              PanduanMenu(
                title: "Hitung Jarak Manual",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPanduanPage(
                        title: "Hitung Jarak Manual",
                        steps: [
                          StepItem(
                            text: "Pilih menu Hitung Jarak Manual.",
                            images: ["assets/images/hitung_jarak_manual/step1.png"],
                          ),
                          StepItem(
                            text: "Masukkan koordinat gardu dan pelanggan secara manual.",
                            images: ["assets/images/hitung_jarak_manual/step2.png"],
                          ),
                          StepItem(
                            text: "Klik tombol Hitung untuk melihat hasil.",
                            images: ["assets/images/hitung_jarak_manual/step3.png"],
                          ),
                          StepItem(
                            text: "Aplikasi menampilkan hasil perhitungan jarak pelanggan ke gardu.",
                            images: ["assets/images/hitung_jarak_manual/step4.png"],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              PanduanMenu(
                title: "Cari 5 Gardu Terdekat",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPanduanPage(
                        title: "Cari 5 Gardu Terdekat",
                        steps: [
                          StepItem(
                            text: "Pilih menu Cari 5 Gardu.",
                            images: ["assets/images/cari_gardu/step1.png"],
                          ),
                          StepItem(
                            text: "Masukkan koordinat pelanggan (Latitude & Longitude).",
                            images: ["assets/images/cari_gardu/step2.png"],
                          ),
                          StepItem(
                            text:
                                "Klik tombol Cari Gardu Terdekat.Aplikasi akan menampilkan 5 gardu terdekat.",
                            images: ["assets/images/cari_gardu/step3.png"],
                          ),
                          StepItem(
                            text: "Aplikasi akan menampilkan 5 gardu terdekat.",
                            images: ["assets/images/cari_gardu/step4.png"],
                          ),
                          StepItem(
                            text:
                                "Pengguna dapat melihat detail gardu dengan menekan salah satu gardu dipilihan.",
                            images: ["assets/images/cari_gardu/step5.png"],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              PanduanMenu(
                title: "Kelola Data",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPanduanPage(
                        title: "Kelola Data",
                        steps: [
                          StepItem(
                            text: "Pilih menu Kelola Data.",
                            images: ["assets/images/kelola_data/step1.png"],
                          ),
                          StepItem(
                            text: "Klik tombol Bersihkan Data untuk menghapus data gardu yang lama.",
                            images: [
                              "assets/images/kelola_data/step2.png",
                              "assets/images/kelola_data/step2-2.png",
                              "assets/images/kelola_data/step2-3.png",
                            ],
                          ),
                          StepItem(
                            text: "Klik tombol Update Data.",
                            images: [
                              "assets/images/kelola_data/step3.png",
                              "assets/images/kelola_data/step3-2.png",
                            ],
                          ),
                          StepItem(
                            text: "Siapkan file data gardu sesuai dengan format template.",
                            images: ["assets/images/kelola_data/step4.png"],
                          ),
                          StepItem(
                            text: "Pilih file yang sudah disiapkan.",
                            images: ["assets/images/kelola_data/step4.png"],
                          ),
                          StepItem(
                            text:
                                "Aplikasi akan memproses dan menyimpan data gardu baru ke dalam perangkat.",
                            images: ["assets/images/kelola_data/step5.png"],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              PanduanMenu(
                title: "Informasi ULP",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPanduanPage(
                        title: "Informasi ULP",
                        steps: [
                          StepItem(
                            text: "Pilih menu Informasi ULP.",
                            images: ["assets/images/informasi_ulp/step1.png"],
                          ),
                          StepItem(
                            text: "Lihat daftar informasi Unit Layanan Pelanggan.",
                            images: ["assets/images/informasi_ulp/step2.png"],
                          ),
                          StepItem(
                            text: "Klik salah satu ULP untuk melihat detail.",
                            images: ["assets/images/informasi_ulp/step3.png"],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================== WIDGET: Panduan Menu ==================
class PanduanMenu extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const PanduanMenu({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Material(
        color: Colors.yellow[100],
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.help_outline, color: Color(0xFF395886), size: 35),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Panduan\n$title",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF395886),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================== DETAIL PANDUAN PAGE ==================
class DetailPanduanPage extends StatelessWidget {
  final String title;
  final List<StepItem> steps;

  const DetailPanduanPage({
    super.key,
    required this.title,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 253, 213),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ===== Header =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFCEE3FF),
                      Color(0xFF628ECB),
                      Color(0xFFCEE3FF),
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
              const SizedBox(height: 24),

              // ===== Judul Panduan =====
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFCEE3FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.help_outline, color: Color(0xFF395886), size: 35),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Panduan\n$title",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF395886),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ===== Langkah-langkah =====
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: steps.asMap().entries.map((entry) {
                  int index = entry.key + 1;
                  StepItem step = entry.value;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$index. ${step.text}",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color(0xFF395886),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: step.images.map((img) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(img),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
