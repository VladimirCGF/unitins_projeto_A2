import 'package:flutter/material.dart';

import '../components/custom_button.dart';

class BoletimAcademicoApp extends StatefulWidget {
  const BoletimAcademicoApp({Key? key}) : super(key: key);

  @override
  State<BoletimAcademicoApp> createState() => _BoletimAcademicoAppState();
}

class _BoletimAcademicoAppState extends State<BoletimAcademicoApp> {
  final List<Map<String, String>> disciplinas = const [
    {
      'periodo': '2025/01',
      'codigo': '011001147',
      'disciplina': 'BANCO DE DADOS II',
      'faltas no semestre': '0',
      'a1': '7',
      'a2': '7',
      'exame final': '',
      'media semestral': '',
      'media final': '',
      'situacao': 'Matriculado',
    },
    {
      'periodo': '2025/01',
      'codigo': '011001167',
      'disciplina': 'ESTATÍSTICA COMPUTACIONAL',
      'faltas no semestre': '0',
      'a1': '7',
      'a2': '7',
      'exame final': '',
      'media semestral': '',
      'media final': '',
      'situacao': 'Matriculado',
    },
    {
      'periodo': '2025/01',
      'codigo': '011001157',
      'disciplina': 'GESTÃO ESTRATÉGICA DA INFORMAÇÃO',
      'faltas no semestre': '0',
      'a1': '7',
      'a2': '7',
      'exame final': '',
      'media semestral': '',
      'media final': '',
      'situacao': 'Matriculado',
    },
    {
      'periodo': '2025/01',
      'codigo': '011001164',
      'disciplina': 'INTERFACE HUMANO-COMPUTADOR',
      'faltas no semestre': '0',
      'a1': '7',
      'a2': '7',
      'exame final': '',
      'media semestral': '',
      'media final': '',
      'situacao': 'Matriculado',
    },
    {
      'periodo': '2025/01',
      'codigo': '011001158',
      'disciplina': 'OTIMIZAÇÃO PARA SISTEMAS',
      'faltas no semestre': '0',
      'a1': '7',
      'a2': '7',
      'exame final': '',
      'media semestral': '',
      'media final': '',
      'situacao': 'Matriculado',
    },
    {
      'periodo': '2025/01',
      'codigo': '011001170',
      'disciplina': 'PROGRAMAÇÃO PARA DISPOSITIVOS MÓVEIS',
      'faltas no semestre': '0',
      'a1': '7',
      'a2': '7',
      'exame final': '',
      'media semestral': '',
      'media final': '',
      'situacao': 'Matriculado',
    },
  ];

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
        child: Column(
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
            Container(
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
                    DataColumn(label: Text('Média Semestral	')),
                    DataColumn(label: Text('Média Final	')),
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
            Text(
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
