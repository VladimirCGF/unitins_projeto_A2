import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitins_projeto/models/user_list.dart';

import '../models/auth.dart';
import '../models/disciplina_boletim_list.dart';

class MatriculaPage extends StatefulWidget {
  const MatriculaPage({super.key});

  @override
  State<MatriculaPage> createState() => _MatriculaPageState();
}

class _MatriculaPageState extends State<MatriculaPage> {
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
              final auth = Provider.of<Auth>(context, listen: false);
              final token = auth.token;
              final userId = auth.userId;

              print('TOKEN: $token');
              print('USER ID: $userId');

              final user = await Provider.of<UserList>(
                context,
                listen: false,
              ).buscarUsuarioPorIdUser();

              if (user == null) {
                print('Usuário não encontrado.');
                throw Exception('Usuário não encontrado.');
              }

              // Print dos dados do usuário
              print('ID Usuário: ${user.idUser}');
              print('Nome: ${user.nome}');
              print('Email: ${user.email}');
              print('ID Curso: ${user.idCurso}');

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
              print('Erro ao realizar matrícula: $e');
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
