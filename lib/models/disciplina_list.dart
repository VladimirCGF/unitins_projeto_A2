import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unitins_projeto/models/disciplina.dart';

import '../exceptions/http_exception.dart';
import '../utils/constants.dart';

class DisciplinaList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Disciplina> _items = [];

  List<Disciplina> get items => [..._items];

  DisciplinaList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadDisciplinas() async {
    _items.clear();

    final response = await http.get(
      Uri.parse('${Constants.DISCIPLINA_BASE_URL}.json?auth=$_token'),
    );

    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((disciplinaId, disciplinaData) {
      _items.add(
        Disciplina.fromMap({
          'idDisciplina': disciplinaId,
          ...disciplinaData,
        }),
      );
    });

    notifyListeners();
  }

  Future<void> saveDisciplina(Map<String, Object> data) async {
    bool hasId = data['idDisciplina'] != null;

    final disciplina = Disciplina(
      idDisciplina: hasId
          ? data['idDisciplina'] as String
          : Random().nextDouble().toString(),
      codigo: data['codigo'] as String,
      nome: data['nome'] as String,
      ch: data['ch'] as String,
      periodo: data['idPeriodo'] as String,
      idCurso: data['idCurso'] as String,
    );
    if (hasId) {
      return updateDisciplina(disciplina);
    } else {
      return addDisciplina(disciplina);
    }
  }

  Future<void> addDisciplina(Disciplina disciplina) async {
    final response = await http.post(
      Uri.parse('${Constants.DISCIPLINA_BASE_URL}.json?auth=$_token'),
      body: jsonEncode(
        {
          "codigo": disciplina.codigo,
          "nome": disciplina.nome,
          "ch": disciplina.ch,
          "periodo": disciplina.periodo,
          "idCurso": disciplina.idCurso,
        },
      ),
    );
    notifyListeners();
  }

  Future<void> updateDisciplina(Disciplina disciplina) async {
    int index = _items.indexWhere((p) => p.idDisciplina == disciplina.idDisciplina);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.DISCIPLINA_BASE_URL}/${disciplina.idDisciplina}.json?auth=$_token'),
        body: jsonEncode(
          {
            "codigo": disciplina.codigo,
            "nome": disciplina.nome,
            "ch": disciplina.ch,
            "periodo": disciplina.periodo,
            "idCurso": disciplina.idCurso,
          },
        ),
      );
      _items[index] = disciplina;
      notifyListeners();
    }
  }


  Future<void> removeDisciplina(Disciplina disciplina) async {
    int index = _items.indexWhere((p) => p.idDisciplina == disciplina.idDisciplina);

    if (index >= 0) {
      final disciplina = _items[index];
      _items.remove(disciplina);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.DISCIPLINA_BASE_URL}/${disciplina.idDisciplina}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, disciplina);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir o disciplina',
          statusCode: response.statusCode,
        );
      }
    }
  }

}
