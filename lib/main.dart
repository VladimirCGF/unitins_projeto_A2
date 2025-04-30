import 'package:flutter/material.dart';
import 'pages/unitins_apps_page.dart';

void main() => runApp(UnitinsLoginApp());

class UnitinsLoginApp extends StatelessWidget {
  const UnitinsLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Center(child: UnitinsAppsPage()),
      debugShowCheckedModeBanner: false,
    );
  }
}
