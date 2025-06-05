import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitins_projeto/models/auth.dart';
import 'package:unitins_projeto/models/disciplina_boletim.dart';
import 'package:unitins_projeto/models/user.dart';
import 'package:unitins_projeto/models/disciplina_boletim_list.dart';
import 'package:unitins_projeto/pages/rematricula_confirma_page.dart';

class RematriculaPage extends StatefulWidget {
  final User user;

  const RematriculaPage({Key? key, required this.user}) : super(key: key);

  @override
  State<RematriculaPage> createState() => _RematriculaPageState();
}

class _RematriculaPageState extends State<RematriculaPage> {
  final Set<DisciplinaBoletim> _selecionadas = {};
  List<DisciplinaBoletim> _disciplinasPendentes = [];
  List<DisciplinaBoletim> _disciplinasMatriculadas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDisciplinasPendentes();
    _carregarDisciplinasMatriculadas();
  }

  Future<void> _carregarDisciplinasPendentes() async {
    setState(() => _isLoading = true);

    try {
      final list = Provider.of<DisciplinaBoletimList>(context, listen: false);
      final disciplinas = await list.fetchDisciplinasPendentes(context);

      setState(() {
        _disciplinasPendentes = disciplinas;
      });
    } catch (e) {
      print('Erro ao carregar disciplinas: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _carregarDisciplinasMatriculadas() async {
    setState(() => _isLoading = true);

    try {
      final list = Provider.of<DisciplinaBoletimList>(context, listen: false);
      final disciplinas = await list.fetchDisciplinasMatriculadas(context);

      setState(() {
        _disciplinasMatriculadas = disciplinas;
      });

      print('📋 Disciplinas com status MT:');
      for (var d in disciplinas) {
        print('➡️ ID: ${d.idDisciplina}, Status: ${d.status}');
      }

      // Se houver disciplinas MT, redirecionar para página de confirmação
      if (disciplinas.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => RematriculaConfirmadaPage(
                user: widget.user,
                disciplinasMatriculadas: disciplinas,
              ),
            ),
          );
        });
      }
    } catch (e) {
      print('Erro ao carregar disciplinas: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }


  Future<void> _submitRematricula() async {
    if (_selecionadas.isEmpty) return;

    String token = Auth().token.toString();

    setState(() => _isLoading = true);

    try {
      final list = Provider.of<DisciplinaBoletimList>(context, listen: false);

      for (var d in _selecionadas) {
        if (d.idDisciplinaBoletim == null || d.idDisciplinaBoletim!.isEmpty) {
          print('⚠️ Ignorando disciplina sem idDisciplinaBoletim: ${d.nomeDisciplina}');
          continue;
        }

        await list.rematriculaDisciplinaBoletim(d);
        print('✅ Disciplina ${d.idDisciplinaBoletim} rematriculada como MT');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rematrícula confirmada com sucesso!')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      print('Erro ao rematricular: $e');
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Erro'),
          content: Text('Erro ao confirmar rematrícula: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rematrícula por Boletim')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _disciplinasPendentes.isEmpty
          ? const Center(child: Text('Nenhuma disciplina pendente.'))
          : Column(
        children: [
          Expanded(
            child: ListView(
              children: _disciplinasPendentes.map((disc) {
                return CheckboxListTile(
                  title: Text(disc.nomeDisciplina),
                  subtitle: Text('Status atual: ${disc.status}'),
                  value: _selecionadas.contains(disc),
                  onChanged: (bool? selected) {
                    setState(() {
                      if (selected == true) {
                        _selecionadas.add(disc);
                      } else {
                        _selecionadas.remove(disc);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text('Confirmar Rematrícula'),
              onPressed:
              _selecionadas.isEmpty ? null : _submitRematricula,
            ),
          ),
        ],
      ),
    );
  }
}
