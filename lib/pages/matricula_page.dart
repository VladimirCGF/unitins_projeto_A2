import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitins_projeto/data/store.dart';
import 'package:unitins_projeto/models/user_list.dart';

import '../models/auth.dart';
import '../models/disciplina_boletim_list.dart';

class MatriculaPage extends StatelessWidget {
  const MatriculaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matrícula'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final userId = auth.userId;
              final token =  auth.token;

              final user = await Provider.of<UserList>(
                context,
                listen: false,
              ).buscarUsuarioPorIdUser(userId!, token!);

              if (user == null) {
                throw Exception('Usuário não encontrado.');
              }

              await Provider.of<DisciplinaBoletimList>(
                context,
                listen: false,
              ).registrarDisciplinasDoCursoNoBoletim(user.idCurso);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Matrícula realizada com sucesso!'),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Erro ao realizar matrícula: ${e.toString()}'),
                ),
              );
            }
          },
          child: const Text('MATRICULAR'),
        ),
      ),
    );
  }
}
