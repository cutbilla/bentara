import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

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

  // Lokasi file CSV lokal
  static Future<File> _localFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/data.csv');
  }

  // ---------------- METADATA (pakai SharedPreferences) ----------------
  static Future<void> saveMetadata(String fileName, String tanggal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fileName', fileName);
    await prefs.setString('tanggal', tanggal);
  }

  static Future<Map<String, String>> loadMetadata() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'fileName': prefs.getString('fileName') ?? '-',
      'tanggal': prefs.getString('tanggal') ?? '-',
    };
  }

  static Future<void> clearMetadata() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('fileName');
    await prefs.remove('tanggal');
  }

  // ---------------- CEK DATA ----------------
  static Future<bool> hasExistingData() async {
    final file = await _localFile();
    final exists = await file.exists();
    if (!exists) return false;
    final length = await file.length();
    return length > 0;
  }

  // ---------------- LOAD DATA ----------------
  static Future<List<List<dynamic>>> loadData() async {
    try {
      final file = await _localFile();
      String content;

      if (await file.exists()) {
        content = await file.readAsString();
      } else {
        // fallback ke asset bawaan
        content = await rootBundle.loadString("assets/data/data.csv");
      }

      return const CsvToListConverter().convert(content);
    } catch (e) {
      return [];
    }
  }

  // ---------------- PARSE FILE UPLOAD ----------------
  static Future<Map<String, dynamic>> parseFile(File file) async {
    List<List<dynamic>> rows;

    if (file.path.endsWith(".csv")) {
      final content = await file.readAsString();
      rows = const CsvToListConverter().convert(content);
    } else if (file.path.endsWith(".xlsx")) {
      final bytes = await file.readAsBytes();
      final excel = Excel.decodeBytes(bytes);
      final sheet = excel.tables.keys.first;
      rows = excel.tables[sheet]!.rows;
    } else {
      throw "Format file tidak didukung";
    }

    String fileName = file.path.split('/').last;
    String tanggal = _extractDateFromFileName(fileName);

    return {
      'rows': rows,
      'fileName': fileName,
      'tanggal': tanggal,
    };
  }

  // ---------------- SIMPAN DATA ----------------
  static Future<void> saveData(List<List<dynamic>> rows) async {
    if (await hasExistingData()) {
      throw "Data lama masih ada! Harap bersihkan dulu sebelum mengunggah data baru.";
    }

    final file = await _localFile();

    List<List<dynamic>> allRows = [];
    if (_rowEqualsHeader(rows.first)) {
      allRows = rows;
    } else {
      allRows = [expectedHeader, ...rows];
    }

    final csv = const ListToCsvConverter().convert(allRows);
    await file.writeAsString(csv);
  }

  // ---------------- HAPUS DATA ----------------
  static Future<void> clearData() async {
    final file = await _localFile();
    if (await file.exists()) {
      await file.delete();
    }
  }

  // ---------------- UTIL ----------------
  static bool _rowEqualsHeader(List<dynamic> row) {
    if (row.length != expectedHeader.length) return false;
    for (int i = 0; i < expectedHeader.length; i++) {
      if (row[i].toString().trim() != expectedHeader[i]) return false;
    }
    return true;
  }

  static String _extractDateFromFileName(String fileName) {
    final regex = RegExp(r'_(\d{6})\.(csv|xlsx)$', caseSensitive: false);
    final match = regex.firstMatch(fileName);

    if (match != null) {
      final dateStr = match.group(1)!; // contoh: 280825
      final day = dateStr.substring(0, 2);
      final month = dateStr.substring(2, 4);
      final year = '20${dateStr.substring(4, 6)}';
      return '$day/$month/$year';
    }
    return 'Tanggal tidak ditemukan';
  }
}
