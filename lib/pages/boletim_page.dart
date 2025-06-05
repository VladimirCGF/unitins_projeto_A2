import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/custom_button.dart';
import '../models/disciplina_boletim.dart';
import '../models/disciplina_boletim_list.dart';

class BoletimPage extends StatefulWidget {
  const BoletimPage({Key? key}) : super(key: key);

  @override
  State<BoletimPage> createState() => _BoletimPageState();
}

class _BoletimPageState extends State<BoletimPage> {
  final Set<DisciplinaBoletim> _selecionadas = {};
  List<DisciplinaBoletim> _disciplinasMatriculadas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDisciplinasMatriculadas();
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
    } catch (e) {
      print('Erro ao carregar disciplinas: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: Row(
          children: [
            Image.network(
              'https://www.unitins.br/uniPerfil/Logomarca/Imagem/09997c779523a61bd01bb69b0a789242',
              height: 30,
            ),
            const SizedBox(width: 12),
            const Text('UNITINS'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _disciplinasMatriculadas.isEmpty
                ? const Center(child: Text('Nenhum boletim encontrado.'))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Boletim Acadêmico -',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'SISTEMAS DE INFORMAÇÃO',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Disciplinas do Semestre Letivo',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 20,
                          color: Color(0xFF094AB2),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Disciplina')),
                              DataColumn(label: Text('Faltas no Semestre')),
                              DataColumn(label: Text('A1')),
                              DataColumn(label: Text('A2')),
                              DataColumn(label: Text('Exame Final')),
                              DataColumn(label: Text('Média Semestral')),
                              DataColumn(label: Text('Média Final')),
                              DataColumn(label: Text('Situação')),
                            ],
                            rows: _disciplinasMatriculadas
                                .map(
                                  (disc) => DataRow(
                                    cells: [
                                      DataCell(
                                          Text(disc.nomeDisciplina ?? '-')),
                                      DataCell(Text(
                                          disc.faltasNoSemestre?.toString() ??
                                              '-')),
                                      DataCell(Text(
                                          disc.a1?.toStringAsFixed(1) ?? '-')),
                                      DataCell(Text(
                                          disc.a2?.toStringAsFixed(1) ?? '-')),
                                      DataCell(Text(
                                          disc.exameFinal?.toStringAsFixed(1) ??
                                              '-')),
                                      DataCell(Text(disc.mediaSemestral
                                              ?.toStringAsFixed(1) ??
                                          '-')),
                                      DataCell(Text(
                                          disc.mediaFinal?.toStringAsFixed(1) ??
                                              '-')),
                                      DataCell(Text(disc.status ?? '-')),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '* Situação passiva de alteração no decorrer do período letivo.\n'
                        '- Documento sem valor legal.\n'
                        '+ Clique para ver os detalhes da nota.',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                      const SizedBox(height: 12),
                      Row(
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
                          const SizedBox(width: 12),
                          CustomButton(
                            text: 'Imprimir',
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
      ),
    );
  }
}
