import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:houserental/pages/property_details_page.dart'; // Importe a página PropertyDetailsPage

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  User? user;
  GoogleMapController? mapController;
  LatLng? currentPosition;
  Set<Marker> propertyMarkers = Set<Marker>();
  late BitmapDescriptor customRedMarkerIcon; // Ícone personalizado vermelho

  @override
  void initState() {
    super.initState();
    _getCurrentUserData();
    user = FirebaseAuth.instance.currentUser;
    _getCurrentLocation();
    _createCustomRedMarkerIcon(); // Crie o ícone personalizado vermelho
    // Carregar todas as propriedades quando a tela é inicializada
    loadAllProperties();
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  Future<void> _getCurrentUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final address = userDoc.get('city');

      if (address != null) {
        _getCurrentLocation(address);
      } else {
        // Trate o caso em que o endereço é nulo (por exemplo, mostrando uma mensagem ao usuário)
      }
    }
  }

  Future<void> _getCurrentLocation([String? address]) async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final status = await Geolocator.requestPermission();
      if (status == LocationPermission.denied) {
        return;
      }
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });

    if (address != null) {
      _moveCameraToCurrentPosition();
    }
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

  Future<void> _createCustomRedMarkerIcon() async {
    // Carregue o ícone personalizado vermelho
    final ByteData data =
        await rootBundle.load('assets/pino-de-localizacao.png');
    final List<int> bytes = data.buffer.asUint8List();
    customRedMarkerIcon = BitmapDescriptor.fromBytes(Uint8List.fromList(bytes));
  }

  void navigateToPropertyDetails(String propertyId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyDetailsPage(
          propertyId: propertyId,
        ),
      ),
    );
  }

  Future<void> loadAllProperties() async {
    print('Antes da consulta');
    final querySnapshot =
        await FirebaseFirestore.instance.collection('properties').get();
    print('Depois da consulta');
    print('Número de documentos retornados: ${querySnapshot.size}');

    for (final doc in querySnapshot.docs) {
      final propertyData = doc.data() as Map<String, dynamic>;
      final latitude = propertyData['latitude'] as double?;
      final longitude = propertyData['longitude'] as double?;
      final location = propertyData['location'] as String?;

      if (latitude != null && longitude != null && location != null) {
        final marker = Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: 'Localização',
            snippet: location,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor
              .hueGreen), // Use o ícone verde para as propriedades
          onTap: () {
            // Lida com o toque no marcador de propriedade
            // Você pode navegar para a página de detalhes do imóvel aqui
            navigateToPropertyDetails(doc.id);
          },
        );

        setState(() {
          propertyMarkers.add(marker);
        });
      }
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
                            .doc(user?.uid)
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            final userData =
                                snapshot.data?.data() as Map<String, dynamic>;
                            final profileImageUrl = userData['profileImageUrl'];
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
                        user?.displayName ?? 'Não informado',
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
                        user?.email ?? 'Não informado',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20.0),
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

            // Mapa para mostrar a localização atual e marcadores de propriedades
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
                markers: {
                  if (currentPosition != null)
                    Marker(
                      markerId: MarkerId('current_location'),
                      position: currentPosition!,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueAzure,
                      ), // Pino azul para a localização atual
                      onTap: () {
                        // Lida com o toque no marcador da localização atual, se necessário
                      },
                    ),
                  // Adicione os marcadores de propriedades aqui
                  ...propertyMarkers,
                },
                compassEnabled: true,
                onTap: (LatLng latLng) {
                  // Manipular o toque no mapa, se necessário
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
