import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitins_projeto/models/curso_list.dart';

import '../models/disciplina.dart';
import '../models/disciplina_list.dart';
import '../models/periodo_list.dart';

class DisciplinaFormPage extends StatefulWidget {
  const DisciplinaFormPage({Key? key}) : super(key: key);

  @override
  State<DisciplinaFormPage> createState() => _DisciplinaFormPageState();
}

class _DisciplinaFormPageState extends State<DisciplinaFormPage> {
  final _codigo = FocusNode();
  final _nome = FocusNode();
  final _ch = FocusNode();
  final _periodo = FocusNode();
  final _idCurso = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  String? _selectedPeriodoId;
  String? _selectedCursoId;

  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<PeriodoList>(context, listen: false).loadPeriodos();
    Provider.of<CursoList>(context, listen: false).loadCurso();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final disciplina = arg as Disciplina;
        _formData['idDisciplina'] = disciplina.idDisciplina;
        _formData['codigo'] = disciplina.codigo;
        _formData['nome'] = disciplina.nome;
        _formData['ch'] = disciplina.ch;
        _formData['periodo'] = disciplina.periodo;
        _formData['idCurso'] = disciplina.idCurso;
      }
      if (_formData.containsKey('idPeriodo')) {
        _selectedPeriodoId = _formData['idPeriodo']?.toString();
      }
      if (_formData.containsKey('idCurso')) {
        _selectedCursoId = _formData['idCurso']?.toString();
      }
    }
  }

  @override
  void dispose() {
    _codigo.dispose();
    _nome.dispose();
    _ch.dispose();
    _periodo.dispose();
    _idCurso.dispose();
    super.dispose();
  }
  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    final disciplinaList = Provider.of<DisciplinaList>(context, listen: false);
    final codigo = _formData['codigo']?.toString();

    // ⚠️ Recuperar idDisciplina, se estiver editando
    final idDisciplina = _formData['idDisciplina']?.toString();

    // ✅ Verificação de unicidade
    final codigoExiste = disciplinaList.items.any((disciplina) {
      final mesmoId = disciplina.idDisciplina == idDisciplina;  // Se for o mesmo, pode.
      return disciplina.codigo == codigo && !mesmoId;
    });

    if (codigoExiste) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Código duplicado'),
          content: const Text('Já existe um disciplina com este código.'),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      );
      return;  // Impede o envio.
    }

    setState(() => _isLoading = true);

    try {
      await disciplinaList.saveDisciplina(_formData);
      Navigator.of(context).pop();
    } catch (error, stackTrace) {
      print('❌ ERRO AO SALVAR DISCIPLINA: $error');
      print(stackTrace);
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro!'),
          content: const Text('Ocorreu um erro ao salvar o disciplina.'),
          actions: [
            TextButton(
              child: const Text('Ok'),
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
        title: const Text('Cadastro de Disciplina'),
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
                      initialValue: _formData['codigo']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Código do Disciplina',
                        hintText: 'Ex: 123',
                      ),
                      focusNode: _codigo,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submitForm(),
                      onSaved: (codigo) => _formData['codigo'] = codigo ?? '',
                      validator: (_codigo) {
                        final codigo = _codigo ?? '';
                        if (codigo.trim().isEmpty) {
                          return 'Id é obrigatório';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['nome']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Nome do Disciplina',
                        hintText: 'Ex: Nome',
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
                      initialValue: _formData['ch']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'CH do Período',
                        hintText: 'Ex: 30-60',
                      ),
                      focusNode: _ch,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submitForm(),
                      onSaved: (ch) => _formData['ch'] = ch ?? '',
                      validator: (_ch) {
                        final ch = _ch ?? '';
                        if (ch.trim().isEmpty) {
                          return 'CH é obrigatório';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Consumer<PeriodoList>(
                      builder: (ctx, periodoList, child) {
                        if (periodoList.items.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return DropdownButtonFormField<String>(
                          value: _selectedPeriodoId,
                          decoration: const InputDecoration(
                            labelText: 'Período',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          items: periodoList.items.map((periodo) {
                            return DropdownMenuItem<String>(
                              value: periodo.nome,
                              child: Text(
                                periodo.nome,
                                style: const TextStyle(fontSize: 16),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedPeriodoId = value;
                            });
                            _formData['idPeriodo'] = value ?? '';
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Selecione um período';
                            }
                            return null;
                          },
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          hint: const Text('Selecione um período'),
                        );
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
                          value: _selectedPeriodoId,
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
                              value: curso.nome,
                              child: Text(
                                curso.nome,
                                style: const TextStyle(fontSize: 16),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedPeriodoId = value;
                            });
                            _formData['idCurso'] = value ?? '';
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Selecione um curso';
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
                          : const Text('Salvar Disciplina'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}


