import 'package:flutter/material.dart';
import 'package:houserental/components/classic_button.dart';

class RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/Frame.png'),
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
              SizedBox(height: 20.0),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Repetir a senha',
                ),
              ),
              SizedBox(height: 10.0),

              SizedBox(height: 50.0),
              ClassicButton(
                text: 'Registrar', // Texto do botão
                onPressed: () {
                  // Lógica de botão
                },
              ),
              SizedBox(height: 40.0), // Aumentando o espaçamento
              Text('Já tem uma conta?'),
              SizedBox(height: 5.0), // Aumentando o espaçamento
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  'Entrar',
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
