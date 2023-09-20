import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';

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
      body: Center(
        child: Padding(
          padding:
              EdgeInsets.only(top: 40.0, bottom: 20.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (user != null)
                Column(
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
                    SizedBox(height: 40.0),
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
                                      width: 160,
                                      height: 160,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/default_avatar.png',
                                      width: 160,
                                      height: 160,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      user!.displayName ?? 'Não informado',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
                    ElevatedButton(
                      onPressed: () {
                        navigateToMyProperties();
                      },
                      child: Text('Meus Imóveis'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFF0D47A1)),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        navigateToAddFriend();
                      },
                      child: Text('Adicionar Amigo'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFF0D47A1)),
                      ),
                    ),
                  ],
                ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/all_properties');
                },
                child: Text('Ver Todos os Imóveis'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF0D47A1)),
                ),
              ),
              Spacer(),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      logout();
                    },
                    child: Text('Logout'),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFF0D47A1)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
