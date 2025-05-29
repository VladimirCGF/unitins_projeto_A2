import 'package:flutter/material.dart';
import 'package:unitins_projeto/components/custom_button.dart';
import 'package:unitins_projeto/pages/boletim_academico_app.dart';

class CourseSelectionScreen extends StatefulWidget {
  const CourseSelectionScreen({super.key});

  @override
  State<CourseSelectionScreen> createState() => _CourseSelectionScreenState();
}

class _CourseSelectionScreenState extends State<CourseSelectionScreen> {
  String? _selectedCourse;

  final List<String> _courses = [
    'SISTEMAS DE INFORMAÇÃO/CÂMPUS PALMAS (Transferência de Grade)',
    'SISTEMAS DE INFORMAÇÃO/CÂMPUS PALMAS (Matriculado)',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCourse = _courses[0];
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
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Curso',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                color: Color(0xFF094AB2),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Selecione o Curso',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                color: Color(0xFF094AB2),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ..._courses.map((course) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: RadioListTile<String>(
                  title: Text(
                    course,
                    style: const TextStyle(fontSize: 14),
                    softWrap: true,
                  ),
                  value: course,
                  groupValue: _selectedCourse,
                  onChanged: (value) {
                    setState(() {
                      _selectedCourse = value;
                    });
                  },
                ),
              );
            }),
            const SizedBox(height: 24),
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
                const SizedBox(width: 8),
                CustomButton(
                  text: 'Próximo',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const BoletimAcademicoApp(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
