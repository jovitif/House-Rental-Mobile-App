import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:houserental/pages/property_details_page.dart';

import 'add_property_page.dart';

class MyPropertiesPage extends StatefulWidget {
  @override
  _MyPropertiesPageState createState() => _MyPropertiesPageState();
}

class _MyPropertiesPageState extends State<MyPropertiesPage> {
  late List<QueryDocumentSnapshot> userProperties = [];

  Future<void> loadUserProperties() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userId = currentUser.uid;
      final userPropertiesSnapshot = await FirebaseFirestore.instance
          .collection('properties')
          .where('ownerId', isEqualTo: userId)
          .get();
      setState(() {
        userProperties = userPropertiesSnapshot.docs;
      });
    }
  }

  Future<void> deleteProperty(String propertyId) async {
    try {
      await FirebaseFirestore.instance
          .collection('properties')
          .doc(propertyId)
          .delete();
      // Recarregue a lista de imóveis após excluir um imóvel.
      await loadUserProperties();
    } catch (e) {
      print('Erro ao excluir imóvel: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir imóvel: $e'),
        ),
      );
    }
  }

  void viewPropertyDetails(String propertyId) {
    // Navegue para uma nova página de detalhes do imóvel quando o usuário clicar em um item da lista.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyDetailsPage(propertyId: propertyId),
      ),
    );
  }

  void navigateToAddProperty() {
    // Navegue para a página de adicionar imóveis quando o botão "Adicionar Imóvel" for pressionado.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPropertyPage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadUserProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Imóveis'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  navigateToAddProperty();
                },
                child: Text('Adicionar Imóvel'),
              ),
              SizedBox(height: 20.0),
              Text(
                'Imóveis do Usuário:',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              if (userProperties.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: userProperties.length,
                    itemBuilder: (BuildContext context, int index) {
                      final property =
                          userProperties[index].data() as Map<String, dynamic>;
                      final propertyId = userProperties[index].id;
                      final imageUrl = property[
                          'imageUrl']; // Adicione o campo de URL da imagem

                      return InkWell(
                        onTap: () {
                          viewPropertyDetails(propertyId);
                        },
                        child: ListTile(
                          title: Text(property['title']),
                          subtitle: Text('Preço: ${property['price']}'),
                          leading: imageUrl != null
                              ? Image.network(imageUrl) // Exiba a imagem
                              : Icon(Icons
                                  .image), // Ícone padrão se a imagem não estiver disponível
                          // Adicione mais informações aqui, conforme necessário.
                        ),
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
