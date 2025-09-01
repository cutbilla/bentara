import 'package:flutter/material.dart';

class ULPPage extends StatelessWidget {
  const ULPPage({super.key});

  final List<Map<String, String>> ulpList = const [
    {"code": "1121", "name": "ULP Lhokseumawe"},
    {"code": "1122", "name": "ULP Takengon"},
    {"code": "1123", "name": "ULP Janarata"},
    {"code": "1124", "name": "ULP Gandapura"},
    {"code": "1125", "name": "ULP Kruenggeukueh"},
    {"code": "1126", "name": "ULP Geudong"},
    {"code": "1127", "name": "ULP Lhoksukon"},
    {"code": "1128", "name": "ULP Panton Labu"},
    {"code": "1129", "name": "ULP Matang Glumpang Dua"},
    {"code": "1130", "name": "ULP Samalanga"},
  ];

  final List<String> kabupatenList = const [
    "Kabupaten Aceh Tengah",
    "Kabupaten Bener Meriah",
    "Kabupaten Bireuen",
    "Kabupaten Aceh Utara",
    "Kota Lhokseumawe",
  ];

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

              const SizedBox(height: 10),

              // Judul
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.article, color: Color(0xFF395886), size: 50),
                  SizedBox(width: 8),
                  Text(
                    "Letak Astronomis &\nDaerah Administratif Unit",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF395886),
                      height: 1.2,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Informasi UP3 Card (gabungan)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFD5),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title UP3
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.business,
                              color: Color(0xFF395886), size: 28),
                          SizedBox(width: 8),
                          Text(
                            "UP3 Lhokseumawe",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF395886),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Peta
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "assets/images/map/lhokseumawe.png",
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Letak Astronomis
                      const Text(
                        "Letak Astronomis :",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF395886),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "4°54'–5°21' LU dan 96°45'–97°24' BT",
                        style: TextStyle(fontSize: 16, color: Color(0xFF395886)),
                      ),

                      const SizedBox(height: 16),

                      // Wilayah Cakupan
                      const Text(
                        "Wilayah Cakupan :",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF395886),
                        ),
                      ),
                      const SizedBox(height: 6),
                      ...kabupatenList.map((kab) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle,
                                  color: Color(0xFF395886), size: 18),
                              const SizedBox(width: 6),
                              Text(
                                kab,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF395886),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 16),

                      // Jumlah Kecamatan
                      const Text(
                        "Jumlah Kecamatan :",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF395886),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "500 Kecamatan",
                        style: TextStyle(fontSize: 16, color: Color(0xFF395886)),
                      ),

                      const SizedBox(height: 16),

                      // Jumlah Desa
                      const Text(
                        "Jumlah Desa :",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF395886),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "1.282 Desa",
                        style: TextStyle(fontSize: 16, color: Color(0xFF395886)),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Daftar Unit
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: ulpList.map((ulp) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 17),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F3FF),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.location_on,
                          color: Color(0xFF395886),
                        ),
                        title: Text(
                          "${ulp["code"]} - ${ulp["name"]}",
                          style: const TextStyle(
                            color: Color(0xFF395886),
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                        onTap: () {
                          // TODO: navigasi ke halaman detail
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
