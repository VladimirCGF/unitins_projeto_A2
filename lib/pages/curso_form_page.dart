import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitins_projeto/models/curso_list.dart';

import '../models/curso.dart';

class CursoFormPage extends StatefulWidget {
  const CursoFormPage({Key? key}) : super(key: key);

  @override
  State<CursoFormPage> createState() => _CursoFormPageState();
}

class _CursoFormPageState extends State<CursoFormPage> {
  final _nome = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final curso = arg as Curso;
        _formData['idCurso'] = curso.idCurso;
        _formData['nome'] = curso.nome;
      }
    }
  }

  @override
  void dispose() {
    _nome.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    setState(() => _isLoading = true);

    try {
      await Provider.of<CursoList>(
        context,
        listen: false,
      ).saveCurso(_formData);

      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro!'),
          content: const Text('Ocorreu um erro ao salvar o curso.'),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
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
                    // Campo Nome
                    TextFormField(
                      initialValue: _formData['nome']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Nome do Curso',
                        hintText: 'Ex: TI, Eng',
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
                    // Botão de Salvar
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Salvar Curso'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
