import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitins_projeto/components/curso_item.dart';
import 'package:unitins_projeto/models/curso_list.dart';

import '../components/app_drawer.dart';
import '../utils/app_routes.dart';

class CursosPage extends StatefulWidget {
  const CursosPage({Key? key}) : super(key: key);

  @override
  State<CursosPage> createState() => _CursosPageState();
}

class _CursosPageState extends State<CursosPage> {
  bool _isLoading = false;
  bool _isInit = true;

  Future<void> _refreshCursos(BuildContext context) async {
    return Provider.of<CursoList>(
      context,
      listen: false,
    ).loadCursos();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Carrega os cursos apenas na primeira vez
    if (_isInit) {
      setState(() => _isLoading = true);
      _refreshCursos(context).then((_) {
        setState(() => _isLoading = false);
      }).catchError((error) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar cursos: $error')),
        );
      });
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final CursoList cursos = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Cursos'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.of(context).pushNamed(
                AppRoutes.cursoForm,
              );
              if (result == true) {
                setState(() => _isLoading = true);
                _refreshCursos(context).then((_) {
                  setState(() => _isLoading = false);
                });
              }
            },
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _refreshCursos(context),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: cursos.itemsCount,
                  itemBuilder: (ctx, i) => Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          // Abre o formulário para edição
                          final result = await Navigator.of(context).pushNamed(
                            AppRoutes.cursoForm,
                            arguments: cursos.items[i],
                          );

                          // Recarrega após edição
                          if (result == true) {
                            setState(() => _isLoading = true);
                            _refreshCursos(context).then((_) {
                              setState(() => _isLoading = false);
                            });
                          }
                        },
                        child: CursoItem(cursos.items[i]),
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
