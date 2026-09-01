import 'package:cs_elective_2/router/app_router.dart';
import 'package:cs_elective_2/state/theme_notifier.dart';
import 'package:cs_elective_2/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const KeyboardStoreApp());
}

class KeyboardStoreApp extends StatelessWidget {
  const KeyboardStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeNotifier,
      builder: (context, _) {
        return MaterialApp.router(
          title: 'Keyboard Store',
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
