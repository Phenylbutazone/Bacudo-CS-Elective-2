import 'package:cs_elective_2/router/app_router.dart';
import 'package:cs_elective_2/state/theme_notifier.dart';
import 'package:cs_elective_2/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FreshFruitMarketApp());
}

class FreshFruitMarketApp extends StatelessWidget {
  const FreshFruitMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeNotifier,
      builder: (context, _) {
        return MaterialApp.router(
          title: 'Fresh Fruit Market',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeNotifier.mode,
          routerConfig: appRouter,
        );
      },
    );
  }
}
