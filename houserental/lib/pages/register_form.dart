import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:houserental/components/classic_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  File? profileImage;

  Future<void> registerUser(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;
    String repeatPassword = repeatPasswordController.text;
    String username = usernameController.text;

    if (password != repeatPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('As senhas não coincidem.'),
        ),
      );
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        final userId = user.uid;

        await user.updateProfile(displayName: username);

        await uploadProfileImage(userId);

        Navigator.pushNamed(context, '/tela_usuario');
      } else {
        // Handle the case where no user is logged in or the user creation failed.
      }
    } catch (e) {
      print('Erro ao registrar usuário: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao registrar usuário: $e'),
        ),
      );
    }
  }

  Future<void> uploadProfileImage(String userId) async {
    if (profileImage != null) {
      try {
        final ref = FirebaseStorage.instance.ref('profile_images/$userId.jpg');
        await ref.putFile(profileImage!);
        final imageUrl = await ref.getDownloadURL();

        // Atualize o documento do usuário no Firestore com a URL da imagem do perfil.
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'profileImageUrl': imageUrl,
        });
      } catch (e) {
        print('Erro ao fazer upload da imagem: $e');
      }
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
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
              Image.asset('assets/Frame.png'),
              SizedBox(height: 40.0),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Senha',
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: repeatPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Repetir a senha',
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Nome de Usuário',
                ),
              ),
              SizedBox(height: 10.0),
              if (profileImage != null)
                Image.file(
                  profileImage!,
                  width: 100.0,
                  height: 100.0,
                ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  pickImage();
                },
                child: Text('Selecionar Imagem'),
              ),
              SizedBox(height: 50.0),
              ClassicButton(
                text: 'Registrar',
                onPressed: () {
                  registerUser(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
