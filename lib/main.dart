import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitins_projeto/pages/CourseSelectionScreen.dart';
import 'package:unitins_projeto/pages/auth_or_home_page.dart';
import 'package:unitins_projeto/pages/boletim_academico_app.dart';
import 'package:unitins_projeto/utils/app_routes.dart';

// import 'firebase_options.dart';
import 'models/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          AppRoutes.courseSelectionScreen: (ctx) => const CourseSelectionScreen(),
          AppRoutes.boletimAcademicoApp: (ctx) => const BoletimAcademicoApp(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
