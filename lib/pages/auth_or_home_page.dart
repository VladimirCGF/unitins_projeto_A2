import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitins_projeto/pages/unitins_apps_page.dart';

import '../models/auth.dart';
import 'auth_page.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return auth.isAuth ? UnitinsAppsPage() : AuthPage();
  }
}
