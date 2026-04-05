import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<Locale> {
  final SharedPreferences prefs;
  LanguageCubit(this.prefs) : super(Locale(prefs.getString('language_code') ?? 'vi'));
  void changeLanguage(String langCode) async {
    await prefs.setString('language_code', langCode);
    emit(Locale(langCode));
  }
}