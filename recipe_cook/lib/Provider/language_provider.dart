import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('vi', 'VN'); // Default Vietnamese

  Locale get locale => _locale;

  LanguageProvider() {
    _loadLanguagePreference();
  }

  // Load saved language preference
  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode') ?? 'vi';
    final countryCode = prefs.getString('countryCode') ?? 'VN';
    _locale = Locale(languageCode, countryCode);
    notifyListeners();
  }

  // Change language and save preference
  Future<void> changeLanguage(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    await prefs.setString('countryCode', locale.countryCode ?? '');
    notifyListeners();
  }

  // Toggle between Vietnamese and English
  Future<void> toggleLanguage() async {
    if (_locale.languageCode == 'vi') {
      await changeLanguage(const Locale('en', 'US'));
    } else {
      await changeLanguage(const Locale('vi', 'VN'));
    }
  }

  bool get isVietnamese => _locale.languageCode == 'vi';
  bool get isEnglish => _locale.languageCode == 'en';
}
