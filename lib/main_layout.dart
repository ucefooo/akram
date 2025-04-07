import 'dart:async';

import 'package:fixahead/classes/language.dart';
import 'package:fixahead/classes/language_constants.dart';
import 'package:fixahead/classes/menu_items.dart';
import 'package:fixahead/main.dart';
import 'package:fixahead/router/custom_router.dart';
import 'package:fixahead/router/route_constants.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  final String initialRoute;
  const MainLayout({super.key, this.initialRoute = homeRoute});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late String currentRoute;

  @override
  void initState() {
    super.initState();
    currentRoute = widget.initialRoute;
  }

  String getTitle(BuildContext context) {
    switch (currentRoute) {
      case homeRoute:
        return translation(context).homePage;
      case newCaseRoute:
        return translation(context).newCase;
      case savedCaseRoute:
        return translation(context).savedCases;
      case settingsRoute:
        return translation(context).settings;
      default:
        return translation(context).homePage;
    }
  }

  void updateRoute(String route) {
    setState(() {
      currentRoute = route;
    });
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

  bool _whichLanguageSelected(BuildContext context, String languageCode) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode.toUpperCase() == languageCode.toUpperCase();
  }

  Widget languageIcon(BuildContext context, String languageCode) {
    return _whichLanguageSelected(context, languageCode)
        ? const Icon(Icons.check, color: Color(0xFF085cc9), size: 25)
        : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: currentRoute != homeRoute ? backgroundColor : textColor,
            size: 37.0,
          ),
          title: Text(
            getTitle(context),
            style: TextStyle(
              color: currentRoute != homeRoute ? backgroundColor : textColor,
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PopupMenuButton<Language>(
                    offset: const Offset(0, 35),
                    onSelected: (Language language) async {
                      Locale locale = await setLocale(language.languageCode);
                      MainApp.setLocale(context, locale);
                    },
                    itemBuilder: (
                      BuildContext context,
                    ) {
                      return [
                        PopupMenuItem<Language>(
                          enabled:
                              false, // Disable the menu item to prevent it from being selectable
                          height: 25,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              translation(context).changeLanguage,
                              style: TextStyle(
                                fontSize: 12,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                        // const PopupMenuDivider(), // Add a divider
                        PopupMenuItem<Language>(
                          enabled: false,
                          height: 15,
                          child: Divider(
                            height: 1, // Height of the divider
                            thickness: 2, // Thickness of the divider
                            color: textColor, // Color of the divider
                          ),
                        ),
                        ...Language.languageList()
                            .map<PopupMenuItem<Language>>((Language language) {
                          return PopupMenuItem<Language>(
                            value: language,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      language.flag,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      language.name,
                                      style: TextStyle(
                                          fontSize: 14, color: textColor),
                                    ),
                                  ],
                                ),
                                // _whichLanguageSelected(context) ? const Icon(Icons.check, color: Color(0xFF085cc9), size: 20) : const SizedBox.shrink(),
                                languageIcon(context, language.languageCode),
                              ],
                            ),
                          );
                        }),
                      ];
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: currentRoute != homeRoute
                              ? backgroundColor
                              : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Row(
                              children: [
                                Text(
                                  _getFlag(context),
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  _getLanguageCode(context),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: currentRoute != homeRoute
                                        ? backgroundColor
                                        : textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 18,
                            color: currentRoute != homeRoute
                                ? backgroundColor
                                : Colors.grey,
                          ),
                          Container(
                            height: 20,
                            width: 1,
                            color: currentRoute != homeRoute
                                ? backgroundColor
                                : textColor,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Icon(
                              Icons.language,
                              size: 18,
                              color: currentRoute != homeRoute
                                  ? backgroundColor
                                  : textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
          backgroundColor: currentRoute == homeRoute
              ? Theme.of(context).scaffoldBackgroundColor
              : const Color(0xFF085cc9),
        ),
        drawer: Drawer(
          child: _drawerList(context),
        ),
        body: Navigator(
          key: navigatorKey,
          onGenerateRoute: (settings) {
            Future(() async {
              setState(() {
                currentRoute = settings.name ?? homeRoute;
              });
            });
            return CustomRouter.generatedRoute(settings);
          },
          initialRoute: currentRoute,
        ),
      );
    });
  }

  Widget _drawerList(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.black : Colors.white;
    // Move your drawer list code here from HomePage
    // ...
    List<MenuItems> menuItems = [
      MenuItems(
          title: translation(context).homePage,
          icon: Icons.home_outlined,
          route: homeRoute),
      MenuItems(
          title: translation(context).newCase,
          icon: Icons.add,
          route: newCaseRoute),
      MenuItems(
          title: translation(context).savedCases,
          icon: Icons.save,
          route: savedCaseRoute),
    ];

    MenuItems paramItem = MenuItems(
        title: translation(context).settings,
        icon: Icons.settings,
        route: settingsRoute);
    return Container(
      color: const Color(0xFF085cc9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 100,
            padding: const EdgeInsets.all(16),
            alignment: Alignment.bottomLeft,
            child: Text(
              translation(context).menu,
              style: TextStyle(
                color: textColor,
                fontSize: 25,
              ),
            ),
          ),
          Divider(
            color: textColor,
            thickness: 1.0,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ...menuItems.map((value) => DrawerListPath(
                    context: context, menuItems: value, textColor: textColor)),
              ],
            ),
          ),
          Divider(
            height: 5.0,
            color: textColor,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 2.0),
            child: SizedBox(
                height: 60,
                child: Container(
                  alignment: Alignment.center,
                  child: DrawerListPath(
                      context: context,
                      menuItems: paramItem,
                      textColor: textColor),
                )),
          ),
        ],
      ),
    );
  }
}

class DrawerListPath extends StatelessWidget {
  const DrawerListPath({
    super.key,
    required this.context,
    required this.menuItems,
    required this.textColor,
  });

  final BuildContext context;
  final MenuItems menuItems;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5.0),
      child: ListTile(
        leading: Icon(
          menuItems.icon,
          color: textColor,
          size: 35,
        ),
        title: Text(
          menuItems.title,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: textColor,
          size: 25.0,
        ),
        onTap: () {
          // To close the Drawer
          Navigator.pop(context);
          // Navigating to About Page
          // Navigator.pushNamed(context, menuItems.route);
          //  Navigator.of(context).pushReplacementNamed(menuItems.route);
          if (menuItems.route == settingsRoute) {
            Navigator.of(context).pushNamed(menuItems.route);
          } else {
            _MainLayoutState? mainLayoutState =
                context.findAncestorStateOfType<_MainLayoutState>();
            mainLayoutState?.navigatorKey.currentState
                ?.pushReplacementNamed(menuItems.route);
            mainLayoutState?.updateRoute(menuItems.route);
          }
        },
      ),
    );
  }
}
