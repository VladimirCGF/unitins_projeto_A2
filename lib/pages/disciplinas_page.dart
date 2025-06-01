import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitins_projeto/components/disciplina_item.dart';
import 'package:unitins_projeto/models/disciplina_list.dart';

import '../components/app_drawer.dart';
import '../utils/app_routes.dart';

class DisciplinaPage extends StatefulWidget {
  const DisciplinaPage({Key? key}) : super(key: key);

  @override
  State<DisciplinaPage> createState() => _DisciplinaPageState();
}

class _DisciplinaPageState extends State<DisciplinaPage> {
  bool _isLoading = false;
  bool _isInit = true;

  Future<void> _refreshDisciplinas(BuildContext context) async {
    return Provider.of<DisciplinaList>(
      context,
      listen: false,
    ).loadDisciplinas();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Carrega os disciplinas apenas na primeira vez
    if (_isInit) {
      setState(() => _isLoading = true);
      _refreshDisciplinas(context).then((_) {
        setState(() => _isLoading = false);
      }).catchError((error) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar disciplinas: $error')),
        );
      });
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DisciplinaList disciplinas = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Disciplinas'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.of(context).pushNamed(
                AppRoutes.disciplinaForm,
              );
              if (result == true) {
                setState(() => _isLoading = true);
                _refreshDisciplinas(context).then((_) {
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
              onRefresh: () => _refreshDisciplinas(context),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: disciplinas.itemsCount,
                  itemBuilder: (ctx, i) => Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          // Abre o formulário para edição
                          final result = await Navigator.of(context).pushNamed(
                            AppRoutes.disciplinaForm,
                            arguments: disciplinas.items[i],
                          );

                          // Recarrega após edição
                          if (result == true) {
                            setState(() => _isLoading = true);
                            _refreshDisciplinas(context).then((_) {
                              setState(() => _isLoading = false);
                            });
                          }
                        },
                        child: DisciplinaItem(disciplinas.items[i]),
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
