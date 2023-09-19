import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  Future<void> saveProperty() async {
    // Verifique se todos os campos necessários estão preenchidos
    if (titleController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        specificationController.text.isEmpty ||
        statusController.text.isEmpty ||
        typeController.text.isEmpty ||
        locationController.text.isEmpty) {
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
          'status': statusController.text,
          'type': typeController.text,
          'location': locationController.text,
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
