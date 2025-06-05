import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/custom_footer.dart';
import '../models/curso_list.dart';
import '../models/disciplina_boletim.dart';
import '../models/disciplina_boletim_list.dart';
import '../models/user.dart';
import '../models/user_list.dart';

class SituacaoAcademicaPage extends StatefulWidget {
  final User user;

  const SituacaoAcademicaPage({
    super.key,
    required this.user,
  });

  @override
  State<SituacaoAcademicaPage> createState() => _SituacaoAcademicaPageState();
}

class _SituacaoAcademicaPageState extends State<SituacaoAcademicaPage> {
  List<DisciplinaBoletim> _disciplinasMatriculadas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadCursos();
    _carregarDisciplinasMatriculadas();
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

  Future<void> _carregarDisciplinasMatriculadas() async {
    setState(() => _isLoading = true);
    try {
      final list = Provider.of<DisciplinaBoletimList>(context, listen: false);
      final disciplinas = await list.fetchDisciplinasMatriculadas(context);
      setState(() {
        _disciplinasMatriculadas = disciplinas;
      });
    } catch (e) {
      print('Erro ao carregar disciplinas: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userList = Provider.of<UserList>(context);
    final user = userList.findByUserForID(widget.user.idUser);
    final cursoList = Provider.of<CursoList>(context);
    final curso = cursoList.findByCursoForIDCurso(widget.user.idCurso);

    if (curso == null || user == null || _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final situacao = _disciplinasMatriculadas.isNotEmpty ? 'Matriculado' : 'Não matriculado';

    final documentos = [
      {'nome': 'Foto (Obrigatório)', 'status': true},
      {'nome': 'Carteira de Identidade/RG (Obrigatório)', 'status': true},
      {'nome': 'Certidão de Nascimento/Casamento (Obrigatório)', 'status': true},
      {'nome': 'Histórico Escolar - Ensino Médio (Obrigatório)', 'status': true},
      {'nome': 'Certificado Militar/Reservista', 'status': true},
      {'nome': 'CPF (CIC) (Obrigatório)', 'status': true},
      {'nome': 'Diploma/Certificado Registrado (Obrigatório)', 'status': true},
      {'nome': 'Comprovante de Vacina', 'status': true},
      {'nome': 'Título de Eleitor (Obrigatório)', 'status': true},
      {'nome': 'Comprovante de Votação (Obrigatório)', 'status': true},
    ];

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
                    'Situação Acadêmica',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 26,
                      color: Color(0xFF094AB2),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoField('Nº de Matrícula:', widget.user.matricula),
                  const SizedBox(height: 8),
                  _buildInfoField('Nome:', widget.user.nome),
                  const SizedBox(height: 8),
                  _buildInfoField('Curso:', curso.nome),
                  const SizedBox(height: 8),
                  _buildInfoField('Situação:', situacao),
                  const SizedBox(height: 16),
                  const Text(
                    'Documentos:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  ...documentos.map((doc) => _buildDocumentoItem(
                      doc['nome'] as String,
                      doc['status'] as bool
                  )).toList(),

                ],
              ),
            ),
            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: value,
          enabled: false,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentoItem(String nome, bool status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            status ? Icons.check_circle : Icons.cancel,
            color: status ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              nome,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
