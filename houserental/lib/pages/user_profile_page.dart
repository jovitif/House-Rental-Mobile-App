import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void navigateToAddProperty() {
    Navigator.pushNamed(context, '/add_property');
  }

  void navigateToMyProperties() {
    Navigator.pushNamed(context, '/my_properties');
  }

  void navigateToAddFriend() {
    Navigator.pushNamed(context, '/add_friend');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil do Usuário'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (user != null)
                Column(
                  children: [
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user!.uid)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          final userData =
                              snapshot.data?.data() as Map<String, dynamic>;
                          final profileImageUrl = userData['profileImageUrl'];

                          return CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.grey,
                            child: ClipOval(
                              child: profileImageUrl != null
                                  ? Image.network(
                                      profileImageUrl,
                                      width:
                                          160, // Largura e altura da imagem dentro do círculo
                                      height: 160,
                                      fit: BoxFit
                                          .cover, // Ajuste a imagem para cobrir todo o círculo
                                    )
                                  : Image.asset(
                                      'assets/default_avatar.png',
                                      width:
                                          160, // Largura e altura da imagem dentro do círculo
                                      height: 160,
                                      fit: BoxFit
                                          .cover, // Ajuste a imagem para cobrir todo o círculo
                                    ),
                            ),
                          );
                        } else {
                          return CircularProgressIndicator(); // Mostra um indicador de carregamento enquanto a imagem está sendo carregada.
                        }
                      },
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Nome de Usuário:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user!.displayName ?? 'Não informado',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Email:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user!.email ?? 'Não informado',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ElevatedButton(
                onPressed: () {
                  navigateToMyProperties();
                },
                child: Text('Meus Imóveis'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  logout();
                },
                child: Text('Logout'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  navigateToAddFriend();
                },
                child: Text('Adicionar Amigo'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/all_properties');
                },
                child: Text('Ver Todos os Imóveis'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
