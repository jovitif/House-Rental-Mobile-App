import 'package:flutter/material.dart';
import 'package:houserental/components/classic_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/login.png'),
              SizedBox(height: 40.0),
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
              SizedBox(height: 50.0),
              ClassicButton(
                text: 'Entrar',
                onPressed: () {
                  // Obtenha os valores do campo de texto
                  String email = emailController.text;
                  String password = passwordController.text;

                  // Chame a função de login
                  loginUser(email, password);

                  // Lógica de botão
                  Navigator.pushNamed(context, '/tela_usuario');
                },
              ),
              SizedBox(height: 40.0),
              Text('Não tem uma conta?'),
              SizedBox(height: 5.0),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text(
                  'Crie uma conta',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
