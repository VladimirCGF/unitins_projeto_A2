import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../exceptions/http_exception.dart';
import '../models/boletim.dart';
import '../utils/constants.dart';
import 'disciplina.dart';

class BoletimList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Boletim> _items = [];

  List<Boletim> get items => [..._items];

  BoletimList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadBoletins() async {
    _items.clear();

    final response = await http.get(
      Uri.parse('${Constants.BOLETIM_BASE_URL}/$_userId.json?auth=$_token'),
    );
    if (response.body == 'null') return;
    final Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((boletimId, boletimData) {
      _items.add(
        Boletim.fromMap({
          'idBoletim': boletimId,
          ...boletimData,
        }),
      );
    });

    notifyListeners();
  }



  Future<void> saveBoletim(Map<String, dynamic> data) async {
    bool hasId = data['idBoletim'] != null;

    final boletim = Boletim(
      idBoletim: hasId
          ? data['idBoletim'] as String
          : Random().nextDouble().toString(),
      periodoLetivo: data['periodoLetivo'] as String,
      disciplinas: (data['disciplinas'] as List?)
              ?.map((cursoData) =>
                  Disciplina.fromMap(cursoData as Map<String, dynamic>))
              .toSet() ??
          {},
      faltasNoSemestre: (data['faltasNoSemestre'] ?? 0) as int,
      a1: (data['a1'] ?? 0.0) as double,
      a2: (data['a2'] ?? 0.0) as double,
      exameFinal: (data['exameFinal'] ?? 0.0) as double,
      mediaSemestral: (data['mediaSemestral'] ?? 0.0) as double,
      mediaFinal: (data['mediaFinal'] ?? 0.0) as double,
      status: (data['status'] ?? 'Matriculado') as String,
    );
    if (hasId) {
      return updateBoletim(boletim);
    } else {
      return addBoletim(boletim);
    }
  }

  Future<void> addBoletim(Boletim boletim) async {
    final response = await http.post(
        Uri.parse('${Constants.BOLETIM_BASE_URL}/$_userId.json?auth=$_token'),
        body: jsonEncode({
        'periodoLetivo': boletim.periodoLetivo,
        'disciplinas': boletim.disciplinas.map((c) => c.toMap()).toList(),
        'faltasNoSemestre': boletim.faltasNoSemestre,
        'a1': boletim.a1,
        'a2': boletim.a2,
        'exameFinal': boletim.exameFinal,
        'mediaSemestral': boletim.mediaSemestral,
        'mediaFinal': boletim.mediaFinal,
        'status': boletim.status,
      }),
    );
    if (response.statusCode < 400) {
      _items.add(boletim);
      notifyListeners();
    } else {
      print('Erro no backend: ${response.body}'); // <-- Adicione este print
      throw HttpException(
        msg: 'Não foi possível adicionar o boletim.',
        statusCode: response.statusCode,
      );
    }

  }

  Future<void> updateBoletim(Boletim boletim) async {
    int index = _items.indexWhere((b) => b.idBoletim == boletim.idBoletim);

    if (index >= 0) {
      final response = await http.patch(
        Uri.parse(
            '${Constants.BOLETIM_BASE_URL}/${boletim.idBoletim}.json?auth=$_token'),
        body: jsonEncode({
          'periodoLetivo': boletim.periodoLetivo,
          'disciplinas': boletim.disciplinas.map((c) => c.toMap()).toList(),
          'faltasNoSemestre': boletim.faltasNoSemestre,
          'a1': boletim.a1,
          'a2': boletim.a2,
          'exameFinal': boletim.exameFinal,
          'mediaSemestral': boletim.mediaSemestral,
          'mediaFinal': boletim.mediaFinal,
          'status': boletim.status,
        }),
      );
      if (response.statusCode < 400) {
        _items[index] = boletim;
        notifyListeners();
      } else {
        throw HttpException(
          msg: 'Não foi possível atualizar o boletim.',
          statusCode: response.statusCode,
        );
      }
    }

    Future<void> removeBoletim(Boletim boletim) async {
      int index = _items.indexWhere((b) => b.idBoletim == boletim.idBoletim);

      if (index >= 0) {
        final boletimRemovido = _items[index];
        _items.removeAt(index);
        notifyListeners();

        final response = await http.delete(
          Uri.parse(
              '${Constants.BOLETIM_BASE_URL}/${boletim.idBoletim}.json?auth=$_token'),
        );

        if (response.statusCode >= 400) {
          _items.insert(index, boletimRemovido);
          notifyListeners();
          throw HttpException(
            msg: 'Não foi possível excluir o boletim.',
            statusCode: response.statusCode,
          );
        }
      }
    }
  }
}
