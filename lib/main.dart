import 'package:cs_elective_2/router/app_router.dart';
import 'package:cs_elective_2/state/theme_notifier.dart';
import 'package:cs_elective_2/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // ProviderScope stores the state of every Riverpod provider in the app.
  runApp(const ProviderScope(child: KeyboardStoreApp()));
}

class KeyboardStoreApp extends StatelessWidget {
  const KeyboardStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeNotifier,
      builder: (context, _) {
        return MaterialApp.router(
          title: '⌈ Wired Keyboards ⌋',
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
