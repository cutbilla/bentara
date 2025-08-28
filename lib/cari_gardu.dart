import 'package:flutter/material.dart';
import 'dart:math';
import 'data_service.dart';

class Trafo {
  final String unitUp;
  final String nomorGardu;
  final String namaGardu;
  final String alamat;
  final double latitude;
  final double longitude;
  final String kapasitas;
  final String feeder;
  final String pemakaian;
  final String iRataRata;
  final String unbalanced;
  final String updateUsd;

  Trafo({
    required this.unitUp,
    required this.nomorGardu,
    required this.namaGardu,
    required this.alamat,
    required this.latitude,
    required this.longitude,
    required this.kapasitas,
    required this.feeder,
    required this.pemakaian,
    required this.iRataRata,
    required this.unbalanced,
    required this.updateUsd,
  });

  factory Trafo.fromCsv(List<dynamic> row) {
    return Trafo(
      unitUp: row[0].toString(),
      nomorGardu: row[1].toString(),
      namaGardu: row[2].toString(),
      alamat: row[3].toString(),
      latitude: double.tryParse(row[4].toString()) ?? 0.0,
      longitude: double.tryParse(row[5].toString()) ?? 0.0,
      kapasitas: row[6].toString(),
      feeder: row[7].toString(),
      pemakaian: row[8].toString(),
      iRataRata: row[9].toString(),
      unbalanced: row[10].toString(),
      updateUsd: row.length > 11 ? row[11].toString() : "",
    );
  }
}

class TrafoWithDistance {
  final Trafo trafo;
  final double jarak;

  TrafoWithDistance({required this.trafo, required this.jarak});
}

class CariTrafoPage extends StatefulWidget {
  const CariTrafoPage({super.key});

  @override
  State<CariTrafoPage> createState() => _CariTrafoPageState();
}

class _CariTrafoPageState extends State<CariTrafoPage> {
  final TextEditingController latController = TextEditingController();
  final TextEditingController lngController = TextEditingController();

  List<Trafo> daftarTrafo = [];
  List<TrafoWithDistance> hasilPencarian = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadCsvData();
  }

  Future<void> loadCsvData() async {
    final rows = await DataService.loadData(); // ambil dari DataService
    setState(() {
      daftarTrafo = rows.skip(1).map((row) => Trafo.fromCsv(row)).toList();
    });
  }

  double hitungJarak(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // km
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

  void cariTrafoTerdekat() {
    if (latController.text.isEmpty || lngController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi latitude dan longitude')),
      );
      return;
    }

    double userLat = double.tryParse(latController.text) ?? 0;
    double userLng = double.tryParse(lngController.text) ?? 0;

    if (userLat == 0 || userLng == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format koordinat tidak valid')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    List<TrafoWithDistance> allTrafoWithDistance = daftarTrafo.map((trafo) {
      double jarak = hitungJarak(userLat, userLng, trafo.latitude, trafo.longitude);
      return TrafoWithDistance(trafo: trafo, jarak: jarak);
    }).toList();

    List<TrafoWithDistance> trafoInRange =
        allTrafoWithDistance.where((item) => item.jarak <= 2.0).toList();

    trafoInRange.sort((a, b) => a.jarak.compareTo(b.jarak));

    setState(() {
      hasilPencarian = trafoInRange.take(5).toList();
      isLoading = false;
    });

    if (hasilPencarian.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada trafo dalam radius 2KM')),
      );
    }
  }

  void clearForm() {
    setState(() {
      latController.clear();
      lngController.clear();
      hasilPencarian.clear();
    });
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    latController.dispose();
    lngController.dispose();
    super.dispose();
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
              // HEADER
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

              // JUDUL
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.search, color: Color(0xFF395886), size: 50),
                  SizedBox(width: 8),
                  Text(
                    "Cari 5 Gardu \nTerdekat",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF395886),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              _buildInputField("Masukkan Latitude", "0.0000", latController),
              const SizedBox(height: 20),
              _buildInputField("Masukkan Longitude", "0.0000", lngController),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: isLoading ? null : cariTrafoTerdekat,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEFFAF),
                      foregroundColor: const Color(0xFF395886),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 4,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text("Cari Gardu Terdekat",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: clearForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF395886),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 4,
                    ),
                    icon: const Icon(Icons.refresh, size: 15),
                    label: const Text("Refresh",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              if (hasilPencarian.isNotEmpty) ...[
                const Text(
                  "5 Gardu Terdekat (≤ 2KM)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF395886),
                  ),
                ),
                const SizedBox(height: 20),
                ...hasilPencarian.asMap().entries.map((entry) {
                  int index = entry.key;
                  TrafoWithDistance item = entry.value;
                  return _buildTrafoCard(index, item);
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF395886))),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
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

  Widget _buildTrafoCard(int index, TrafoWithDistance item) {
    return InkWell(
      onTap: () {
        _showDetailDialog(item.trafo, item.jarak);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F3FA),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF628ECB),
              child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(item.trafo.namaGardu,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF395886))),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFFEFFAF), borderRadius: BorderRadius.circular(12)),
              child: Text('${item.jarak.toStringAsFixed(2)} km',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF395886))),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailDialog(Trafo trafo, double jarak) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(trafo.namaGardu, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF395886))),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('No. Gardu', trafo.nomorGardu),
                _buildInfoRow('Alamat', trafo.alamat),
                _buildInfoRow('Feeder', trafo.feeder),
                _buildInfoRow('Kapasitas', '${trafo.kapasitas} kVA'),
                _buildInfoRow('Pemakaian', trafo.pemakaian),
                _buildInfoRow('I Rata2', trafo.iRataRata),
                _buildInfoRow('Unbalanced', trafo.unbalanced),
                _buildInfoRow('Latitude', trafo.latitude.toString()),
                _buildInfoRow('Longitude', trafo.longitude.toString()),
                _buildInfoRow('ULP', trafo.unitUp),
                _buildInfoRow('Update', trafo.updateUsd),
                _buildInfoRow('Jarak', '${jarak.toStringAsFixed(2)} km'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Tutup", style: TextStyle(color: Color(0xFF628ECB))),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text('$label:',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF628ECB))),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12, color: Color(0xFF395886)))),
        ],
      ),
    );
  }
}
