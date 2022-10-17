import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dynamic_route/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:collection/collection.dart' show IterableExtension;

void main() {
  runApp(const MyApp());
}

class AppState {
  static Map<int, String> mapScreen = {};
  static ValueNotifier<bool> showNavBar = ValueNotifier(false);
  static List<BottomNavigationBarItem> navigationBarItems = [];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Dynamic route',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(primaryColor: Colors.grey),
      routerConfig: router,
    );
  }
}

class AppScaffold extends StatefulWidget {
  const AppScaffold({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  void initState() {
    buildLayout();
    super.initState();
  }

  Future<void> buildLayout() async {
    try {
      final response = await Dio().get(
          'https://gist.githubusercontent.com/snehmehta/49657051b2ecb730702af116c82e3cc4/raw/36f6b5d4cad3b6c04fa45f7116798677454c2123/config.json');
      final data = jsonDecode(response.data);

      parseLayout(data);
    } on Exception catch (error, _) {
      // errorTracker.captureError(error, stackTrace);
      setDefaultLayout();
    }

    AppState.showNavBar.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppState.showNavBar,
      builder: (context, showBar, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Billion Dollar App')),
          body: widget.child,
          bottomNavigationBar: !showBar
              ? null
              : BottomNavigationBar(
                  onTap: (index) => context.go(AppState.mapScreen[index]!),
                  items: AppState.navigationBarItems,
                  currentIndex: _calculateSelectedIndex(context),
                ),
        );
      },
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final GoRouter route = GoRouter.of(context);
    final String location = route.location;

    final index = AppState.mapScreen.keys.firstWhereOrNull(
      (element) => AppState.mapScreen[element] == location,
    );

    return index ?? 0;
  }
}

void parseLayout(data) {
  int counter = 0;

  final navItems = data['navigation'] as List;

  for (var element in navItems) {
    AppState.mapScreen[counter] = element['action']['location'];

    final item = BottomNavigationBarItem(
      icon: Icon(
          IconData(int.parse(element['icon']), fontFamily: 'MaterialIcons')),
      label: element['label'],
    );

    AppState.navigationBarItems.add(item);
    counter++;
  }
}

void setDefaultLayout() async {
  AppState.mapScreen[0] = '/home';
  AppState.mapScreen[1] = '/search';
  AppState.mapScreen[2] = '/search';

  AppState.navigationBarItems.addAll([
    const BottomNavigationBarItem(
      label: 'Home',
      icon: Icon(IconData(58136, fontFamily: 'MaterialIcons')),
    ),
    const BottomNavigationBarItem(
      label: 'Search',
      icon: Icon(IconData(58727, fontFamily: 'MaterialIcons')),
    ),
    const BottomNavigationBarItem(
      label: 'Account',
      icon: Icon(IconData(57410, fontFamily: 'MaterialIcons')),
    ),
  ]);
}
