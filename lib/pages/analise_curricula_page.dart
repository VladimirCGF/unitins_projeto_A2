import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitins_projeto/components/custom_button.dart';

import '../components/custom_footer.dart';
import '../models/curso_list.dart';
import '../models/disciplina_boletim.dart';
import '../models/disciplina_boletim_list.dart';
import '../models/user.dart';
import '../models/user_list.dart';

class AnaliseCurriculaPage extends StatefulWidget {
  final User user;

  const AnaliseCurriculaPage({super.key, required this.user});

  @override
  State<AnaliseCurriculaPage> createState() => _AnaliseCurriculaPage();
}

class _AnaliseCurriculaPage extends State<AnaliseCurriculaPage> {
  List<DisciplinaBoletim> _disciplinasAprovadas = [];
  List<DisciplinaBoletim> _disciplinasPendentes = [];
  bool _isLoading = true;
  double _porcentagem = 0.0;

  static const int disciplinasObrigatorias = 59;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadCursos();
  }

  Future<void> _loadUser() async {
    final userList = Provider.of<UserList>(context, listen: false);
    await userList.loadUser();
    setState(() {});
  }

  Future<void> _loadCursos() async {
    final cursoList = Provider.of<CursoList>(context, listen: false);
    await cursoList.loadCurso();
    setState(() {});
  }

  Future<void> _analisarCurriculo() async {
    setState(() => _isLoading = true);
    try {
      final list = Provider.of<DisciplinaBoletimList>(context, listen: false);

      // Buscar disciplinas aprovadas e pendentes
      final disciplinasAprovadas =
          await list.fetchDisciplinasAprovadas(context);
      final disciplinasPendentes =
          await list.fetchDisciplinasPendentes(context);

      int totalAprovadas = disciplinasAprovadas.length;

      double percentual = 0.0;
      if (disciplinasObrigatorias > 0) {
        percentual = totalAprovadas / disciplinasObrigatorias;
      }

      setState(() {
        _porcentagem = percentual;
        _disciplinasAprovadas = disciplinasAprovadas;
        _disciplinasPendentes = disciplinasPendentes;
      });

      // _mostrarDialogoConclusao();
    } catch (e) {
      _mostrarDialogoErro(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // void _mostrarDialogoConclusao() {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: const Text('Análise Completa'),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Text('${(_porcentagem * 100).toStringAsFixed(1)}% concluído'),
  //           const SizedBox(height: 20),
  //           LinearProgressIndicator(
  //             value: _porcentagem,
  //             minHeight: 10,
  //             backgroundColor: Colors.grey[300],
  //             color: Colors.blue,
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           child: const Text('Fechar'),
  //           onPressed: () {
  //             Navigator.of(ctx).pop();
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _mostrarDialogoErro(String mensagem) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Erro'),
        content: Text('Erro ao calcular: $mensagem'),
        actions: [
          TextButton(
            child: const Text('Fechar'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network(
          'https://www.unitins.br/uniPerfil/Logomarca/Imagem/09997c779523a61bd01bb69b0a789242',
          height: 40,
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black54),
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const Text(
                    'Analise Curricular',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 26,
                      color: Color(0xFF094AB2),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomButton(
                    onPressed: _analisarCurriculo,
                    text: 'Analisar',
                  ),
                  const SizedBox(height: 20),
                  if (_porcentagem > 0)
                    Column(
                      children: [
                        if (_disciplinasAprovadas.isNotEmpty || _disciplinasPendentes.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              const Text(
                                'Disciplinas Aprovadas:',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              ..._disciplinasAprovadas.map((disciplina) => ListTile(
                                title: Text(disciplina.nomeDisciplina),
                                subtitle: Text('Nota: ${disciplina.mediaFinal?.toStringAsFixed(1)}'),
                                trailing: const Icon(Icons.check_circle, color: Colors.green),
                              )),
                              const SizedBox(height: 20),
                              const Text(
                                'Disciplinas Pendentes:',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              ..._disciplinasPendentes.map((disciplina) => ListTile(
                                title: Text(disciplina.nomeDisciplina),
                                subtitle: Text('Nota: ${disciplina.mediaFinal?.toStringAsFixed(1)}'),
                                trailing: const Icon(Icons.warning, color: Colors.red),
                              )),
                            ],
                          ),
                        Text(
                            '${(_porcentagem * 100).toStringAsFixed(1)}% concluído'),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: _porcentagem,
                          minHeight: 10,
                          backgroundColor: Colors.grey[300],
                          color: Colors.blue,
                        ),
                      ],
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
