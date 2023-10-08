import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddFriendPage extends StatefulWidget {
  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  List<DocumentSnapshot> allUsers = [];
  User? currentUser;

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
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.only(top: 40.0, bottom: 20.0, left: 20.0, right: 20.0),
        child: Column(
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
            const SizedBox(height: 20.0),
            if (allUsers.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: allUsers.length,
                  itemBuilder: (BuildContext context, int index) {
                    final userData =
                        allUsers[index].data() as Map<String, dynamic>;
                    final username = userData['username'];
                    final profileImageUrl = userData['profileImageUrl'];

                    // Exclua o usuário atual da lista
                    if (currentUser != null &&
                        currentUser!.uid == allUsers[index].id) {
                      return SizedBox.shrink();
                    }

                    return ListTile(
                      leading: profileImageUrl != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(profileImageUrl),
                              radius: 24.0,
                            )
                          : Icon(Icons.person, size: 48.0),
                      title: Text(username ?? 'Nome de Usuário'),
                      subtitle: Text('ID: ${allUsers[index].id}'),
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
