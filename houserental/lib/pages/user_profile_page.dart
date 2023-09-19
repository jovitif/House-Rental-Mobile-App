import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  User? user;
  late List<QueryDocumentSnapshot> userProperties;

  Future<void> getUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        user = currentUser;
      });
      await loadUserProperties(currentUser.uid);
    }
  }

  Future<void> loadUserProperties(String userId) async {
    final userPropertiesSnapshot = await FirebaseFirestore.instance
        .collection('properties')
        .where('ownerId', isEqualTo: userId)
        .get();
    setState(() {
      userProperties = userPropertiesSnapshot.docs;
    });
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pop();
  }

  void navigateToAddProperty() {
    // Navegue para a página de cadastro de imóveis quando o botão for pressionado
    Navigator.pushNamed(context, '/add_property');
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil do Usuário'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (user != null)
                Column(
                  children: [
                    Text(
                      'Nome de Usuário: ${user!.displayName ?? "Não informado"}',
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Email: ${user!.email ?? "Não informado"}',
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ElevatedButton(
                onPressed: () {
                  navigateToAddProperty();
                },
                child: Text('Adicionar Imóvel'),
              ),
              SizedBox(height: 20.0),
              Text(
                'Meus Imóveis:',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              if (userProperties.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: userProperties.length,
                    itemBuilder: (BuildContext context, int index) {
                      final property =
                          userProperties[index].data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(property['title']),
                        subtitle: Text('Preço: ${property['price']}'),
                        // Adicione mais informações aqui, conforme necessário.
                      );
                    },
                  ),
                ),
              if (userProperties.isEmpty) Text('Nenhum imóvel encontrado.'),
            ],
          ),
        ),
      ),
    );
  }
}
