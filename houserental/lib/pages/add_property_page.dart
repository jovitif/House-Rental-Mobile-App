import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPropertyPage extends StatefulWidget {
  @override
  _AddPropertyPageState createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController specificationController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  List<File?> propertyImages = [];
  GoogleMapController? mapController;
  LatLng? selectedLocation;

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void pickImages() async {
    // Implemente a lógica para selecionar e armazenar as imagens do imóvel.
  }

  void updateLocation(LatLng location) async {
    final addresses =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    if (addresses.isNotEmpty) {
      final address = addresses[0];
      final formattedAddress =
          '${address.street}, ${address.locality}, ${address.administrativeArea}, ${address.country}';
      setState(() {
        locationController.text = formattedAddress;
        selectedLocation = location;
      });
    }
  }

  void saveProperty() async {
    // Verifique se todos os campos necessários estão preenchidos
    if (titleController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        specificationController.text.isEmpty ||
        statusController.text.isEmpty ||
        typeController.text.isEmpty ||
        locationController.text.isEmpty ||
        selectedLocation == null) {
      // Exiba uma mensagem de erro ou faça algo para lidar com campos em branco.
      return;
    }

    try {
      // Obtenha o usuário atualmente logado
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Crie um mapa com os dados do imóvel
        final propertyData = {
          'title': titleController.text,
          'price': priceController.text,
          'description': descriptionController.text,
          'specification': specificationController.text,
          'status': statusController.text,
          'type': typeController.text,
          'location': locationController.text,
          'ownerId': user.uid, // Associe o imóvel ao ID do usuário
        };

        // Substitua 'properties' pelo nome da sua coleção no Firestore
        await FirebaseFirestore.instance
            .collection('properties')
            .add(propertyData);

        // Imóvel salvo com sucesso
        // Você pode exibir uma mensagem de sucesso ou navegar para outra página aqui.
      } else {
        // O usuário não está logado; faça algo para lidar com isso.
      }
    } catch (e) {
      // Lidar com erros, como falha ao salvar no Firestore.
      print('Erro ao salvar imóvel: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Imóvel'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Preço'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),
            TextField(
              controller: specificationController,
              decoration: InputDecoration(labelText: 'Especificação'),
            ),
            TextField(
              controller: statusController,
              decoration: InputDecoration(
                  labelText: 'Status (Comprar, Vender, Negociar)'),
            ),
            TextField(
              controller: typeController,
              decoration: InputDecoration(
                  labelText: 'Tipo (Casa, Apartamento, Condomínio)'),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Localização'),
            ),
            if (selectedLocation != null)
              Container(
                height: 200,
                child: GoogleMap(
                  onMapCreated: onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: selectedLocation!,
                    zoom: 15.0,
                  ),
                  markers: Set<Marker>.from([
                    Marker(
                      markerId: MarkerId('selected_location'),
                      position: selectedLocation!,
                    ),
                  ]),
                  onTap: (location) {
                    updateLocation(location);
                  },
                ),
              ),
            ElevatedButton(
              onPressed: () {
                pickImages();
              },
              child: Text('Selecionar Imagens'),
            ),
            ElevatedButton(
              onPressed: () {
                saveProperty();
              },
              child: Text('Salvar Imóvel'),
            ),
          ],
        ),
      ),
    );
  }
}
