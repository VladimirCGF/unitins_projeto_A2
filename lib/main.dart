import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() => runApp(UnitinsLoginApp());

class UnitinsLoginApp extends StatelessWidget {
  const UnitinsLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portal do Aluno',
      home: Center(child: LoginPage()),
      debugShowCheckedModeBanner: false,
    );
  }
}
