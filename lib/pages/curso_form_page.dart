import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/curso.dart';
import '../models/curso_list.dart';
import '../models/periodo_list.dart';

class CursoFormPage extends StatefulWidget {
  const CursoFormPage({Key? key}) : super(key: key);

  @override
  State<CursoFormPage> createState() => _CursoFormPageState();
}

class _CursoFormPageState extends State<CursoFormPage> {
  final _codigo = FocusNode();
  final _nome = FocusNode();
  final _ch = FocusNode();
  final _periodo = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  String? _selectedPeriodoId;

  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<PeriodoList>(context, listen: false).loadPeriodos();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final curso = arg as Curso;
        _formData['idCurso'] = curso.idCurso;
        _formData['codigo'] = curso.codigo;
        _formData['nome'] = curso.nome;
        _formData['ch'] = curso.ch;
        _formData['periodo'] = curso.periodo;
      }
      if (_formData.containsKey('idPeriodo')) {
        _selectedPeriodoId = _formData['idPeriodo']?.toString();
      }
    }
  }

  @override
  void dispose() {
    _codigo.dispose();
    _nome.dispose();
    _ch.dispose();
    _periodo.dispose();
    super.dispose();
  }

  // Future<void> _submitForm() async {
  //   final isValid = _formKey.currentState?.validate() ?? false;
  //
  //   if (!isValid) {
  //     return;
  //   }
  //
  //   _formKey.currentState?.save();
  //
  //   setState(() => _isLoading = true);
  //
  //   try {
  //     await Provider.of<CursoList>(
  //       context,
  //       listen: false,
  //     ).saveCurso(_formData);
  //
  //     Navigator.of(context).pop();
  //   } catch (error, stackTrace) {
  //     // Imprime o erro completo no console
  //     print('❌ ERRO AO SALVAR CURSO:');
  //     print('----------------------------------------');
  //     print('Tipo do erro: ${error.runtimeType}');
  //     print('Mensagem: $error');
  //     print('----------------------------------------');
  //     print('STACK TRACE:');
  //     print(stackTrace); // Isso mostra a sequência de chamadas que levou ao erro
  //     print('----------------------------------------');
  //     await showDialog<void>(
  //       context: context,
  //       builder: (ctx) => AlertDialog(
  //         title: const Text('Ocorreu um erro!'),
  //         content: const Text('Ocorreu um erro ao salvar o curso.'),
  //         actions: [
  //           TextButton(
  //             child: const Text('Ok'),
  //             onPressed: () => Navigator.of(context).pop(),
  //           ),
  //         ],
  //       ),
  //     );
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    final cursoList = Provider.of<CursoList>(context, listen: false);
    final codigo = _formData['codigo']?.toString();

    // ⚠️ Recuperar idCurso, se estiver editando
    final idCurso = _formData['idCurso']?.toString();

    // ✅ Verificação de unicidade
    final codigoExiste = cursoList.items.any((curso) {
      final mesmoId = curso.idCurso == idCurso;  // Se for o mesmo, pode.
      return curso.codigo == codigo && !mesmoId;
    });

    if (codigoExiste) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Código duplicado'),
          content: const Text('Já existe um curso com este código.'),
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
      await cursoList.saveCurso(_formData);
      Navigator.of(context).pop();
    } catch (error, stackTrace) {
      print('❌ ERRO AO SALVAR CURSO: $error');
      print(stackTrace);
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro!'),
          content: const Text('Ocorreu um erro ao salvar o curso.'),
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
        title: const Text('Cadastro de Curso'),
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
                        labelText: 'Código do Curso',
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
                        labelText: 'Nome do Curso',
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
                    // Dropdown com lista de Periodo
                    Consumer<PeriodoList>(
                      builder: (ctx, periodoList, child) {
                        // Se os períodos ainda estiverem carregando
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
                    // Botão de Salvar
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Salvar Período'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}


