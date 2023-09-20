import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  User? user;
  GoogleMapController? mapController;
  LatLng? currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    user = FirebaseAuth.instance.currentUser;
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });

    // Mover a câmera do mapa para a nova posição atual
    _moveCameraToCurrentPosition();
  }

  void _moveCameraToCurrentPosition() {
    if (mapController != null && currentPosition != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentPosition!,
            zoom: 15.0,
          ),
        ),
      );
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // SVG "toplogo" centrado
            SvgPicture.asset(
              'assets/toplogo.svg',
              width: 40.0,
              height: 40.0,
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20.0),
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(user!.uid)
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            final userData =
                            snapshot.data?.data() as Map<String, dynamic>;
                            final profileImageUrl =
                            userData['profileImageUrl'];
                            return CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey,
                              child: ClipOval(
                                child: profileImageUrl != null
                                    ? Image.network(
                                  profileImageUrl,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                )
                                    : Image.asset(
                                  'assets/default_avatar.png',
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                      SizedBox(height: 5.0),
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
                    ],
                  ),
                ),
                SizedBox(width: 20.0),
                SizedBox(height: 20.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                      SizedBox(height: 10.0),
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
                      SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/all_properties');
                        },
                        child: Text('Ver Todos os Imóveis'),
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Color(0xFF0D47A1)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50.0),
            Container(
              height: 350.0,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: currentPosition ?? LatLng(0, 0),
                  zoom: 15.0,
                ),
                onMapCreated: (GoogleMapController controller) {
                  setState(() {
                    mapController = controller;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(right: 20.0, bottom: 20.0, left: 20.0),
        child: ElevatedButton(
          onPressed: () {
            logout();
          },
          child: Text('Logout'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xFF0D47A1)),
          ),
        ),
      ),
    );
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
}
