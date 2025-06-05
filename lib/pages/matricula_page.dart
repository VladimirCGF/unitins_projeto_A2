import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitins_projeto/pages/auth_page.dart';
import 'package:unitins_projeto/pages/dashboard_page.dart';

import '../models/auth.dart';
import '../models/disciplina_boletim_list.dart';
import '../models/user_list.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard(),
              ),
            );
          },
        ),
        backgroundColor: const Color(0xFF094AB2), // Azul escuro para combinar com tema
        centerTitle: true,
        elevation: 2,
      ),
      body: Center(
        child: SizedBox(
          width: 200, // Largura fixa para o botão
          height: 50, // Altura do botão
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF094AB2), // Cor do botão azul escuro
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Bordas arredondadas
              ),
              elevation: 5,
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
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
                    backgroundColor: Color(0xFF094AB2),
                  ),
                );
              } catch (e) {
                print('Erro ao realizar matrícula: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro ao realizar matrícula: ${e.toString()}'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: const Text('MATRICULAR'),
          ),
        ),
      ),
    );
  }
}
