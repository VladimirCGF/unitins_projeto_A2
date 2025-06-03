import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitins_projeto/components/custom_footer.dart';

import '../components/custom_button.dart';
import '../models/disciplina.dart';
import '../models/disciplina_list.dart';

class GradeCurricularPage extends StatefulWidget {
  const GradeCurricularPage({super.key});

  @override
  State<GradeCurricularPage> createState() => _GradeCurricularPageState();
}

class _GradeCurricularPageState extends State<GradeCurricularPage> {
  bool _isLoading = false;
  bool _isInit = true;

  //Pegar as disciplinas que foi associado ao aluno
  Future<void> _refreshDisciplinas(BuildContext context) async {
    await Provider.of<DisciplinaList>(context, listen: false).loadDisciplinas();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() => _isLoading = true);
      _refreshDisciplinas(context).then((_) {
        setState(() => _isLoading = false);
      });
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    //Buscar disciplinas que foi associada ao user.idCurso>curso.disciplinas
    final disciplinas = Provider.of<DisciplinaList>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Image.network(
          'https://www.unitins.br/uniPerfil/Logomarca/Imagem/09997c779523a61bd01bb69b0a789242',
          height: 80,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Text(
              'Matriz Curricular - ',
              //Aqui pega o nome do curso pelo user.idCurso
              // 'SISTEMAS DE INFORMAÇÃO',
              style: TextStyle(
                fontSize: 40,
                color: Color(0xFF656565),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : disciplinas.isEmpty
                    ? const Center(child: Text('Nenhum curso encontrado'))
                    : _buildCursosPorPeriodo(disciplinas),
          ),
        ],
      ),
    );
  }

  Widget _buildCursosPorPeriodo(List<Disciplina> cursos) {
    final Map<String, List<Disciplina>> cursosPorPeriodo = {};

    for (var curso in cursos) {
      cursosPorPeriodo.putIfAbsent(curso.periodo, () => []).add(curso);
    }
    final periodosNumericos = cursosPorPeriodo.keys
        .where((k) => int.tryParse(k) != null)
        .map((k) => int.parse(k))
        .toList()
      ..sort();

    final outrosPeriodos =
        cursosPorPeriodo.keys.where((k) => int.tryParse(k) == null).toList();

    final periodosOrdenados = [
      ...periodosNumericos.map((e) => e.toString()),
      ...outrosPeriodos,
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: [
                for (var periodo in periodosOrdenados)
                  _buildPeriodoComCH(
                    periodo: int.tryParse(periodo) != null
                        ? '$periodoº Período'
                        : periodo, // se não for número, exibe direto
                    cursos: cursosPorPeriodo[periodo]!,
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        text: 'Voltar',
                        color: Colors.white,
                        textColor: Colors.black,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 8),
                      CustomButton(
                        text: 'Imprimir',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const CustomFooter(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPeriodoComCH({
    required String periodo,
    required List<Disciplina> cursos,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              periodo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text('Código',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text('Disciplina',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: 40,
                  child:
                      Text('CH', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const Divider(height: 20),
            ...cursos.map(
              (curso) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        curso.codigo,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(curso.nome)),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 40,
                      child: Text('${curso.ch}h'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
