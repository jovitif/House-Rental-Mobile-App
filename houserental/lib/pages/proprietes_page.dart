import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:houserental/pages/property_details_page.dart';

class PropertiesPage extends StatefulWidget {
  @override
  _PropertiesPageState createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage> {
  late List<QueryDocumentSnapshot> userProperties = [];

  Future<void> loadAllProperties() async {
    final allPropertiesSnapshot =
        await FirebaseFirestore.instance.collection('properties').get();
    setState(() {
      userProperties = allPropertiesSnapshot.docs;
    });
  }

  Future<void> deleteProperty(String propertyId) async {
    try {
      await FirebaseFirestore.instance
          .collection('properties')
          .doc(propertyId)
          .delete();
      // Recarregue a lista de imóveis após excluir um imóvel.
      await loadAllProperties();
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
    loadAllProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos os Imóveis'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'Lista de Imóveis:',
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
                      final imageUrl = property['imageUrl'];
                      final ownerId = property['ownerId'];

                      return InkWell(
                        onTap: () {
                          viewPropertyDetails(propertyId);
                        },
                        child: ListTile(
                          title: Text(property['title']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Preço: ${property['price']}'),
                              FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(ownerId)
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    final userData = snapshot.data?.data()
                                        as Map<String, dynamic>;
                                    final username = userData['username'] ??
                                        'Nome não informado';
                                    return Text(
                                        'Nome do Proprietário: $username');
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              ),
                            ],
                          ),
                          leading: imageUrl != null
                              ? Image.network(imageUrl)
                              : Icon(Icons.image),
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
