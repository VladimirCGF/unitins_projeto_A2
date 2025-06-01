import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/boletim_list.dart';
import '../models/disciplina.dart';
import '../models/disciplina_list.dart';

class RematriculaPage extends StatefulWidget {
  const RematriculaPage({super.key});

  @override
  State<RematriculaPage> createState() => _RematriculaPageState();
}

class _RematriculaPageState extends State<RematriculaPage> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  bool _isLoading = false;
  bool _isInit = true;
  final Set<Disciplina> _cursosSelecionados = {};
  String _periodoLetivo = '';

  Future<void> _refreshCursos(BuildContext context) async {
    await Provider.of<DisciplinaList>(context, listen: false).loadDisciplinas();
  }

  @override
  void initState() {
    super.initState();
    _periodoLetivo = gerarPeriodoLetivoAtual();
  }

  String gerarPeriodoLetivoAtual() {
    final now = DateTime.now();
    final ano = now.year;
    final semestre = now.month < 7 ? '01' : '02';
    return '$ano/$semestre';
  }



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() => _isLoading = true);
      _refreshCursos(context).then((_) {
        setState(() => _isLoading = false);
      });

      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null && arg is String) {
        _periodoLetivo = arg;
      }

      _isInit = false;
    }
  }

  Future<void> _submitForm() async {
    print('SubmitForm chamado');
    final formValid = _formKey.currentState?.validate() ?? false;
    print('Form válido? $formValid');

    if (!formValid) return;

// Salva os campos no _formData
    _formKey.currentState!.save();

    print('Dados do boletim: $_formData');


    print('Dados do boletim: $_formData');
    _formData['cursos'] =
        _cursosSelecionados.map((curso) => curso.toMap()).toList();
    _formData['periodoLetivo'] = _periodoLetivo;
    print('Dados do boletim: $_formData');

    setState(() => _isLoading = true);

    try {
      print('Tentando salvar boletim...');
      await Provider.of<BoletimList>(
        context,
        listen: false,
      ).saveBoletim(_formData);
      print('Boletim salvo com sucesso');

      Navigator.of(context).pop();
    } catch (error) {
      print('Erro ao salvar rematrícula: $error');
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro!'),
          content: const Text('Ocorreu um erro ao salvar o período.'),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Map<dynamic, List<Disciplina>> _agruparCursosPorPeriodo(List<Disciplina> cursos) {
    final Map<dynamic, List<Disciplina>> agrupados = {};
    for (var curso in cursos) {
      final key = curso.periodo == 0 ? 'Optativas' : curso.periodo;
      agrupados.putIfAbsent(key, () => []).add(curso);
    }

    final sortedKeys = agrupados.keys.toList()
      ..sort((a, b) {
        if (a == 'Optativas') return 1;
        if (b == 'Optativas') return -1;
        return a.compareTo(b);
      });

    return {for (var key in sortedKeys) key: agrupados[key]!};
  }

  @override
  Widget build(BuildContext context) {
    final cursos = Provider.of<DisciplinaList>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: Image.network(
          'https://www.unitins.br/uniPerfil/Logomarca/Imagem/09997c779523a61bd01bb69b0a789242',
          height: 80,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                  child: Text(
                    'Rematrícula',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0949B1),
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => _refreshCursos(context),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: _buildCursosAgrupados(cursos),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: _cursosSelecionados.isEmpty ? null : _submitForm,
                    icon: const Icon(Icons.check),
                    label: const Text('Confirmar Rematrícula'),
                  ),
                ),
              ],
            ),
    );
  }

  List<Widget> _buildCursosAgrupados(List<Disciplina> cursos) {
    final cursosPorPeriodo = _agruparCursosPorPeriodo(cursos);
    final List<Widget> widgets = [];

    cursosPorPeriodo.forEach((periodo, lista) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            periodo == 'Optativas' ? 'Optativas' : '$periodoº Período',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      );
      for (var curso in lista) {
        widgets.add(CheckboxListTile(
          title: Text('${curso.nome} (${curso.codigo})'),
          subtitle: Text('Carga Horária: ${curso.ch}h'),
          value: _cursosSelecionados.contains(curso),
          onChanged: (bool? selected) {
            setState(() {
              if (selected == true) {
                _cursosSelecionados.add(curso);
              } else {
                _cursosSelecionados.remove(curso);
              }
            });
          },
        ));
      }
    });

    return widgets;
  }
}
