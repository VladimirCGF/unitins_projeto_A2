import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitins_projeto/models/user_list.dart';

import '../models/curso_list.dart';
import '../models/user.dart';

class UserFormPage extends StatefulWidget {
  const UserFormPage({Key? key}) : super(key: key);

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _nome = FocusNode();
  final _cpf = FocusNode();
  final _email = FocusNode();
  final _matricula = FocusNode();
  final _idCurso = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  String? _selectedCursoId;

  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<UserList>(context, listen: false).loadUser();
    Provider.of<CursoList>(context, listen: false).loadCurso();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final user = arg as User;
        _formData['idUser'] = user.idUser;
        _formData['nome'] = user.nome;
        _formData['cpf'] = user.cpf;
        _formData['email'] = user.email;
        _formData['matricula'] = user.matricula;
        _formData['idCurso'] = user.idCurso;

      }
      if (_formData.containsKey('idCurso')) {
        _selectedCursoId = _formData['idCurso']?.toString();
      }
    }
  }

  @override
  void dispose() {
    _nome.dispose();
    _cpf.dispose();
    _email.dispose();
    _matricula.dispose();
    _idCurso.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    final userList = Provider.of<UserList>(context, listen: false);
    final matricula = _formData['matricula']?.toString();

    final idUser = _formData['idUser']?.toString();

    final matriculaExiste = userList.items.any((user) {
      final mesmoId = user.idUser == idUser;
      return user.matricula == matricula && !mesmoId;
    });

    if (matriculaExiste) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Matricula duplicado'),
          content: const Text('Já existe um user com esta matricula.'),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      );
      return; // Impede o envio.
    }

    setState(() => _isLoading = true);

    try {
      await userList.saveUser(_formData);
      if (!mounted) return;  // verifica se o widget ainda está ativo
      Navigator.of(context).pop();
    } catch (error, stackTrace) {
      print('❌ ERRO AO SALVAR USER: $error');
      print(stackTrace);
      if (!mounted) return;  // idem
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro!'),
          content: const Text('Ocorreu um erro ao salvar o user.'),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de User'),
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['nome']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Nome do User',
                        hintText: 'Ex: Fulano',
                      ),
                      focusNode: _nome,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submitForm(),
                      onSaved: (nome) => _formData['nome'] = nome ?? '',
                      validator: (_nome) {
                        final nome = _nome ?? '';
                        if (nome.trim().isEmpty) {
                          return 'Nome é obrigatório';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      initialValue: _formData['cpf']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'CPF do User',
                        hintText: 'Ex: 123',
                      ),
                      focusNode: _cpf,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submitForm(),
                      onSaved: (cpf) => _formData['cpf'] = cpf ?? '',
                      validator: (_cpf) {
                        final cpf = _cpf ?? '';
                        if (cpf.trim().isEmpty) {
                          return 'CPF é obrigatório';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      initialValue: _formData['email']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Email do User',
                        hintText: 'Ex: email@unitins.br',
                      ),
                      focusNode: _email,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submitForm(),
                      onSaved: (email) => _formData['email'] = email ?? '',
                      validator: (_email) {
                        final email = _email ?? '';
                        if (email.trim().isEmpty) {
                          return 'Email é obrigatório';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      initialValue: _formData['matricula']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Matricula do User',
                        hintText: 'Ex: 123456',
                      ),
                      focusNode: _matricula,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submitForm(),
                      onSaved: (matricula) =>
                          _formData['matricula'] = matricula ?? '',
                      validator: (_matricula) {
                        final matricula = _matricula ?? '';
                        if (matricula.trim().isEmpty) {
                          return 'Matricula é obrigatório';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Consumer<CursoList>(
                      builder: (ctx, cursoList, child) {
                        if (cursoList.items.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return DropdownButtonFormField<String>(
                          value: _selectedCursoId,
                          decoration: const InputDecoration(
                            labelText: 'Curso',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          items: cursoList.items.map((curso) {
                            return DropdownMenuItem<String>(
                              value: curso.idCurso,
                              child: Text(curso.nome),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCursoId = value;
                              _formData['idCurso'] = value ?? '';
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Curso é obrigatório';
                            }
                            return null;
                          },

                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          hint: const Text('Selecione um curso'),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    // Botão de Salvar
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Salvar User'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
