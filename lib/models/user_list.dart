import 'dart:convert';

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
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

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
                idCurso: userData['idCurso'],
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
    final novoUsuario = User(
      idUser: '', // Ainda será definido após o signup
      nome: data['nome'] as String,
      cpf: data['cpf'] as String,
      email: data['email'] as String,
      matricula: data['matricula'] as String,
      idCurso: data['idCurso'] as String,
    );

    final isNewUser = data['idUser'] == null;

    if (isNewUser) {
      // 1. Cria o Auth com e-mail e CPF como senha
      try {
        await auth.signup(novoUsuario.email, novoUsuario.cpf);
      } catch (e) {
        throw AuthException('Erro ao registrar autenticação: $e');
      }

      // 2. Agora salva no banco usando o userId do Auth como chave
      final userComId = novoUsuario.copyWith(idUser: auth.userId!);
      return addUser(userComId);
    } else {
      final userComId = novoUsuario.copyWith(idUser: data['idUser'] as String);
      return updateUser(userComId);
    }
  }


  Future<void> addUser(User user) async {
    final response = await http.put(
      Uri.parse('${Constants.USER_BASE_URL}/${user.idUser}.json?auth=${auth.token}'),
      body: jsonEncode({
        "idUser": user.idUser,
        "nome": user.nome,
        "cpf": user.cpf,
        "email": user.email,
        "matricula": user.matricula,
        "idCurso": user.idCurso,
      }),
    );

    if (response.statusCode >= 400) {
      throw HttpException(
        msg: 'Não foi possível criar o usuário',
        statusCode: response.statusCode,
      );
    }

    notifyListeners();
  }


  Future<void> updateUser(User user) async {
    int index = _items.indexWhere((p) => p.idUser == user.idUser);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.USER_BASE_URL}/${user.idUser}.json?auth=${auth.token}'),
        body: jsonEncode(
          {
            "nome": user.nome,
            "cpf": user.cpf,
            "email": user.email,
            "matricula": user.matricula,
            "idCurso": user.idCurso,
          },
        ),
      );
      _items[index] = user;
      notifyListeners();
    }
  }

  Future<User?> buscarUsuarioPorIdUser() async {
    final response = await http.get(
      Uri.parse('${Constants.USER_BASE_URL}.json?auth=${auth.token}'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data == null) {
        print('⚠️ Nenhum usuário encontrado.');
        return null;
      }

      for (final entry in data.entries) {
        final userMap = entry.value;
        if (userMap['idUser'] == auth.userId) {
          final user = User.fromMap(userMap);
          print('✅ Usuário encontrado: ${user.nome}');
          return user;
        }
      }

      print('⚠️ Usuário com idUser correspondente não encontrado.');
      return null;
    }
  }

  User? findByUserForID(String idUser) {
    try {
      return _items.firstWhere((user) => user.idUser == idUser);
    } catch (e) {
      return null;
    }
  }

  Future<void> removeUser(User user) async {
    int index = _items.indexWhere((p) => p.idUser == user.idUser);

    if (index >= 0) {
      final userToRemove = _items[index];
      _items.remove(userToRemove);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.USER_BASE_URL}/${user.idUser}.json?auth=${auth.token}'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, userToRemove);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir o user',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
