import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/disciplina_boletim.dart';
import '../models/disciplina_boletim_list.dart';
import '../utils/app_routes.dart';

class DisciplinaBoletimItem extends StatelessWidget {
  final DisciplinaBoletim disciplinaBoletim;

  const DisciplinaBoletimItem(
    this.disciplinaBoletim, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(),
      title: Text(disciplinaBoletim.idUser),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.disciplinasBoletimForm,
                  arguments: disciplinaBoletim,
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
                    title: const Text('Excluir DisciplinaBoletim'),
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
                      await Provider.of<DisciplinaBoletimList>(
                        context,
                        listen: false,
                      ).removeDisciplinaBoletim(disciplinaBoletim);
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
