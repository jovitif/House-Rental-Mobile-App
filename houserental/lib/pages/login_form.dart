import 'package:flutter/material.dart';
import 'package:houserental/components/classic_button.dart';

class LoginPage extends StatelessWidget {
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
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
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
                text: 'Entrar', // Texto do botão
                onPressed: () {
                  // Lógica de botão
                  Navigator.pushNamed(context, '/home');
                },
              ),
              SizedBox(height: 40.0), // Aumentando o espaçamento
              Text('Não tem uma conta?'),
              SizedBox(height: 5.0), // Aumentando o espaçamento
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
