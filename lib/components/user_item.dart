import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitins_projeto/models/user_list.dart';

import '../models/user.dart';
import '../utils/app_routes.dart';

class UserItem extends StatelessWidget {
  final User user;

  const UserItem(
    this.user, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(),
      title: Text(user.nome),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.userForm,
                  arguments: user,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Theme.of(context).colorScheme.error,
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Excluir User'),
                    content: const Text('Tem certeza?'),
                    actions: [
                      TextButton(
                        child: const Text('Não'),
                        onPressed: () => Navigator.of(ctx).pop(false),
                      ),
                      TextButton(
                        child: const Text('Sim'),
                        onPressed: () => Navigator.of(ctx).pop(true),
                      ),
                    ],
                  ),
                ).then((value) async {
                  if (value ?? false) {
                    try {
                      await Provider.of<UserList>(
                        context,
                        listen: false,
                      ).removeUser(user);
                    } catch (error) {
                      msg.showSnackBar(
                        SnackBar(content: Text(error.toString())),
                      );
                    }
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
