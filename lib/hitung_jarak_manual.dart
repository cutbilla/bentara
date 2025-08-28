import 'dart:math';
import 'package:flutter/material.dart';

class HitungJarakManualPage extends StatefulWidget {
  const HitungJarakManualPage({super.key});

  @override
  State<HitungJarakManualPage> createState() => _HitungJarakManualPageState();
}

class _HitungJarakManualPageState extends State<HitungJarakManualPage> {
  final TextEditingController trafoLatController = TextEditingController();
  final TextEditingController trafoLongController = TextEditingController();
  final TextEditingController userLatController = TextEditingController();
  final TextEditingController userLongController = TextEditingController();

  double? jarak;

  double hitungJarak(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // radius bumi km
    double dLat = _deg2rad(lat2 - lat1);
    double dLon = _deg2rad(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * (pi / 180);

  void prosesHitung() {
    final latTrafo =
        double.tryParse(trafoLatController.text.replaceAll(',', '.')) ?? 0.0;
    final lonTrafo =
        double.tryParse(trafoLongController.text.replaceAll(',', '.')) ?? 0.0;
    final latUser =
        double.tryParse(userLatController.text.replaceAll(',', '.')) ?? 0.0;
    final lonUser =
        double.tryParse(userLongController.text.replaceAll(',', '.')) ?? 0.0;

    setState(() {
      jarak = hitungJarak(latUser, lonUser, latTrafo, lonTrafo);
    });
  }

  void reset() {
    trafoLatController.clear();
    trafoLongController.clear();
    userLatController.clear();
    userLongController.clear();
    setState(() {
      jarak = null;
    });
  }

  // versi custom input
  Widget _inputField({
    required TextEditingController controller,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF395886))),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "0.0000",
              hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFFF0F3FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

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

              const SizedBox(height: 16),

              // Judul
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.location_searching,
                      color: Color(0xFF395886), size: 50),
                  SizedBox(width: 8),
                  Text(
                    "Hitung Jarak \nManual",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF395886),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Koordinat Trafo
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: const Color(0xFFE0EAF8),
                child: const Text(
                  "Koordinat Gardu",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF395886),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              _inputField(
                  controller: trafoLatController,
                  label: "Masukkan Latitude "),
              _inputField(
                  controller: trafoLongController,
                  label: "Masukkan Longitude "),

              const SizedBox(height: 30),

              // Koordinat User
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: const Color(0xFFE0EAF8),
                child: const Text(
                  "Koordinat Pelanggan",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF395886),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              _inputField(
                  controller: userLatController,
                  label: "Masukkan Latitude "),
              _inputField(
                  controller: userLongController,
                  label: "Masukkan Longitude "),

              const SizedBox(height: 30),

              // Tombol Hitung & Refresh
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEFFAF),
                      foregroundColor: const Color(0xFF395886),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 14),
                    ),
                    onPressed: prosesHitung,
                    child: const Text("Hitung Jarak",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF395886),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                    ),
                    onPressed: reset,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Refresh",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              if (jarak != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEFFAF),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Jarak Pelanggan ke Gardu adalah",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Sen',
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF395886),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${jarak!.toStringAsFixed(2)} km",
                          style: const TextStyle(
                            fontSize: 35,
                            fontFamily: 'Sen',
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF395886),
                          ),
                        ),
                      ],
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
