import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/curso.dart';
import '../models/curso_list.dart';

class GradeCurricularPage extends StatefulWidget {
  const GradeCurricularPage({super.key});

  @override
  State<GradeCurricularPage> createState() => _GradeCurricularPageState();
}

class _GradeCurricularPageState extends State<GradeCurricularPage> {
  bool _isLoading = false;
  bool _isInit = true;

  Future<void> _refreshCursos(BuildContext context) async {
    await Provider.of<CursoList>(context, listen: false).loadCursos();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() => _isLoading = true);
      _refreshCursos(context).then((_) {
        setState(() => _isLoading = false);
      });
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cursos = Provider.of<CursoList>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matriz Curricular'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : cursos.isEmpty
              ? const Center(child: Text('Nenhum curso encontrado'))
              : _buildCursosPorPeriodo(cursos),
    );
  }

  Widget _buildCursosPorPeriodo(List<Curso> cursos) {
    final Map<String, List<Curso>> cursosPorPeriodo = {};

    for (var curso in cursos) {
      cursosPorPeriodo.putIfAbsent(curso.periodo, () => []).add(curso);
    }

    final periodosOrdenados = cursosPorPeriodo.keys.toList()
      ..sort((a, b) => int.tryParse(a)?.compareTo(int.tryParse(b) as num) ?? 0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var periodo in periodosOrdenados)
            _buildPeriodoComCH(
              periodo: '$periodoº Período',
              cursos: cursosPorPeriodo[periodo]!,
            ),
          const SizedBox(height: 20),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildPeriodoComCH({
    required String periodo,
    required List<Curso> cursos,
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
            ...cursos.map((curso) => Padding(
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
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return const Center(
      child: Text(
        'Unitins - Sistemas de Informação',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }
}
