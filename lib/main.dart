import 'package:cs_elective_2/router/app_router.dart';
import 'package:cs_elective_2/utils/platform_adaptive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (PlatformAdaptive.useCupertino) {
      return CupertinoApp.router(
        title: 'Responsive Dashboard',
        debugShowCheckedModeBanner: false,
        theme: const CupertinoThemeData(
          primaryColor: CupertinoColors.activeBlue,
          barBackgroundColor: CupertinoColors.darkBackgroundGray,
        ),
        routerConfig: appRouter,
      );
    }

    return MaterialApp.router(
      title: 'Responsive Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF37474F),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
