import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                      return InkWell(
                        onTap: () {
                          viewPropertyDetails(propertyId);
                        },
                        child: ListTile(
                          title: Text(property['title']),
                          subtitle: Text('Preço: ${property['price']}'),
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

class PropertyDetailsPage extends StatelessWidget {
  final String propertyId;

  PropertyDetailsPage({required this.propertyId});

  @override
  Widget build(BuildContext context) {
    // Aqui você pode carregar os detalhes completos do imóvel com base no ID.
    // Você pode acessar o Firestore para obter os detalhes e exibi-los nesta página.

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Imóvel'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detalhes do Imóvel:',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              // Exiba os detalhes completos do imóvel aqui com base no ID.
            ],
          ),
        ),
      ),
    );
  }
}
