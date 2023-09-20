import 'package:flutter/material.dart';
import 'package:houserental/components/classic_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // O usuário fez login com sucesso
      User? user = userCredential.user;
      print('Usuário logado: ${user?.uid}');
    } catch (e) {
      print('Erro ao fazer login: $e');
      // Trate o erro conforme necessário
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Adicione um SingleChildScrollView
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 40.0, bottom: 20.0, left: 20.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/toplogo.svg',
                      width: 40.0,
                      height: 40.0,
                    ),
                  ],
                ),
                SizedBox(height: 80.0),
                Image.asset(
                    'assets/login.png',
                  width: 200.0,
                  height: 200.0,
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller:
                      emailController, // Use o controller para obter o valor
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller:
                      passwordController, // Use o controller para obter o valor
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Senha',
                  ),
                ),
                SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Esqueceu a senha?'),
                  ),
                ),
                SizedBox(height: 20.0),
                ClassicButton(
                  text: 'Entrar',
                  onPressed: () async {
                    // Obtenha os valores do campo de texto
                    String email = emailController.text;
                    String password = passwordController.text;

                    // Chame a função de login
                    await loginUser(email, password);

                    // Saia da tela de login e vá para a tela do usuário
                    Navigator.pop(context); // Isso irá fechar a tela de login
                    Navigator.pushNamed(context, '/tela_usuario');
                  },
                ),
                SizedBox(height: 40.0),
                Column(
                  children: [
                    Text('Não tem uma conta?'),
                    SizedBox(height: 5.0),
                    GestureDetector(
                      onTap: () {
                        // Navegar para a tela de registro
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        'Crie uma conta',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
