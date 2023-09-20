import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditPropertyPage extends StatefulWidget {
  final String propertyId;

  EditPropertyPage({required this.propertyId});

  @override
  _EditPropertyPageState createState() => _EditPropertyPageState();
}

class _EditPropertyPageState extends State<EditPropertyPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController specificationController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  List<String> propertyImages = [];
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadPropertyDetails();
  }

  Future<void> loadPropertyDetails() async {
    try {
      final propertyDoc = await FirebaseFirestore.instance
          .collection('properties')
          .doc(widget.propertyId)
          .get();

      if (propertyDoc.exists) {
        final propertyData = propertyDoc.data() as Map<String, dynamic>;

        setState(() {
          titleController.text = propertyData['title'] ?? '';
          priceController.text = propertyData['price'] ?? '';
          descriptionController.text = propertyData['description'] ?? '';
          specificationController.text = propertyData['specification'] ?? '';
          statusController.text = propertyData['status'] ?? '';
          typeController.text = propertyData['type'] ?? '';
          locationController.text = propertyData['location'] ?? '';

          if (propertyData['images'] != null) {
            propertyImages = List<String>.from(propertyData['images']);
          }
        });
      }
    } catch (e) {
      print('Erro ao carregar detalhes do imóvel: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar detalhes do imóvel: $e'),
        ),
      );
    }
  }

  Future<void> addImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageFile = pickedFile.path;
      final storage = FirebaseStorage.instance;
      final Reference storageRef =
          storage.ref().child('property_images/${DateTime.now()}.jpg');

      UploadTask uploadTask = storageRef.putFile(File(imageFile));
      await uploadTask.whenComplete(() async {
        final imageUrl = await storageRef.getDownloadURL();
        setState(() {
          propertyImages.add(imageUrl);
        });
      });
    }
  }

  void removeImage(int index) {
    setState(() {
      propertyImages.removeAt(index);
    });
  }

  void updateProperty() async {
    try {
      await FirebaseFirestore.instance
          .collection('properties')
          .doc(widget.propertyId)
          .update({
        'title': titleController.text,
        'price': priceController.text,
        'description': descriptionController.text,
        'specification': specificationController.text,
        'status': statusController.text,
        'type': typeController.text,
        'location': locationController.text,
        'images': propertyImages,
      });

      // Após a atualização, você pode navegar de volta para a página de detalhes da propriedade.
      Navigator.pop(context);
    } catch (e) {
      print('Erro ao atualizar imóvel: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar imóvel: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Propriedade'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Editar Detalhes da Propriedade',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
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
              decoration: InputDecoration(labelText: 'Status'),
            ),
            TextField(
              controller: typeController,
              decoration: InputDecoration(labelText: 'Tipo'),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Localização'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Imagens da Propriedade',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (propertyImages.isNotEmpty)
              Column(
                children: [
                  for (int index = 0; index < propertyImages.length; index++)
                    Row(
                      children: [
                        Expanded(
                          child: Image.network(
                            propertyImages[index],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            removeImage(index);
                          },
                        ),
                      ],
                    ),
                  SizedBox(height: 20.0),
                ],
              ),
            ElevatedButton(
              onPressed: () {
                addImage();
              },
              child: Text('Adicionar Foto'),
            ),
            ElevatedButton(
              onPressed: () {
                updateProperty();
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
