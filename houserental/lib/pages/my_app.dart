import 'package:flutter/material.dart';
import 'package:houserental/pages/add_friend_page.dart';
import 'package:houserental/pages/edit_property_page.dart';
import 'package:houserental/pages/login_form.dart';
import 'package:houserental/pages/my_proprietes_page.dart';
import 'package:houserental/pages/proprietes_page.dart';
import 'package:houserental/pages/register_form.dart';
import '../models/usuario.dart';
import 'add_property_page.dart';
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
        '/tela_usuario': (context) => UserProfilePage(),
        '/add_property': (context) => AddPropertyPage(),
        '/my_properties': (context) => MyPropertiesPage(),
        '/add_friend': (context) => AddFriendPage(),
        '/all_properties': (context) => PropertiesPage(),
        '/edit_property': (context) => EditPropertyPage(
            propertyId: ''), // Substitua com a lógica para obter o propertyId
      },
      home: LoginPage(),
    );
  }
}
