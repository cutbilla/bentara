import 'package:flutter/material.dart';
import 'dart:math';
import 'package:dropdown_search/dropdown_search.dart'; 
import 'data_service.dart';

class Trafo {
  final String unitUp;
  final String nomorGardu;
  final String namaGardu;
  final String alamat;
  final double latitude;
  final double longitude;
  final String kapasitasTrafo;
  final String feeder;
  final String pemakaian;
  final String iRataRata;
  final String unbalanced;
  final String update;

  Trafo({
    required this.unitUp,
    required this.nomorGardu,
    required this.namaGardu,
    required this.alamat,
    required this.latitude,
    required this.longitude,
    required this.kapasitasTrafo,
    required this.feeder,
    required this.pemakaian,
    required this.iRataRata,
    required this.unbalanced,
    required this.update,
  });

  factory Trafo.fromCsv(List<dynamic> row) {
    String latStr = row[4].toString().replaceAll(',', '.');
    String lonStr = row[5].toString().replaceAll(',', '.');

    return Trafo(
      unitUp: row[0].toString(),
      nomorGardu: row[1].toString(),
      namaGardu: row[2].toString(),
      alamat: row[3].toString(),
      latitude: double.tryParse(latStr) ?? 0.0,
      longitude: double.tryParse(lonStr) ?? 0.0,
      kapasitasTrafo: row[6].toString(),
      feeder: row[7].toString(),
      pemakaian: row[8].toString(),
      iRataRata: row[9].toString(),
      unbalanced: row[10].toString(),
      update: row[11].toString(),
    );
  }

  @override
  String toString() => namaGardu; 
}

class HitungJarakPage extends StatefulWidget {
  const HitungJarakPage({super.key});

  @override
  State<HitungJarakPage> createState() => _HitungJarakPageState();
}

class _HitungJarakPageState extends State<HitungJarakPage> {
  List<Trafo> daftarTrafo = [];
  Trafo? selectedTrafo;

  final TextEditingController latController = TextEditingController();
  final TextEditingController longController = TextEditingController();

  double? jarak;

  @override
  void initState() {
    super.initState();
    loadCsvData();
  }

  Future<void> loadCsvData() async {
    final rows = await DataService.loadData(); // ambil dari DataService
    setState(() {
      daftarTrafo = rows.skip(1).map((row) => Trafo.fromCsv(row)).toList();
      selectedTrafo = null;
    });
  }

  // fungsi menghitung jarak (Haversine Formula)
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

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.location_on, color: Color(0xFF395886), size: 50),
                  SizedBox(width: 8),
                  Text(
                    "Hitung Jarak \n(Parameter Gardu)",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF395886),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Dropdown Search untuk Gardu
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: DropdownSearch<Trafo>(
                  items: daftarTrafo,
                  itemAsString: (Trafo? t) => t?.namaGardu ?? "",
                  selectedItem: selectedTrafo,
                  popupProps: const PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: "Cari Nama Gardu...",
                        contentPadding: EdgeInsets.all(12),
                      ),
                    ),
                  ),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Pilih Gardu",
                      labelStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF395886),
                      ),
                      filled: true,
                      fillColor: Color(0xFFE0EDFF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedTrafo = value;
                      jarak = null;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              if (selectedTrafo != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCADAFF),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow("Latitude", selectedTrafo!.latitude.toString()),
                        _infoRow("Longitude", selectedTrafo!.longitude.toString()),
                        _infoRow("Unit UP", selectedTrafo!.unitUp),
                        _infoRow("Nomor Gardu", selectedTrafo!.nomorGardu),
                        _infoRow("Nama Gardu", selectedTrafo!.namaGardu),
                        _infoRow("Alamat", selectedTrafo!.alamat),
                        _infoRow("Kapasitas Trafo (kVA)", selectedTrafo!.kapasitasTrafo),
                        _infoRow("Feeder", selectedTrafo!.feeder),
                        _infoRow("Pemakaian (%)", selectedTrafo!.pemakaian),
                        _infoRow("I rata-rata (A)", selectedTrafo!.iRataRata),
                        _infoRow("Unbalanced (%)", selectedTrafo!.unbalanced),
                        _infoRow("Update", selectedTrafo!.update),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              _inputField(controller: latController, label: "Masukkan Latitude"),
              const SizedBox(height: 20),
              _inputField(controller: longController, label: "Masukkan Longitude"),

              const SizedBox(height: 30),

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
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                    ),
                    onPressed: () {
                      if (selectedTrafo != null &&
                          latController.text.isNotEmpty &&
                          longController.text.isNotEmpty) {
                        double userLat = double.tryParse(latController.text) ?? 0;
                        double userLon = double.tryParse(longController.text) ?? 0;
                        double distance = hitungJarak(
                          userLat,
                          userLon,
                          selectedTrafo!.latitude,
                          selectedTrafo!.longitude,
                        );
                        setState(() {
                          jarak = distance;
                        });
                      }
                    },
                    child: const Text("Hitung Jarak",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF395886),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedTrafo = null;
                        latController.clear();
                        longController.clear();
                        jarak = null;
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("Refresh",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              if (jarak != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEFFAF),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
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
                            fontSize: 36,
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

  Widget _inputField({
    required TextEditingController controller,
    required String label,
  }) {
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

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(
                fontFamily: 'Sen',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF395886),
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: Color(0xFF395886),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
