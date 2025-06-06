import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitins_projeto/components/disciplina_boletim_item.dart';
import 'package:unitins_projeto/models/disciplina_boletim_list.dart';

import '../components/app_drawer.dart';
import '../utils/app_routes.dart';

class DisciplinaBoletimPage extends StatefulWidget {
  const DisciplinaBoletimPage({Key? key}) : super(key: key);

  @override
  State<DisciplinaBoletimPage> createState() => _DisciplinaBoletimPageState();
}

class _DisciplinaBoletimPageState extends State<DisciplinaBoletimPage> {
  bool _isLoading = false;
  bool _isInit = true;

  Future<void> _refreshDisciplinaBoletim(BuildContext context) async {
    return Provider.of<DisciplinaBoletimList>(
      context,
      listen: false,
    ).loadDisciplinasBoletim();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() => _isLoading = true);
      _refreshDisciplinaBoletim(context).then((_) {
        setState(() => _isLoading = false);
      }).catchError((error) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erro ao carregar Disciplina Boletim: $error')),
        );
      });
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DisciplinaBoletimList products = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Disciplina Boletim'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.of(context).pushNamed(
                AppRoutes.disciplinasBoletimForm,
              );
              if (result == true) {
                setState(() => _isLoading = true);
                _refreshDisciplinaBoletim(context).then((_) {
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
              onRefresh: () => _refreshDisciplinaBoletim(context),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: products.itemsCount,
                  itemBuilder: (ctx, i) => Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          // Abre o formulário para edição
                          final result = await Navigator.of(context).pushNamed(
                            AppRoutes.disciplinasBoletimForm,
                            arguments: products.items[i],
                          );

                          // Recarrega após edição
                          if (result == true) {
                            setState(() => _isLoading = true);
                            _refreshDisciplinaBoletim(context).then((_) {
                              setState(() => _isLoading = false);
                            });
                          }
                        },
                        child: DisciplinaBoletimItem(products.items[i]),
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
