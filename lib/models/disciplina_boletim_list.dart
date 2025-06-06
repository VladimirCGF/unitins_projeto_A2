import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../exceptions/http_exception.dart';
import '../utils/constants.dart';
import 'auth.dart';
import 'disciplina_boletim.dart';

class DisciplinaBoletimList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<DisciplinaBoletim> _items = [];

  List<DisciplinaBoletim> get items => [..._items];

  DisciplinaBoletimList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get itemsCount => _items.length;

  Future<void> loadDisciplinasBoletim() async {
    _items.clear();

    final response = await http.get(
      Uri.parse(
          '${Constants.DISCIPLINA_BOLETIM_BASE_URL}/$_userId.json?auth=$_token'),
    );

    print('----------');
    print(response.body);
    if (response.body == 'null') return;

    final Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((disciplinaId, disciplinaData) {
      _items.add(
        DisciplinaBoletim.fromMap({
          'idDisciplinaBoletim': disciplinaId,
          'idDisciplina': disciplinaId,
          'userId': _userId,
          ...disciplinaData,
        }),
      );
    });

    notifyListeners();
  }

  Future<void> saveDisciplinaBoletim(Map<String, dynamic> data) async {
    bool hasId = data['idDisciplinaBoletim'] != null;
    final String idDisciplina = data['idDisciplina'] as String;

    // Buscar nome da disciplina com base no idDisciplina
    final disciplinaResponse = await http.get(
      Uri.parse(
          '${Constants.DISCIPLINA_BASE_URL}/$idDisciplina.json?auth=$_token'),
    );

    if (disciplinaResponse.statusCode >= 400 ||
        disciplinaResponse.body == 'null') {
      throw HttpException(
        msg: 'Erro ao buscar a disciplina.',
        statusCode: disciplinaResponse.statusCode,
      );
    }

    final disciplinaData = jsonDecode(disciplinaResponse.body);
    final String nomeDisciplina = disciplinaData['nome'] ?? 'Desconhecida';

    final disciplinaBoletim = DisciplinaBoletim(
      idDisciplinaBoletim: hasId ? data['idDisciplinaBoletim'] as String : '',
      idDisciplina: idDisciplina,
      nomeDisciplina: nomeDisciplina,
      idUser: _userId,
      status: (data['status'] ?? 'Matriculado') as String,
      a1: (data['a1'] ?? 0.0) as double,
      a2: (data['a2'] ?? 0.0) as double,
      exameFinal: (data['exameFinal'] ?? 0.0) as double,
      mediaSemestral: (data['mediaSemestral'] ?? 0.0) as double,
      mediaFinal: (data['mediaFinal'] ?? 0.0) as double,
      faltasNoSemestre: (data['faltasNoSemestre'] ?? 0) as int,
    );

    if (hasId) {
      return updateDisciplinaBoletim(
        idDisciplinaBoletim: disciplinaBoletim.idDisciplinaBoletim,
        camposAtualizados: {},
      );
    } else {
      return addDisciplinaBoletim(idDisciplina);
    }
  }

  Future<void> addDisciplinaBoletim(String idDisciplina) async {
    // 🟢 Buscar a disciplina no banco
    final disciplinaResponse = await http.get(
      Uri.parse(
          '${Constants.DISCIPLINA_BASE_URL}/$idDisciplina.json?auth=$_token'),
    );

    if (disciplinaResponse.statusCode >= 400 ||
        disciplinaResponse.body == 'null') {
      return;
    }

    final dados = jsonDecode(disciplinaResponse.body);

    final nomeDisciplina = dados['nome'] ?? 'Desconhecida';

    final novaDisciplinaBoletim = DisciplinaBoletim(
      idDisciplinaBoletim: '',
      nomeDisciplina: nomeDisciplina,
      idDisciplina: idDisciplina,
      idUser: _userId,
      status: 'PD',
      a1: 0.0,
      a2: 0.0,
      exameFinal: 0.0,
      mediaSemestral: 0.0,
      mediaFinal: 0.0,
      faltasNoSemestre: 0,
    );

    // 🟢 POST no caminho correto por usuário
    final postUrl = Uri.parse(
        '${Constants.DISCIPLINA_BOLETIM_BASE_URL}/$_userId.json?auth=$_token');
    final response = await http.post(
      postUrl,
      body: jsonEncode(novaDisciplinaBoletim.toJson()),
    );

    final responseData = jsonDecode(response.body);
    final generatedId = responseData['name'];

    // 🟡 PATCH para atualizar o idDisciplinaBoletim
    final patchUrl = Uri.parse(
        '${Constants.DISCIPLINA_BOLETIM_BASE_URL}/$_userId/$generatedId.json?auth=$_token');
    await http.patch(
      patchUrl,
      body: jsonEncode({'idDisciplinaBoletim': generatedId}),
    );
  }

  Future<void> updateDisciplinaBoletim({
    required String idDisciplinaBoletim,
    required Map<String, dynamic> camposAtualizados,
  }) async {
    final patchUrl = Uri.parse(
      '${Constants.DISCIPLINA_BOLETIM_BASE_URL}/$_userId/$idDisciplinaBoletim.json?auth=$_token',
    );

    final response = await http.patch(
      patchUrl,
      body: jsonEncode(camposAtualizados),
    );

    if (response.statusCode >= 400) {
      throw Exception('Erro ao atualizar a disciplina no boletim.');
    }
  }

  Future<void> registrarDisciplinasDoCursoNoBoletim(String idCurso) async {
    final disciplinasResponse = await http.get(
      Uri.parse('${Constants.DISCIPLINA_BASE_URL}.json?auth=$_token'),
    );

    if (disciplinasResponse.statusCode >= 400 ||
        disciplinasResponse.body == 'null') {
      return;
    }

    final Map<String, dynamic> disciplinasData =
        jsonDecode(disciplinasResponse.body);

    final disciplinasDoCurso = disciplinasData.entries.where((entry) {
      return entry.value['idCurso'] == idCurso;
    });

    for (final disciplinaEntry in disciplinasDoCurso) {
      final disciplinaId = disciplinaEntry.key;
      final dados = disciplinaEntry.value;

      final nomeDisciplina = dados['nome'] ?? 'Desconhecida';

      final random = Random();
      double a1 = (random.nextInt(10) + 1).toDouble();
      double a2 = (random.nextInt(10) + 1).toDouble();
      double mediaFinal = (a1 + a2) / 2;
      String status;

      if (mediaFinal >= 6) {
        status = 'AP';
      } else {
        a1 = 0.0;
        a2 = 0.0;
        mediaFinal = 0.0;
        status = 'PD';
      }

      final novaDisciplinaBoletim = DisciplinaBoletim(
        idDisciplinaBoletim: '',
        nomeDisciplina: nomeDisciplina,
        idDisciplina: disciplinaId,
        idUser: _userId,
        status: status,
        a1: a1,
        a2: a2,
        exameFinal: 0.0,
        mediaSemestral: 0.0,
        mediaFinal: mediaFinal,
        faltasNoSemestre: 0,
      );

      // 🟢 POST no caminho correto por usuário
      final postUrl = Uri.parse(
          '${Constants.DISCIPLINA_BOLETIM_BASE_URL}/$_userId.json?auth=$_token');
      final response = await http.post(
        postUrl,
        body: jsonEncode(novaDisciplinaBoletim.toJson()),
      );

      final responseData = jsonDecode(response.body);
      final generatedId = responseData['name'];

      // 🟡 PATCH para atualizar o idDisciplinaBoletim
      final patchUrl = Uri.parse(
          '${Constants.DISCIPLINA_BOLETIM_BASE_URL}/$_userId/$generatedId.json?auth=$_token');
      await http.patch(
        patchUrl,
        body: jsonEncode({'idDisciplinaBoletim': generatedId}),
      );
    }
  }

  Future<List<DisciplinaBoletim>> fetchDisciplinasPendentes(
      BuildContext context) async {
    final auth = Provider.of<Auth>(context, listen: false);
    final userId = auth.userId;

    if (userId == null) {
      print('❌ ERRO: userId está null. Usuário não está logado corretamente.');
      return [];
    }

    final response = await http.get(
      Uri.parse(
          '${Constants.DISCIPLINA_BOLETIM_BASE_URL}/$userId.json?auth=$_token'),
    );

    if (response.statusCode >= 400) {
      print('❌ Erro de requisição: ${response.statusCode}');
      return [];
    }

    final data = jsonDecode(response.body);

    if (data == null) return [];

    final List<DisciplinaBoletim> pendentes = [];

    data.forEach((id, value) {
      if (value is Map<String, dynamic>) {
        final disc = DisciplinaBoletim.fromMap(value);
        if (disc.status == 'PD' && disc.idUser == userId) {
          pendentes.add(disc);
        }
      } else {
        print('⚠️ Ignorado: $id - valor não é um Map: $value');
      }
    });

    print('📋 Disciplinas com status PD: ${pendentes.length}');
    return pendentes;
  }

  Future<List<DisciplinaBoletim>> fetchDisciplinasMatriculadas(
      BuildContext context) async {
    final auth = Provider.of<Auth>(context, listen: false);
    final userId = auth.userId;

    if (userId == null) {
      print('❌ ERRO: userId está null. Usuário não está logado corretamente.');
      return [];
    }

    final response = await http.get(
      Uri.parse(
          '${Constants.DISCIPLINA_BOLETIM_BASE_URL}/$userId.json?auth=$_token'),
    );

    if (response.statusCode >= 400) {
      print('❌ Erro de requisição: ${response.statusCode}');
      return [];
    }

    final data = jsonDecode(response.body);

    if (data == null) return [];

    final List<DisciplinaBoletim> pendentes = [];

    data.forEach((id, value) {
      if (value is Map<String, dynamic>) {
        final disc = DisciplinaBoletim.fromMap(value);
        if (disc.status == 'MT' && disc.idUser == userId) {
          pendentes.add(disc);
        }
      } else {
        print('⚠️ Ignorado: $id - valor não é um Map: $value');
      }
    });

    print('📋 Disciplinas com status MT: ${pendentes.length}');
    return pendentes;
  }

  Future<List<DisciplinaBoletim>> fetchDisciplinasAprovadas(
      BuildContext context) async {
    final auth = Provider.of<Auth>(context, listen: false);
    final userId = auth.userId;

    if (userId == null) {
      print('❌ ERRO: userId está null. Usuário não está logado corretamente.');
      return [];
    }

    final response = await http.get(
      Uri.parse(
          '${Constants.DISCIPLINA_BOLETIM_BASE_URL}/$userId.json?auth=$_token'),
    );

    if (response.statusCode >= 400) {
      print('❌ Erro de requisição: ${response.statusCode}');
      return [];
    }

    final data = jsonDecode(response.body);

    if (data == null) return [];

    final List<DisciplinaBoletim> pendentes = [];

    data.forEach((id, value) {
      if (value is Map<String, dynamic>) {
        final disc = DisciplinaBoletim.fromMap(value);
        if (disc.status == 'AP' && disc.idUser == userId) {
          pendentes.add(disc);
        }
      } else {
        print('⚠️ Ignorado: $id - valor não é um Map: $value');
      }
    });

    print('📋 Disciplinas com status AP: ${pendentes.length}');
    return pendentes;
  }

  Future<bool> rematriculaDisciplinaBoletim(DisciplinaBoletim d) async {
    final idUser = d.idUser;
    final idDisciplinaBoletim = d.idDisciplinaBoletim;

    if (idUser == null || idUser.isEmpty) {
      print('❌ idUser vazio ou nulo!');
      return false;
    }
    if (idDisciplinaBoletim == null || idDisciplinaBoletim.isEmpty) {
      print('❌ idDisciplinaBoletim vazio ou nulo!');
      return false;
    }

    final user = _userId;
    if (user == null) {
      print(
          '❌ Usuário não autenticado! Abortando atualização para disciplina $idDisciplinaBoletim');
      return false;
    }

    // final token = await user.getIdToken();
    final url = Uri.parse(
      '${Constants.DISCIPLINA_BOLETIM_BASE_URL}/$_userId/$idDisciplinaBoletim.json?auth=$_token',
    );

    print('🔑 Usando token: $_token');
    print('🌐 Atualizando disciplina $idDisciplinaBoletim em $url');

    final response = await http.patch(
      url,
      body: '{"status": "MT"}',
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('✅ Disciplina $idDisciplinaBoletim rematriculada como MT');
      return true;
    } else {
      print(
          '❌ Falha ao atualizar disciplina $idDisciplinaBoletim: ${response.statusCode} - ${response.body}');
      return false;
    }
  }

  Future<double> calcularPercentualConclusaoDoCurso(String idCurso) async {
    final disciplinasResponse = await http.get(
      Uri.parse('${Constants.DISCIPLINA_BASE_URL}.json?auth=$_token'),
    );

    if (disciplinasResponse.statusCode >= 400 ||
        disciplinasResponse.body == 'null') {
      print('❌ Erro ao buscar disciplinas do curso.');
      return 0.0;
    }

    final Map<String, dynamic> disciplinasData =
        jsonDecode(disciplinasResponse.body);

    final disciplinasDoCurso = disciplinasData.entries.where((entry) {
      return entry.value['idCurso'] == idCurso;
    }).toList();

    final totalDisciplinas = disciplinasDoCurso.length;

    if (totalDisciplinas == 0) {
      print('⚠️ Nenhuma disciplina encontrada para o curso $idCurso');
      return 0.0;
    }

    // Buscar disciplinas do boletim do usuário
    final response = await http.get(
      Uri.parse(
          '${Constants.DISCIPLINA_BOLETIM_BASE_URL}/$_userId.json?auth=$_token'),
    );

    if (response.statusCode >= 400 || response.body == 'null') {
      print('❌ Erro ao buscar disciplinas do boletim do usuário.');
      return 0.0;
    }

    final Map<String, dynamic> boletimData = jsonDecode(response.body);

    // Filtra as disciplinas concluídas
    int disciplinasConcluidas = 0;

    for (final disciplinaEntry in disciplinasDoCurso) {
      final idDisciplina = disciplinaEntry.key;

      // Verifica se o usuário tem essa disciplina no boletim e se está concluída
      final concluida = boletimData.entries.any((boletimEntry) {
        final data = boletimEntry.value;
        return data['idDisciplina'] == idDisciplina &&
            (data['status'] == 'AP' || data['status'] == 'RM');
      });

      if (concluida) {
        disciplinasConcluidas++;
      }
    }

    final percentual = (disciplinasConcluidas / totalDisciplinas) * 100;

    print(
        '✅ $disciplinasConcluidas de $totalDisciplinas disciplinas concluídas.');
    print('📊 Percentual de conclusão: ${percentual.toStringAsFixed(2)}%');

    return percentual;
  }

  Future<void> removeDisciplinaBoletim(
      DisciplinaBoletim disciplinaBoletim) async {
    int index = _items.indexWhere(
        (b) => b.idDisciplinaBoletim == disciplinaBoletim.idDisciplinaBoletim);

    if (index >= 0) {
      final boletimRemovido = _items[index];
      _items.removeAt(index);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.DISCIPLINA_BOLETIM_BASE_URL}/${disciplinaBoletim.idDisciplinaBoletim}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, boletimRemovido);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir o Disciplina Boletim.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
