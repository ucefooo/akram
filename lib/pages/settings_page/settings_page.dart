import 'package:flutter/material.dart';
import 'package:fixahead/classes/language.dart';
import 'package:fixahead/classes/language_constants.dart';
import 'package:fixahead/main.dart';
import 'package:fixahead/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDarkModePreference();
  }

  Future<void> _loadDarkModePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _isLoading = false;
    });
  }

  Future<void> _saveDarkModePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  String _getFlag(BuildContext context) {
    final locale = Localizations.localeOf(context);
    switch (locale.languageCode) {
      case 'en':
        return '🇺🇸';
      case 'fr':
        return '🇫🇷';
      case 'ar':
        return '🇲🇦';
      default:
        return '🇬🇧';
    }
  }

  String _getLanguageCode(BuildContext context) {
    final locale = Localizations.localeOf(context);
    switch (locale.languageCode) {
      case 'en':
        return 'EN';
      case 'fr':
        return 'FR';
      case 'ar':
        return 'AR';
      default:
        return 'EN';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context).settings),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        translation(context).darkMode,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Switch(
                        value: _isDarkMode,
                        activeColor: const Color(0xFF085cc9),
                        onChanged: (value) async {
                          setState(() {
                            _isDarkMode = value;
                          });
                          await _saveDarkModePreference(value);
                          Provider.of<ThemeProvider>(context, listen: false).toggleTheme(value);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        translation(context).changeLanguage,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      PopupMenuButton<Language>(
                        offset: const Offset(0, 40),
                        onSelected: (Language language) async {
                          Locale locale = await setLocale(language.languageCode);
                          MainApp.setLocale(context, locale);
                        },
                        itemBuilder: (BuildContext context) {
                          return Language.languageList().map<PopupMenuEntry<Language>>((Language language) {
                            bool isSelected = language.languageCode == Localizations.localeOf(context).languageCode;
                            return PopupMenuItem<Language>(
                              value: language,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected && _isDarkMode ? const Color(0xFF085cc9) : null,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Text(
                                          language.flag,
                                          style: const TextStyle(fontSize: 30),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(language.name),
                                      ],
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check,
                                        color: _isDarkMode ? Colors.white : const Color(0xFF085cc9),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _getFlag(context),
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                _getLanguageCode(context),
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 5),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}