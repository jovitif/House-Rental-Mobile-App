import 'package:flutter/material.dart';
import 'package:houserental/pages/adicionar_imovel_screen.dart';
import 'package:houserental/pages/login_form.dart';
import 'package:houserental/pages/register_form.dart';
import '../models/usuario.dart';
import 'add_property_page.dart';
import 'imoveis_screen.dart';
import 'user_profile_page.dart';

class MyApp extends StatelessWidget {
  //Usuario? usuario;
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/register': (context) => RegisterForm(),
        '/login': (context) => LoginPage(),
        '/imoveis': (context) => ImoveisScreen(),
        '/adicionar_imovel': (context) => AdicionarImovelScreen(),
        '/tela_usuario': (context) => UserProfilePage(),
        '/add_property': (context) => AddPropertyPage(),
      },
      home: LoginPage(),
    );
  }
}
