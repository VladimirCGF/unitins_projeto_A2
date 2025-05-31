import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitins_projeto/models/curso_list.dart';
import 'package:unitins_projeto/pages/auth_or_home_page.dart';
import 'package:unitins_projeto/pages/curso_form_page.dart';
import 'package:unitins_projeto/pages/cursos_page.dart';
import 'package:unitins_projeto/pages/periodo_form_page.dart';
import 'package:unitins_projeto/pages/periodos_page.dart';
import 'package:unitins_projeto/utils/app_routes.dart';

import 'models/auth.dart';
import 'models/periodo_list.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(MyApp());
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
          AppRoutes.periodos: (ctx) => const PeriodosPage(),
          AppRoutes.periodoForm: (ctx) => const PeriodoFormPage(),
          AppRoutes.cursos: (ctx) => const CursosPage(),
          AppRoutes.cursoForm: (ctx) => const CursoFormPage(),
          // AppRoutes.courseSelectionScreen: (ctx) =>
          //     const CourseSelectionScreen(),
          // AppRoutes.boletimAcademicoApp: (ctx) => const BoletimAcademicoApp(),
          // AppRoutes.disciplinaForm: (ctx) => const DisciplinaFormPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (_) => Auth(),
//         ),
//         ChangeNotifierProxyProvider<Auth, DisciplinaList>(
//           create: (_) => DisciplinaList(),
//           update: (ctx, auth, previous) {
//             return DisciplinaList(
//               auth.token ?? '',
//               auth.userId ?? '',
//               previous?.items ?? [],
//             );
//           },
//         ),
//       ],
//       child: MaterialApp(
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSwatch().copyWith(
//             primary: Colors.blue,
//             secondary: Colors.deepOrange,
//           ),
//         ),
//         routes: {
//           AppRoutes.authOrHome: (ctx) => const AuthOrHomePage(),
//           AppRoutes.courseSelectionScreen: (ctx) =>
//               const CourseSelectionScreen(),
//           AppRoutes.boletimAcademicoApp: (ctx) => const BoletimAcademicoApp(),
//           AppRoutes.disciplinaForm: (ctx) => const DisciplinaFormPage(),
//         },
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:provider/provider.dart';
//
//
// import 'firebase_options.dart';

// import 'services/boletim_service.dart';
// import 'services/curso_service.dart';
//
// import 'screens/auth_or_home_page.dart';
// import 'screens/boletim_screen.dart';
// import 'screens/grade_curricular_screen.dart';
// import 'screens/rematricula_screen.dart';
// import 'screens/situacao_academica_screen.dart';
// import 'screens/analise_curricular_screen.dart';
// import 'utils/app_routes.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthService()),
//         ChangeNotifierProxyProvider<AuthService, BoletimService>(
//           create: (_) => BoletimService(),
//           update: (_, auth, previous) => BoletimService(
//             token: auth.token,
//             userId: auth.userId,
//             boletins: previous?.boletins ?? [],
//           ),
//         ),
//         ChangeNotifierProxyProvider<AuthService, CursoService>(
//           create: (_) => CursoService(),
//           update: (_, auth, previous) => CursoService(
//             token: auth.token,
//             cursos: previous?.cursos ?? [],
//           ),
//         ),
//       ],
//       child: MaterialApp(
//         title: 'App Acadêmico',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSwatch().copyWith(
//             primary: Colors.blue,
//             secondary: Colors.green,
//           ),
//           fontFamily: 'Lato',
//         ),
//         debugShowCheckedModeBanner: false,
//         routes: {
//           AppRoutes.authOrHome: (_) => const AuthOrHomePage(),
//           AppRoutes.boletim: (_) => const BoletimScreen(),
//           AppRoutes.gradeCurricular: (_) => const GradeCurricularScreen(),
//           AppRoutes.rematricula: (_) => const RematriculaScreen(),
//           AppRoutes.situacaoAcademica: (_) => const SituacaoAcademicaScreen(),
//           AppRoutes.analiseCurricular: (_) => const AnaliseCurricularScreen(),
//         },
//       ),
//     );
//   }
// }
