import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitins_projeto/components/periodo_item.dart';
import 'package:unitins_projeto/models/periodo_list.dart';

import '../components/app_drawer.dart';
import '../utils/app_routes.dart';

class PeriodosPage extends StatefulWidget {
  const PeriodosPage({Key? key}) : super(key: key);

  @override
  State<PeriodosPage> createState() => _PeriodosPageState();
}

class _PeriodosPageState extends State<PeriodosPage> {
  bool _isLoading = false;
  bool _isInit = true;

  Future<void> _refreshPeriodos(BuildContext context) async {
    return Provider.of<PeriodoList>(
      context,
      listen: false,
    ).loadPeriodos();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Carrega os períodos apenas na primeira vez
    if (_isInit) {
      setState(() => _isLoading = true);
      _refreshPeriodos(context).then((_) {
        setState(() => _isLoading = false);
      }).catchError((error) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar períodos: $error')),
        );
      });
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final PeriodoList products = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Periodos'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.of(context).pushNamed(
                AppRoutes.periodoForm,
              );
              if (result == true) {
                setState(() => _isLoading = true);
                _refreshPeriodos(context).then((_) {
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
              onRefresh: () => _refreshPeriodos(context),
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
                            AppRoutes.periodoForm,
                            arguments: products.items[i],
                          );

                          // Recarrega após edição
                          if (result == true) {
                            setState(() => _isLoading = true);
                            _refreshPeriodos(context).then((_) {
                              setState(() => _isLoading = false);
                            });
                          }
                        },
                        child: PeriodoItem(products.items[i]),
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
