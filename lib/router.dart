import 'package:dynamic_route/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AppScaffold(child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) {
            return const Center(child: Text('Home'));
          },
        ),
        GoRoute(
          path: '/search',
          builder: (BuildContext context, GoRouterState state) {
            return const Center(child: Text('Search'));
          },
        ),
        GoRoute(
          path: '/account',
          builder: (BuildContext context, GoRouterState state) {
            return const Center(child: Text('Account'));
          },
        ),
      ],
    ),
  ],
);
