import 'package:flutter/material.dart';
import 'package:houserental/pages/home.dart';
import 'package:houserental/pages/login_form.dart';
import 'package:houserental/pages/register_form.dart';
//import 'package:musiconnect/pages/music_player.dart';
//import 'package:musiconnect/pages/register_page.dart';

//import 'home_page.dart';
//import 'search_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.lime),
      routes: {
        '/register': (context) => RegisterForm(),
        '/login': (context) => LoginPage(),
        '/home': (context) => Home(),
        // '/search': (context) => SearchPage(),
        // '/shimmer': (context) => MusicPlayerScreen(),
        // Adicione mais rotas aqui conforme necessário
      },
      home: LoginPage(),
    );
  }
}
