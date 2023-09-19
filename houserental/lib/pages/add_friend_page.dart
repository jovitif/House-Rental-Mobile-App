import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddFriendPage extends StatefulWidget {
  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  List<DocumentSnapshot> allUsers = [];

  void getAllUsers() async {
    final userCollection = FirebaseFirestore.instance.collection('users');
    final querySnapshot = await userCollection.get();

    setState(() {
      allUsers = querySnapshot.docs;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos os Usuários'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (allUsers.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: allUsers.length,
                  itemBuilder: (BuildContext context, int index) {
                    final userData =
                        allUsers[index].data() as Map<String, dynamic>;
                    final username =
                        userData['username']; // Substitua pelo campo correto.
                    final userId = allUsers[index].id;

                    return ListTile(
                      title: Text(username ?? 'Nome de Usuário'),
                      subtitle: Text('ID: $userId'),
                    );
                  },
                ),
              ),
            if (allUsers.isEmpty) Text('Nenhum usuário encontrado.'),
          ],
        ),
      ),
    );
  }
}
