import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/disciplina_boletim.dart';
import '../models/disciplina_boletim_list.dart';
import '../models/user.dart';

class RematriculaConfirmadaPage extends StatelessWidget {
  final User user;
  final List<DisciplinaBoletim> disciplinasMatriculadas;

  const RematriculaConfirmadaPage({
    super.key,
    required this.user,
    required this.disciplinasMatriculadas,
  });

  @override
  Widget build(BuildContext context) {
    final disciplinasMT = disciplinasMatriculadas
        .where((d) => d.status == 'MT')
        .toList();

    final User user;
    final nomeUsuario = 'Aluno';
    final semestre = '2025/01';
    final curso = 'SISTEMAS DE INFORMAÇÃO';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rematrícula - Solicitação Confirmada'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Breadcrumbs(),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFDDF2FD),
                borderRadius: BorderRadius.circular(8),
              ),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    const TextSpan(text: 'Prezado(a) aluno(a) '),
                    TextSpan(
                      text: nomeUsuario,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: ',\n\nSua rematrícula no semestre '),
                    TextSpan(
                      text: semestre,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: ' está confirmada para o curso '),
                    TextSpan(
                      text: curso,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: '.\n\n'),
                    const TextSpan(
                      text:
                      'Clique aqui para imprimir seu comprovante de matrícula.\nClique aqui para imprimir o Termo da Rematrícula Online.',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (disciplinasMT.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Pendência(s)! Você possui pendência de documento(s), favor procurar a secretaria.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Disciplinas com status "MT":',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ...disciplinasMT.map((d) => ListTile(
                leading: const Icon(Icons.book),
                title: Text(d.nomeDisciplina ?? 'Sem nome'),
                subtitle: Text('Status: ${d.status}'),
              )),
            ]
          ],
        ),
      ),
    );
  }
}

class Breadcrumbs extends StatelessWidget {
  const Breadcrumbs({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: const [
        Text('Apresentação /', style: TextStyle(color: Colors.grey)),
        Text('Atualizar Dados Pessoais /', style: TextStyle(color: Colors.grey)),
        Text('Quadro de Horário /', style: TextStyle(color: Colors.grey)),
        Text('Quadro de Horário'),
      ],
    );
  }
}
