import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitins_projeto/models/curso_list.dart';

import '../components/custom_footer.dart';
import '../models/disciplina_boletim.dart';
import '../models/user.dart';

class RematriculaConfirmadaPage extends StatefulWidget {
  final User user;
  final List<DisciplinaBoletim> disciplinasMatriculadas;

  const RematriculaConfirmadaPage({
    super.key,
    required this.disciplinasMatriculadas,
    required this.user,
  });

  @override
  State<RematriculaConfirmadaPage> createState() =>
      _RematriculaConfirmadaPageState();
}

class _RematriculaConfirmadaPageState extends State<RematriculaConfirmadaPage> {
  @override
  void initState() {
    super.initState();
    _loadCursos();
  }

  Future<void> _loadCursos() async {
    final cursoList = Provider.of<CursoList>(context, listen: false);
    await cursoList.loadCurso();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cursoList = Provider.of<CursoList>(context);
    final curso = cursoList.findByCursoForIDCurso(widget.user.idCurso);

    if (curso == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final nomeUsuario = widget.user.nome;
    final semestre = '2025/01';
    final nomeCurso = curso != null ? curso.nome : 'Curso não encontrado';

    return Scaffold(
      appBar: AppBar(
        title: Image.network(
          'https://www.unitins.br/uniPerfil/Logomarca/Imagem/09997c779523a61bd01bb69b0a789242',
          height: 40,
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black54),
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const Text(
                    'Rematrícula - Solicitação Confirmada',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 30,
                      color: Color(0xFF094AB2),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
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
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                        children: [
                          const TextSpan(text: 'Prezado(a) aluno(a) '),
                          TextSpan(
                            text: nomeUsuario,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const TextSpan(
                              text: ',\n\nSua rematrícula no semestre '),
                          TextSpan(
                            text: semestre,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(
                              text: ' está confirmada para o curso '),
                          TextSpan(
                            text: nomeCurso,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const TextSpan(text: '.\n\n'),
                          const TextSpan(
                            text:
                                'Clique aqui para imprimir seu comprovante de matrícula.\nClique aqui para imprimir o Termo da Rematrícula Online.',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const CustomFooter(),
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
        Text('Apresentação /', style: TextStyle(color: Colors.black45)),
        Text('Atualizar Dados Pessoais /',
            style: TextStyle(color: Colors.black45)),
        Text('Quadro de Horário /', style: TextStyle(color: Colors.black45)),
      ],
    );
  }
}
