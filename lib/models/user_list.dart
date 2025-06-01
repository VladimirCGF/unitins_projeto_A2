import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../exceptions/auth_exception.dart';
import '../exceptions/http_exception.dart';
import '../models/user.dart';
import '../utils/constants.dart';
import 'auth.dart';

class UserList with ChangeNotifier {
  final Auth auth;
  List<User> _items = [];

  List<User> get items => [..._items];

  UserList(
    this.auth, [
    this._items = const [],
  ]);

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadUser() async {
    final response = await http.get(
      Uri.parse('${Constants.USER_BASE_URL}.json?auth=${auth.token}'),
    );

    print('🔥 Firebase response body: ${response.body}');

    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body);

      if (extractedData == null) return;

      final List<User> loadedUsers = [];

      if (extractedData is Map<String, dynamic>) {
        extractedData.forEach((userId, userData) {
          if (userData is Map<String, dynamic>) {
            loadedUsers.add(
              User(
                idUser: userId,
                nome: userData['nome'],
                cpf: userData['cpf'],
                email: userData['email'],
                matricula: userData['matricula'],
                curso: userData['curso'],
              ),
            );
          }
        });

        _items = loadedUsers;
        notifyListeners();
      }
    } else {
      throw Exception('Erro ao carregar usuários');
    }
  }


  Future<void> saveUser(Map<String, Object> data) async {
    bool hasId = data['idUser'] != null;

    final user = User(
      idUser:
          hasId ? data['idUser'] as String : Random().nextDouble().toString(),
      nome: data['nome'] as String,
      cpf: data['cpf'] as String,
      email: data['email'] as String,
      matricula: data['matricula'] as String,
      curso: data['curso'] as String,
    );
    if (hasId) {
      return updateUser(user);
    } else {
      return addUser(user);
    }
  }

  Future<void> addUser(User user) async {
    final response = await http.post(
      Uri.parse('${Constants.USER_BASE_URL}.json?auth=${auth.token}'),
      body: jsonEncode({
        "nome": user.nome,
        "cpf": user.cpf,
        "email": user.email,
        "matricula": user.matricula,
        "curso": user.curso,
      }),
    );

    if (response.statusCode >= 400) {
      throw HttpException(
        msg: 'Não foi possível criar o usuário',
        statusCode: response.statusCode,
      );
    }

    // Após adicionar o usuário, cria o Auth
    try {
      await auth.signup(user.email, user.cpf);
    } catch (e) {
      throw AuthException('Erro ao registrar autenticação: $e');
    }

    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    int index = _items.indexWhere((p) => p.idUser == user.idUser);

    if (index >= 0) {
      await http.patch(
        Uri.parse('${Constants.USER_BASE_URL}.json?auth=${auth.token}'),
        body: jsonEncode(
          {
            "nome": user.nome,
            "cpf": user.cpf,
            "email": user.email,
            "matricula": user.matricula,
            "curso": user.curso,
          },
        ),
      );
      _items[index] = user;
      notifyListeners();
    }
  }

  Future<void> removeUser(User user) async {
    int index = _items.indexWhere((p) => p.idUser == user.idUser);

    if (index >= 0) {
      final user = _items[index];
      _items.remove(user);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('${Constants.USER_BASE_URL}.json?auth=${auth.token}'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, user);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir o user',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
