import 'package:detection_app/pages/new_case/new_case_camera_first.dart';
import 'package:flutter/material.dart';
import 'package:detection_app/pages/home_page/home_page.dart';
import 'package:detection_app/pages/new_case/new_case_page.dart';
import 'package:detection_app/pages/not_found_page.dart';
import 'package:detection_app/pages/saved_case/saved_case_page.dart';
import 'package:detection_app/pages/settings_page/settings_page.dart';
import 'package:detection_app/router/route_constants.dart';

class CustomRouter {
  static Route<dynamic> generatedRoute(
      RouteSettings settings) {
    switch (settings.name) {

      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case newCaseRoute:
        return MaterialPageRoute(builder: (_) => const NewCasePage());
      case savedCaseRoute:
        return MaterialPageRoute(builder: (_) => const SavedCasePage());

      case settingsRoute:
        return MaterialPageRoute(builder: (_) => const SettingsPage());

      case 'case2':
        return MaterialPageRoute(builder: (_) => const CameraPage());

      default:
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
    }
  }
}
