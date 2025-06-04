import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../exceptions/http_exception.dart';
import '../utils/constants.dart';
import 'auth.dart';
import 'disciplina_boletim.dart';
import 'package:firebase_database/firebase_database.dart';


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
          '${Constants.DISCIPLINA_BOLETIM_BASE_URL}/$_userId/disciplinas.json?auth=$_token'),
    );

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
      idUser: data['idUser'] as String,
      status: (data['status'] ?? 'Matriculado') as String,
      a1: (data['a1'] ?? 0.0) as double,
      a2: (data['a2'] ?? 0.0) as double,
      exameFinal: (data['exameFinal'] ?? 0.0) as double,
      mediaSemestral: (data['mediaSemestral'] ?? 0.0) as double,
      mediaFinal: (data['mediaFinal'] ?? 0.0) as double,
      faltasNoSemestre: (data['faltasNoSemestre'] ?? 0) as int,
    );

    if (hasId) {
      return updateDisciplinaBoletim(disciplinaBoletim);
    } else {
      return addDisciplinaBoletim(disciplinaBoletim);
    }
  }

  Future<void> addDisciplinaBoletim(DisciplinaBoletim disciplinaBoletim) async {
    // 1. Buscar nome da disciplina no Firebase com base no id
    final disciplinaResponse = await http.get(
      Uri.parse(
          '${Constants.DISCIPLINA_BASE_URL}/${disciplinaBoletim.idDisciplina}.json?auth=$_token'),
    );

    if (disciplinaResponse.statusCode >= 400 ||
        disciplinaResponse.body == 'null') {
      throw HttpException(
        msg: 'Não foi possível buscar o nome da disciplina.',
        statusCode: disciplinaResponse.statusCode,
      );
    }

    final disciplinaData = jsonDecode(disciplinaResponse.body);
    final nomeDisciplina = disciplinaData['nome'] ?? 'Sem nome';

    // 2. Atualiza o objeto com o nome
    final disciplinaBoletimAtualizada = disciplinaBoletim.copyWith(
      nomeDisciplina: nomeDisciplina,
    );

    // 3. Salvar no Firebase - usando POST para gerar um novo ID
    final response = await http.post(
      Uri.parse('${Constants.DISCIPLINA_BOLETIM_BASE_URL}.json?auth=$_token'),
      body: jsonEncode({
        'idDisciplinaBoletim': '', // vazio, pois vai atualizar depois
        'idDisciplina': disciplinaBoletimAtualizada.idDisciplina,
        'nomeDisciplina': disciplinaBoletimAtualizada.nomeDisciplina,
        'idUser': disciplinaBoletimAtualizada.idUser,
        'status': disciplinaBoletimAtualizada.status,
        'a1': disciplinaBoletimAtualizada.a1,
        'a2': disciplinaBoletimAtualizada.a2,
        'exameFinal': disciplinaBoletimAtualizada.exameFinal,
        'mediaSemestral': disciplinaBoletimAtualizada.mediaSemestral,
        'mediaFinal': disciplinaBoletimAtualizada.mediaFinal,
        'faltasNoSemestre': disciplinaBoletimAtualizada.faltasNoSemestre,
      }),
    );

    if (response.statusCode < 400) {
      final id = json.decode(response.body)['name'];

      // 4. Atualizar o campo idDisciplinaBoletim com o ID gerado no registro
      final updateUrl = Uri.parse('${Constants.DISCIPLINA_BOLETIM_BASE_URL}/$id.json?auth=$_token');

      await http.patch(
        updateUrl,
        body: jsonEncode({'idDisciplinaBoletim': id}),
      );

      // 5. Atualiza localmente a lista e notifica listeners
      final newBoletim =
      disciplinaBoletimAtualizada.copyWith(idDisciplinaBoletim: id);
      _items.add(newBoletim);
      notifyListeners();
    } else {
      throw HttpException(
        msg: 'Não foi possível adicionar o disciplinaBoletim.',
        statusCode: response.statusCode,
      );
    }
  }


  Future<void> updateDisciplinaBoletim(
      DisciplinaBoletim disciplinaBoletim) async {
    int index = _items.indexWhere(
        (b) => b.idDisciplinaBoletim == disciplinaBoletim.idDisciplinaBoletim);

    if (index >= 0) {
      final response = await http.patch(
        Uri.parse(
            '${Constants.DISCIPLINA_BOLETIM_BASE_URL}/${disciplinaBoletim.idDisciplinaBoletim}.json?auth=$_token'),
        body: jsonEncode({
          'status': disciplinaBoletim.status,
          'a1': disciplinaBoletim.a1,
          'a2': disciplinaBoletim.a2,
          'exameFinal': disciplinaBoletim.exameFinal,
          'mediaSemestral': disciplinaBoletim.mediaSemestral,
          'mediaFinal': disciplinaBoletim.mediaFinal,
          'faltasNoSemestre': disciplinaBoletim.faltasNoSemestre,
        }),
      );
      if (response.statusCode < 400) {
        _items[index] = disciplinaBoletim;
        notifyListeners();
      } else {
        throw HttpException(
          msg: 'Não foi possível atualizar o disciplinaBoletim.',
          statusCode: response.statusCode,
        );
      }
    }
  }

  Future<void> registrarDisciplinasDoCursoNoBoletim(String idCurso) async {
    final disciplinasResponse = await http.get(
      Uri.parse('${Constants.DISCIPLINA_BASE_URL}.json?auth=$_token'),
    );

    if (disciplinasResponse.statusCode >= 400 || disciplinasResponse.body == 'null') {
      return;
    }

    final Map<String, dynamic> disciplinasData = jsonDecode(disciplinasResponse.body);

    final disciplinasDoCurso = disciplinasData.entries.where((entry) {
      return entry.value['idCurso'] == idCurso;
    });

    for (final disciplinaEntry in disciplinasDoCurso) {
      final disciplinaId = disciplinaEntry.key;
      final dados = disciplinaEntry.value;

      final nomeDisciplina = dados['nome'] ?? 'Desconhecida';

      final novaDisciplinaBoletim = DisciplinaBoletim(
        idDisciplinaBoletim: '', // Será preenchido depois
        nomeDisciplina: nomeDisciplina,
        idDisciplina: disciplinaId,
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
      final postUrl = Uri.parse('${Constants.DISCIPLINA_BOLETIM_BASE_URL}/$_userId.json?auth=$_token');
      final response = await http.post(
        postUrl,
        body: jsonEncode(novaDisciplinaBoletim.toJson()),
      );

      final responseData = jsonDecode(response.body);
      final generatedId = responseData['name'];

      // 🟡 PATCH para atualizar o idDisciplinaBoletim
      final patchUrl = Uri.parse('${Constants.DISCIPLINA_BOLETIM_BASE_URL}/$_userId/$generatedId.json?auth=$_token');
      await http.patch(
        patchUrl,
        body: jsonEncode({'idDisciplinaBoletim': generatedId}),
      );
    }
  }



  Future<List<DisciplinaBoletim>> fetchDisciplinasPendentes() async {
    final token = Auth().token;
    final userId = Auth().userId;

    final response = await http.get(
      Uri.parse('${Constants.DISCIPLINA_BOLETIM_BASE_URL}/$userId.json?auth=$token'),
    );

    // Verifica se houve erro na resposta
    final decodedBody = jsonDecode(response.body);

    if (decodedBody is String) {
      print('❌ Erro: Firebase retornou uma string (possível "Permission denied"): $decodedBody');
      return [];
    }

    if (decodedBody == null || decodedBody is! Map<String, dynamic>) {
      print('❌ Erro: dados inválidos ou nulos retornados.');
      return [];
    }

    final List<DisciplinaBoletim> pendentes = [];

    decodedBody.forEach((id, value) {
      if (value is Map<String, dynamic>) {
        final disc = DisciplinaBoletim.fromMap(value);

        if (disc.status == 'PD' && disc.idUser == userId) {
          pendentes.add(disc);
        }

      } else {
        print('⚠️ Ignorado: $id - valor não é um Map: $value');
      }
    });

    print('🔥 Disciplinas retornadas:');
    decodedBody.forEach((id, value) {
      if (value is Map<String, dynamic>) {
        print('➖ ID: $id, STATUS: ${value['status']}, USER: ${value['idUser']}');
      } else {
        print('⚠️ Valor inesperado para $id: $value');
      }
    });

    print('🔍 Usuário atual: $userId');

    return pendentes;
  }



  Future<void> rematriculaDisciplinaBoletim(DisciplinaBoletim d, String token) async {
    final idUser = d.idUser;
    final idDisciplinaBoletim = d.idDisciplinaBoletim;

    if (idUser == null || idUser.isEmpty) {
      print('❌ idUser vazio ou nulo!');
      return;
    }
    if (idDisciplinaBoletim == null || idDisciplinaBoletim.isEmpty) {
      print('❌ idDisciplinaBoletim vazio ou nulo!');
      return;
    }

    final url = Uri.parse(
        '${Constants.DISCIPLINA_BOLETIM_BASE_URL}/$idUser/$idDisciplinaBoletim.json?auth=$token'
    );

    final response = await http.patch(
      url,
      body: '{"status": "MT"}',
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('✅ Atualizado via HTTP para MT: $idDisciplinaBoletim');
    } else {
      print('❌ Falha ao atualizar via HTTP: ${response.statusCode} - ${response.body}');
    }
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
