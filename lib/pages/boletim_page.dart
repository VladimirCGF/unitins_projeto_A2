import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/boletim_list.dart'; // ajuste o caminho
import '../components/custom_button.dart';

class BoletimPage extends StatefulWidget {
  const BoletimPage({Key? key}) : super(key: key);

  @override
  State<BoletimPage> createState() => _BoletimPageState();
}

class _BoletimPageState extends State<BoletimPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadBoletins();
  }

  Future<void> _loadBoletins() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<BoletimList>(context, listen: false).loadBoletins();
    } catch (error) {
      // trate o erro se quiser
      print('Erro ao carregar boletins: $error');
    }
    setState(() {
      _isLoading = false;
    });
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
            : Consumer<BoletimList>(
          builder: (context, boletimList, child) {
            final boletins = boletimList.items;

            if (boletins.isEmpty) {
              return const Center(child: Text('Nenhum boletim encontrado.'));
            }

            List<Map<String, String>> disciplinas = [];

            for (var boletim in boletins) {
              for (var curso in boletim.cursos) {
                disciplinas.add({
                  'periodo': boletim.periodoLetivo,
                  'codigo': curso.codigo.toString(),
                  'disciplina': curso.nome,
                  'faltas no semestre': boletim.faltasNoSemestre.toString(),
                  'a1': boletim.a1.toString(),
                  'a2': boletim.a2.toString(),
                  'exame final': boletim.exameFinal.toString(),
                  'media semestral': boletim.mediaSemestral.toString(),
                  'media final': boletim.mediaFinal.toString(),
                  'situacao': boletim.status,
                });
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Boletim Acadêmico -',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Período Letivo')),
                        DataColumn(label: Text('Código')),
                        DataColumn(label: Text('Disciplina')),
                        DataColumn(label: Text('Faltas no Semestre')),
                        DataColumn(label: Text('A1')),
                        DataColumn(label: Text('A2')),
                        DataColumn(label: Text('Exame Final')),
                        DataColumn(label: Text('Média Semestral')),
                        DataColumn(label: Text('Média Final')),
                        DataColumn(label: Text('Situação')),
                      ],
                      rows: disciplinas
                          .map(
                            (disc) => DataRow(
                          cells: [
                            DataCell(Text(disc['periodo']!)),
                            DataCell(Text(disc['codigo']!)),
                            DataCell(Text(disc['disciplina']!)),
                            DataCell(Text(disc['faltas no semestre']!)),
                            DataCell(Text(disc['a1']!)),
                            DataCell(Text(disc['a2']!)),
                            DataCell(Text(disc['exame final']!)),
                            DataCell(Text(disc['media semestral']!)),
                            DataCell(Text(disc['media final']!)),
                            DataCell(Text(disc['situacao']!)),
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
            );
          },
        ),
      ),
    );
  }
}
