import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../data/store.dart';
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
    bool hasId = data['idUser'] != null;

    final user = User(
      idUser:
          hasId ? data['idUser'] as String : Random().nextDouble().toString(),
      nome: data['nome'] as String,
      cpf: data['cpf'] as String,
      email: data['email'] as String,
      matricula: data['matricula'] as String,
      idCurso: data['idCurso'] as String,
    );

    if (hasId) {
      return updateUser(user);
    } else {
      return addUser(user);
    }
  }

  Future<void> addUser(User user) async {
    // 1. Adiciona o usuário
    final response = await http.post(
      Uri.parse('${Constants.USER_BASE_URL}.json?auth=${auth.token}'),
      body: jsonEncode({
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

    final newUserId = json.decode(response.body)['name'];

    // 2. Cria o Auth com e-mail + CPF como senha
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
    print('🔍 Buscando usuário com ID: ${auth.userId}');

    try {
      final response = await http.get(
        Uri.parse('${Constants.USER_BASE_URL}.json?auth=${auth.token}'), // ✅ Corrigido
        headers: {
          'Authorization': 'Bearer ${auth.token}',
        },
      );
      print('Auth: $auth'); // ou do próprio auth provider que usa
      print('userId usado na URL: ${auth.userId}');


      print('🟢 Resposta da API: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Como o Firebase retorna um map com várias entradas,
        // precisamos buscar a entrada que tem o mesmo idUser
        for (final entry in data.entries) {
          final userMap = entry.value;
          if (userMap['idUser'] == auth.userId) {
            final user = User.fromMap(userMap);
            print('✅ Usuário encontrado: ${user.nome}');
            return user;
          }
        }

        print('⚠️ Nenhum usuário com idUser correspondente encontrado.');
        return null;
      } else {
        print('⚠️ Erro na requisição: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Erro ao buscar usuário: $e');
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
