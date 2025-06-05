import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../exceptions/http_exception.dart';
import '../models/curso.dart';
import '../utils/constants.dart';

class CursoList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Curso> _items = [];

  List<Curso> get items => [..._items];

  CursoList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadCurso() async {
    _items.clear();

    final response = await http.get(
      Uri.parse('${Constants.CURSO_BASE_URL}.json?auth=$_token'),
    );

    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((cursoId, cursoData) {
      _items.add(
        Curso.fromMap({
          'idCurso': cursoId,
          ...cursoData,
        }),
      );
    });

    notifyListeners();
  }

  Future<void> saveCurso(Map<String, Object> data) async {
    bool hasId = data['idCurso'] != null;

    final curso = Curso(
      idCurso:
          hasId ? data['idCurso'] as String : Random().nextDouble().toString(),
      nome: data['nome'] as String,
    );

    if (hasId) {
      return updateCurso(curso);
    } else {
      return addCurso(curso);
    }
  }

  Future<void> addCurso(Curso curso) async {
    final response = await http.post(
      Uri.parse('${Constants.CURSO_BASE_URL}.json?auth=$_token'),
      body: jsonEncode(
        {
          "nome": curso.nome,
        },
      ),
    );
    notifyListeners();
  }

  Future<void> updateCurso(Curso curso) async {
    int index = _items.indexWhere((p) => p.idCurso == curso.idCurso);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.CURSO_BASE_URL}/${curso.idCurso}.json?auth=$_token'),
        body: jsonEncode(
          {
            "nome": curso.nome,
          },
        ),
      );
      _items[index] = curso;
      notifyListeners();
    }
  }

  Curso? findByCursoForIDCurso(String idCurso) {
    try {
      return _items.firstWhere((curso) => curso.idCurso == idCurso);
    } catch (e) {
      return null;
    }
  }

  Future<void> removeCurso(Curso curso) async {
    int index = _items.indexWhere((p) => p.idCurso == curso.idCurso);

    if (index >= 0) {
      final curso = _items[index];
      _items.remove(curso);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.CURSO_BASE_URL}/${curso.idCurso}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, curso);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir o curso',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
