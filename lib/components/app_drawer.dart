import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth.dart';
import '../utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Menu'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.authOrHome,
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Gerenciar Periodos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.periodos,
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Gerenciar Disciplinas'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.disciplinas,
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Gerenciar Cursos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.cursos,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Gerenciar Alunos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.users,
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sair'),
            onTap: () {
              Provider.of<Auth>(
                context,
                listen: false,
              ).logout();
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.authOrHome,
              );
            },
          )
        ],
      ),
    );
  }
}
