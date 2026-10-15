import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/app_data.dart';

/// Încarcă datele aplicației din fișierul JSON inclus în proiect
/// (assets/data/lab_v1.json), în mod asincron.
class AppRepository {
  final String assetPath;

  const AppRepository({this.assetPath = 'assets/data/lab_v1.json'});

  Future<AppData> loadAppData() async {
    // simulăm puțin timp de încărcare, ca să se vadă starea de Loading în UI
    await Future.delayed(const Duration(milliseconds: 400));

    final raw = await rootBundle.loadString(assetPath);
    final Map<String, dynamic> decoded = jsonDecode(raw) as Map<String, dynamic>;
    return AppData.fromJson(decoded);
  }
}