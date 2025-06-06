import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitins_projeto/models/curso_list.dart';
import 'package:unitins_projeto/models/disciplina_boletim.dart';
import 'package:unitins_projeto/models/disciplina_boletim_list.dart';
import 'package:unitins_projeto/models/user_list.dart';

import '../models/disciplina_list.dart';

class DisciplinaBoletimFormPage extends StatefulWidget {
  const DisciplinaBoletimFormPage({Key? key}) : super(key: key);

  @override
  State<DisciplinaBoletimFormPage> createState() =>
      _DisciplinaBoletimFormPageState();
}

class _DisciplinaBoletimFormPageState extends State<DisciplinaBoletimFormPage> {
  final _idDisciplina = FocusNode();
  // final _idUser = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  String? _selectedDisciplinaId;
  // String? _selectedUserId;

  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<CursoList>(context, listen: false).loadCurso();
    Provider.of<DisciplinaList>(context, listen: false).loadDisciplinas();
    Provider.of<UserList>(context, listen: false).loadUser();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final disciplinaBoletim = arg as DisciplinaBoletim;
        _formData['idDisciplina'] = disciplinaBoletim.idDisciplina;
        // _formData['idUser'] = disciplinaBoletim.idUser;

      }
      if (_formData.containsKey('idDisciplinaBoletim')) {
        _selectedDisciplinaId = _formData['idDisciplinaBoletim']?.toString();
      }
      // if (_formData.containsKey('idUser')) {
      //   _selectedUserId = _formData['idUser']?.toString();
      // }
    }
  }

  @override
  void dispose() {
    _idDisciplina.dispose();
    // _idUser.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    _formKey.currentState?.save();

    final disciplinaBoletimList =
    Provider.of<DisciplinaBoletimList>(context, listen: false);

    setState(() => _isLoading = true);

    try {
      final isEditando = _formData.containsKey('idDisciplinaBoletim') &&
          (_formData['idDisciplinaBoletim'] as String).isNotEmpty;

      if (isEditando) {
        await disciplinaBoletimList.updateDisciplinaBoletim(
          idDisciplinaBoletim: '',
          camposAtualizados: {
            'status': _formData['status'],
            'a1': _formData['a1'],
            'a2': _formData['a2'],
            'exameFinal': _formData['exameFinal'],
            'mediaSemestral': _formData['mediaSemestral'],
            'mediaFinal': _formData['mediaFinal'],
            'faltasNoSemestre': _formData['faltasNoSemestre'],
          },
        );
      } else {
        await disciplinaBoletimList.saveDisciplinaBoletim(_formData);
      }

      Navigator.of(context).pop();
    } catch (error) {
      print('❌ ERRO AO SALVAR: $error');
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('Erro ao salvar a disciplina no boletim.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Disciplina Boletim'),
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
              //ADD ID DISCIPLINA
              Consumer<DisciplinaList>(
                builder: (ctx, disciplinaList, child) {
                  if (disciplinaList.items.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return DropdownButtonFormField<String>(
                    value: _selectedDisciplinaId,
                    decoration: const InputDecoration(
                      labelText: 'Disciplina',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    items: disciplinaList.items.map((disciplina) {
                      return DropdownMenuItem<String>(
                        value: disciplina.idDisciplina,
                        child: Text(
                          disciplina.nome,
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDisciplinaId = value;
                      });
                      _formData['idDisciplina'] = value ?? '';
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Selecione um Disciplina';
                      }
                      return null;
                    },
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down),
                    hint: const Text('Selecione um Disciplina'),
                  );
                },
              ),
              const SizedBox(height: 30),
              //ADD ID USER
              // Consumer<UserList>(
              //   builder: (ctx, userList, child) {
              //     if (userList.items.isEmpty) {
              //       return const Padding(
              //         padding: EdgeInsets.symmetric(vertical: 16),
              //         child: Center(child: CircularProgressIndicator()),
              //       );
              //     }
              //     return DropdownButtonFormField<String>(
              //       value: _selectedUserId,
              //       decoration: const InputDecoration(
              //         labelText: 'User',
              //         border: OutlineInputBorder(),
              //         contentPadding: EdgeInsets.symmetric(
              //           horizontal: 16,
              //           vertical: 12,
              //         ),
              //       ),
              //       items: userList.items.map((user) {
              //         return DropdownMenuItem<String>(
              //           value: user.idUser,
              //           child: Text(
              //             user.nome,
              //             style: const TextStyle(fontSize: 16),
              //           ),
              //         );
              //       }).toList(),
              //       onChanged: (value) {
              //         setState(() {
              //           _selectedUserId = value;
              //         });
              //         _formData['idUser'] = value ?? '';
              //       },
              //       validator: (value) {
              //         if (value == null) {
              //           return 'Selecione um Usuario';
              //         }
              //         return null;
              //       },
              //       isExpanded: true,
              //       icon: const Icon(Icons.arrow_drop_down),
              //       hint: const Text('Selecione um Usuario'),
              //     );
              //   },
              // ),
              const SizedBox(height: 30),
              // Botão de Salvar
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Salvar Disciplina no Boletim'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}