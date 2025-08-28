import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;

class DataService {
  static const expectedHeader = [
    "UNIT UP",
    "NOMOR GARDU",
    "NAMA GARDU",
    "ALAMAT",
    "LATITUDE",
    "LONGITUDE",
    "KAPASITAS TRAFO (kVA)",
    "FEEDER",
    "Pemakaian (%)",
    "I rata-rata (A)",
    "Unbalanced (%)",
    "Update",
  ];

  // Lokasi file lokal
  static Future<File> _localFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/data.csv');
  }

  // Load data (prioritas lokal, fallback asset)
  static Future<List<List<dynamic>>> loadData() async {
    try {
      final file = await _localFile();
      String content;

      if (await file.exists()) {
        // 🔹 baca dari file lokal
        content = await file.readAsString();
      } else {
        // 🔹 kalau belum ada file lokal, ambil dari asset bawaan
        content = await rootBundle.loadString("assets/data/data.csv");
      }

      return const CsvToListConverter().convert(content);
    } catch (e) {
      return [];
    }
  }

  // Parse file CSV/XLSX hasil upload
  static Future<List<List<dynamic>>> parseFile(File file) async {
    if (file.path.endsWith(".csv")) {
      final content = await file.readAsString();
      return const CsvToListConverter().convert(content);
    } else if (file.path.endsWith(".xlsx")) {
      final bytes = await file.readAsBytes();
      final excel = Excel.decodeBytes(bytes);
      final sheet = excel.tables.keys.first;
      return excel.tables[sheet]!.rows;
    }
    throw "Format file tidak didukung";
  }

  // Simpan data ke lokal
  static Future<void> saveData(List<List<dynamic>> rows) async {
    final file = await _localFile();

    // 🔹 Pastikan header ada di baris pertama
    List<List<dynamic>> allRows = [];
    if (_rowEqualsHeader(rows.first)) {
      allRows = rows; // sudah ada header
    } else {
      allRows = [expectedHeader, ...rows]; // tambahkan header default
    }

    final csv = const ListToCsvConverter().convert(allRows);
    await file.writeAsString(csv);
  }

  // Bersihkan data
  static Future<void> clearData() async {
    final file = await _localFile();
    if (await file.exists()) {
      await file.delete();
    }
  }

  // 🔹 Cek apakah baris sama persis dengan header
  static bool _rowEqualsHeader(List<dynamic> row) {
    if (row.length != expectedHeader.length) return false;
    for (int i = 0; i < expectedHeader.length; i++) {
      if (row[i].toString().trim() != expectedHeader[i]) return false;
    }
    return true;
  }
}
