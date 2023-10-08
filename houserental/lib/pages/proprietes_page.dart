import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:houserental/pages/property_details_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PropertiesPage extends StatefulWidget {
  @override
  _PropertiesPageState createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage> {
  late List<QueryDocumentSnapshot> userProperties = [];

  Future<void> loadAllProperties() async {
    try {
      final allPropertiesSnapshot =
          await FirebaseFirestore.instance.collection('properties').get();
      setState(() {
        userProperties = allPropertiesSnapshot.docs;
      });
    } catch (e) {
      print('Erro ao carregar imóveis: $e');
    }
  }

  Future<void> deleteProperty(String propertyId) async {
    try {
      await FirebaseFirestore.instance
          .collection('properties')
          .doc(propertyId)
          .delete();
      await loadAllProperties(); // Recarregue a lista de imóveis após excluir um imóvel.
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
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 20.0),
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
                      final imageUrl = property['images'] != null
                          ? property['images'][0]
                          : null; // Use 'images' em vez de 'images[0]'

                      return InkWell(
                        onTap: () {
                          viewPropertyDetails(propertyId);
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  if (imageUrl != null)
                                    Image.network(
                                      imageUrl,
                                      height: 200.0,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  else
                                    Container(
                                      height: 200.0,
                                      width: double.infinity,
                                      color: Colors.grey,
                                    ),
                                ],
                              ),
                              ListTile(
                                title: Text(property['title']),
                                subtitle:
                                    Text('Preço: ${property['price']} RS'),
                              ),
                            ],
                          ),
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
