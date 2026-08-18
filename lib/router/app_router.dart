import 'package:cs_elective_2/pages/fruit_detail_page.dart';
import 'package:cs_elective_2/pages/fruit_list_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

/// Nested routes:
/// - `/`            → fruit list (parent)
/// - `/fruit/:name` → fruit detail (child of `/`)
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const FruitListPage(),
      routes: [
        GoRoute(
          path: 'fruit/:name',
          builder: (context, state) {
            final name = state.pathParameters['name']!;
            return FruitDetailPage(name: name);
          },
        ),
      ],
    ),
  ],
);
