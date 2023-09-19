import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum Status { comprar, vender, negociar }

enum Tipo { casa, apartamento, condominio }

class AddPropertyPage extends StatefulWidget {
  @override
  _AddPropertyPageState createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController specificationController = TextEditingController();
  Status selectedStatus = Status.comprar; // Valor padrão
  Tipo selectedType = Tipo.casa; // Valor padrão
  final TextEditingController cepController =
      TextEditingController(); // Campo para o CEP
  double? latitude;
  double? longitude;
  String? street;
  String? city;
  String? country;
  List<File?> propertyImages = [];

  @override
  void initState() {
    super.initState();
    // Adicione um ouvinte para o campo de localização
    cepController.addListener(() {
      // Verifique se o campo CEP não está vazio
      if (cepController.text.isNotEmpty) {
        searchLocation(cepController.text);
      }
    });
  }

  void pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    if (pickedImages != null && pickedImages.isNotEmpty) {
      setState(() {
        propertyImages =
            pickedImages.map((pickedFile) => File(pickedFile.path)).toList();
      });
    } else {
      // O usuário não selecionou nenhuma imagem.
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<void> searchLocation(String cep) async {
    // Use a API de geocodificação (por exemplo, OpenCage) para obter informações de localização a partir do CEP.
    final apiKey =
        'e6ba151fbb4b4aacb1c05cd1cd17078c'; // Substitua pela sua chave
    final query = Uri.encodeComponent(cep);

    final response = await http.get(
      Uri.parse(
        'https://api.opencagedata.com/geocode/v1/json?q=$query&key=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List<dynamic>;

      if (results.isNotEmpty) {
        final firstResult = results[0];
        final geometry = firstResult['geometry'];
        final components = firstResult['components'];
        final formattedStreet = components['road'];
        final formattedCity = components['city'];
        final formattedCountry = components['country'];

        setState(() {
          latitude = geometry['lat'];
          longitude = geometry['lng'];
          street = formattedStreet;
          city = formattedCity;
          country = formattedCountry;
        });
      } else {
        // Não foram encontrados resultados.
        // Trate isso de acordo com a sua lógica.
      }
    } else {
      // Erro ao chamar a API OpenCage.
      // Trate isso de acordo com a sua lógica.
    }
  }

  Future<void> saveProperty() async {
    // Verifique se todos os campos necessários estão preenchidos
    if (titleController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        specificationController.text.isEmpty ||
        cepController.text.isEmpty) {
      showSnackBar('Por favor, preencha todos os campos.');
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
          'status':
              statusToString(selectedStatus), // Converter enum para string
          'type': typeToString(selectedType), // Converter enum para string
          'location': cepController.text,
          'latitude': latitude,
          'longitude': longitude,
          'ownerId': user.uid, // Associe o imóvel ao ID do usuário
        };

        // Substitua 'properties' pelo nome da sua coleção no Firestore
        final propertyRef = await FirebaseFirestore.instance
            .collection('properties')
            .add(propertyData);

        // Faça upload das imagens para o Firebase Storage
        for (int i = 0; i < propertyImages.length; i++) {
          final imageFile = propertyImages[i];
          if (imageFile != null) {
            final imageRef = FirebaseStorage.instance
                .ref('property_images/${propertyRef.id}/image$i.jpg');
            await imageRef.putFile(imageFile);
            final imageUrl = await imageRef.getDownloadURL();

            // Associe o URL da imagem ao documento do imóvel
            await propertyRef.update({
              'images': FieldValue.arrayUnion([imageUrl])
            });
          }
        }

        showSnackBar('Imóvel salvo com sucesso.');
        // Você pode exibir uma mensagem de sucesso ou navegar para outra página aqui.
      } else {
        showSnackBar('Você não está logado.');
        // O usuário não está logado; faça algo para lidar com isso.
      }
    } catch (e) {
      showSnackBar('Erro ao salvar imóvel: $e');
      // Lidar com erros, como falha ao salvar no Firestore.
      print('Erro ao salvar imóvel: $e');
    }
  }

  String statusToString(Status status) {
    switch (status) {
      case Status.comprar:
        return 'Comprar';
      case Status.vender:
        return 'Vender';
      case Status.negociar:
        return 'Negociar';
    }
  }

  String typeToString(Tipo type) {
    switch (type) {
      case Tipo.casa:
        return 'Casa';
      case Tipo.apartamento:
        return 'Apartamento';
      case Tipo.condominio:
        return 'Condomínio';
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
            DropdownButtonFormField<Status>(
              value: selectedStatus,
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                });
              },
              items: Status.values
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(statusToString(status)),
                      ))
                  .toList(),
              decoration: InputDecoration(labelText: 'Status'),
            ),
            DropdownButtonFormField<Tipo>(
              value: selectedType,
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
              items: Tipo.values
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(typeToString(type)),
                      ))
                  .toList(),
              decoration: InputDecoration(labelText: 'Tipo'),
            ),
            TextField(
              controller: cepController,
              decoration: InputDecoration(labelText: 'CEP'),
            ),
            if (latitude != null && longitude != null)
              Container(
                height: 300.0,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(latitude!, longitude!),
                    zoom: 15.0, // Ajuste o nível de zoom conforme necessário
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('property_location'),
                      position: LatLng(latitude!, longitude!),
                      infoWindow: InfoWindow(
                        title: cepController.text,
                      ),
                    ),
                  },
                ),
              ),
            if (street != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rua: $street'),
                  Text('Cidade: $city'),
                  Text('País: $country'),
                ],
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
