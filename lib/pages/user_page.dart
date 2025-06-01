import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitins_projeto/components/disciplina_item.dart';
import 'package:unitins_projeto/components/user_item.dart';
import 'package:unitins_projeto/models/disciplina_list.dart';
import 'package:unitins_projeto/models/user_list.dart';

import '../components/app_drawer.dart';
import '../utils/app_routes.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool _isLoading = false;
  bool _isInit = true;

  Future<void> _refreshUsers(BuildContext context) async {
    return Provider.of<UserList>(
      context,
      listen: false,
    ).loadUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() => _isLoading = true);
      _refreshUsers(context).then((_) {
        setState(() => _isLoading = false);
      }).catchError((error) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar users: $error')),
        );
      });
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserList users = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar User'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.of(context).pushNamed(
                AppRoutes.userForm,
              );
              if (result == true) {
                setState(() => _isLoading = true);
                _refreshUsers(context).then((_) {
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
        onRefresh: () => _refreshUsers(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: users.itemsCount,
            itemBuilder: (ctx, i) => Column(
              children: [
                InkWell(
                  onTap: () async {
                    // Abre o formulário para edição
                    final result = await Navigator.of(context).pushNamed(
                      AppRoutes.userForm,
                      arguments: users.items[i],
                    );
                    // Recarrega após edição
                    if (result == true) {
                      setState(() => _isLoading = true);
                      _refreshUsers(context).then((_) {
                        setState(() => _isLoading = false);
                      });
                    }
                  },
                  child: UserItem(users.items[i]),
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
