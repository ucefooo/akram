import 'package:fixahead/boxes.dart';
import 'package:fixahead/classes/language_constants.dart';
import 'package:fixahead/main_layout.dart';
import 'package:fixahead/pages/new_case/new_case_camera_first.dart';
import 'package:fixahead/pages/saved_case/saved_case_page.dart';
import 'package:fixahead/pages/settings_page/settings_page.dart';
import 'package:fixahead/result.dart';
import 'package:fixahead/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fixahead/router/route_constants.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ResultAdapter());
  boxResult = await Hive.openBox<Result>('userBox');
  runApp(ChangeNotifierProvider(create: (context) => ThemeProvider(), child: const MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MainAppState? state = context.findAncestorStateOfType<_MainAppState>();
    state?.setLocale(newLocale);
  }
}

class _MainAppState extends State<MainApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => {setLocale(locale)});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fixahead',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   primaryColor: const Color(0xFF085cc9),
      // ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
       routes: {
        homeRoute: (context) => const MainLayout(),
        settingsRoute: (context) => const SettingsPage(), // Add the 'settings' route
        'case2': (context) => const CameraPage(), // Add the 'case2' route
        'savedCase': (context) => const SavedCasePage(), // Add the 'savedCase' route
      },
      initialRoute: homeRoute,
      locale: _locale,
      home: const MainLayout(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      // darkTheme: darkMode,
    );
  }
}
