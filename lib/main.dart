import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitins_projeto/models/curso_list.dart';
import 'package:unitins_projeto/models/disciplina_boletim_list.dart';
import 'package:unitins_projeto/models/disciplina_list.dart';
import 'package:unitins_projeto/models/user_list.dart';
import 'package:unitins_projeto/pages/auth_or_home_page.dart';
import 'package:unitins_projeto/pages/boletim_form_page.dart';
import 'package:unitins_projeto/pages/boletim_page.dart';
import 'package:unitins_projeto/pages/curso_form_page.dart';
import 'package:unitins_projeto/pages/cursos_page.dart';
import 'package:unitins_projeto/pages/disciplina_boletim_page.dart';
import 'package:unitins_projeto/pages/disciplina_boletim_page_form.dart';
import 'package:unitins_projeto/pages/disciplina_form_page.dart';
import 'package:unitins_projeto/pages/disciplinas_page.dart';
import 'package:unitins_projeto/pages/matricula_page.dart';
import 'package:unitins_projeto/pages/periodo_form_page.dart';
import 'package:unitins_projeto/pages/periodos_page.dart';
import 'package:unitins_projeto/pages/user_form_page.dart';
import 'package:unitins_projeto/pages/user_page.dart';
import 'package:unitins_projeto/utils/app_routes.dart';

import 'firebase_options.dart';
import 'models/auth.dart';
import 'models/boletim_list.dart';
import 'models/periodo_list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      // Firebase já inicializado, ignora o erro
    } else {
      rethrow;
    }
  }

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, UserList>(
          create: (_) => UserList(Auth()),
          update: (ctx, auth, previous) => UserList(
            auth,
            previous?.items ?? [],
          ),
        ),
        ChangeNotifierProxyProvider<Auth, DisciplinaBoletimList>(
          create: (_) => DisciplinaBoletimList(),
          update: (ctx, auth, previous) {
            return DisciplinaBoletimList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, DisciplinaList>(
          create: (_) => DisciplinaList(),
          update: (ctx, auth, previous) {
            return DisciplinaList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, CursoList>(
          create: (_) => CursoList(),
          update: (ctx, auth, previous) {
            return CursoList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, BoletimList>(
          create: (_) => BoletimList(),
          update: (ctx, auth, previous) {
            return BoletimList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, PeriodoList>(
          create: (_) => PeriodoList(),
          update: (ctx, auth, previous) {
            return PeriodoList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.blue,
            secondary: Colors.deepOrange,
          ),
        ),
        routes: {
          AppRoutes.authOrHome: (ctx) => const AuthOrHomePage(),
          AppRoutes.cursos: (ctx) => const CursosPage(),
          AppRoutes.cursoForm: (ctx) => const CursoFormPage(),
          AppRoutes.disciplinas: (ctx) => const DisciplinaPage(),
          AppRoutes.disciplinaForm: (ctx) => const DisciplinaFormPage(),
          AppRoutes.users: (ctx) => const UserPage(),
          AppRoutes.userForm: (ctx) => const UserFormPage(),
          AppRoutes.matricula: (ctx) => const MatriculaPage(),
          AppRoutes.disciplinasBoletins: (ctx) => const DisciplinaBoletimPage(),
          AppRoutes.disciplinasBoletimForm: (ctx) =>
              const DisciplinaBoletimFormPage(),
          AppRoutes.boletins: (ctx) => const BoletimPage(),
          AppRoutes.boletimForm: (ctx) => const BoletimFormPage(),
          AppRoutes.periodos: (ctx) => const PeriodosPage(),
          AppRoutes.periodoForm: (ctx) => const PeriodoFormPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
