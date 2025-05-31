import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../exceptions/http_exception.dart';
import '../models/periodo.dart';
import '../utils/constants.dart';

class PeriodoList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Periodo> _items = [];


  List<Periodo> get items => [..._items];

  PeriodoList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadPeriodos() async {
    _items.clear();

    final response = await http.get(
      Uri.parse('${Constants.PERIODO_BASE_URL}.json?auth=$_token'),
    );

    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((periodoId, periodoData) {
      _items.add(
        Periodo.fromMap({
          'idPeriodo': periodoId,
          ...periodoData,
        }),
      );
    });

    notifyListeners();
  }

  Future<void> savePeriodo(Map<String, Object> data) async {
    bool hasId = data['idPeriodo'] != null;

    final periodo = Periodo(
      idPeriodo: hasId
          ? data['idPeriodo'] as String
          : Random().nextDouble().toString(),
      nome: data['nome'] as String,
    );

    if (hasId) {
      return updatePeriodo(periodo);
    } else {
      return addPeriodo(periodo);
    }
  }

  Future<void> addPeriodo(Periodo periodo) async {
    final response = await http.post(
      Uri.parse('${Constants.PERIODO_BASE_URL}.json?auth=$_token'),
      body: jsonEncode(
        {
          "nome": periodo.nome,
        },
      ),
    );
    notifyListeners();
  }

  Future<void> updatePeriodo(Periodo periodo) async {
    int index = _items.indexWhere((p) => p.idPeriodo == periodo.idPeriodo);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.PERIODO_BASE_URL}/${periodo.idPeriodo}.json?auth=$_token'),
        body: jsonEncode(
          {
            "nome": periodo.nome,
          },
        ),
      );
      _items[index] = periodo;
      notifyListeners();
    }
  }

  Future<void> removePeriodo(Periodo periodo) async {
    int index = _items.indexWhere((p) => p.idPeriodo == periodo.idPeriodo);

    if (index >= 0) {
      final periodo = _items[index];
      _items.remove(periodo);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.PERIODO_BASE_URL}/${periodo.idPeriodo}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, periodo);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir o período',
          statusCode: response.statusCode,
        );
      }
    }
  }
}

