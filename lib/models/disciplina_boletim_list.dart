import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../exceptions/http_exception.dart';
import '../utils/constants.dart';
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

    final disciplinaBoletim = DisciplinaBoletim(
      idDisciplinaBoletim: hasId ? data['idDisciplinaBoletim'] as String : '',
      idDisciplina: data['idDisciplina'] as String,
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
    final response = await http.post(
      Uri.parse(
          '${Constants.DISCIPLINA_BOLETIM_BASE_URL}/$_userId.json?auth=$_token'),
      body: jsonEncode({
        'idDisciplinaBoletim': disciplinaBoletim.idDisciplinaBoletim,
        'idDisciplina': disciplinaBoletim.idDisciplina,
        'idUser': disciplinaBoletim.idUser,
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
      final id = json.decode(response.body)['name'];
      final newBoletim = disciplinaBoletim.copyWith(idDisciplinaBoletim: id);
      _items.add(newBoletim);
      notifyListeners();
    } else {
      print('Erro no backend: ${response.body}');
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

      final novaDisciplinaBoletim = DisciplinaBoletim(
        idDisciplinaBoletim: '',
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
      await addDisciplinaBoletim(novaDisciplinaBoletim);
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
