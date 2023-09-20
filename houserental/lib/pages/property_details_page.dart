import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PropertyDetailsPage extends StatefulWidget {
  final String propertyId;

  PropertyDetailsPage({required this.propertyId});

  @override
  _PropertyDetailsPageState createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  Map<String, dynamic>? propertyData;
  bool isLoading = true;

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
        setState(() {
          propertyData = propertyDoc.data() as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Imóvel não encontrado.'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erro ao carregar detalhes do imóvel: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar detalhes do imóvel: $e'),
        ),
      );
    }
  }

  Future<void> deleteProperty(String propertyId) async {
    try {
      await FirebaseFirestore.instance
          .collection('properties')
          .doc(propertyId)
          .delete();

      // Após a exclusão, navegue de volta para a página anterior.
      Navigator.pop(context);
    } catch (e) {
      print('Erro ao excluir imóvel: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir imóvel: $e'),
        ),
      );
    }
  }

  void editProperty(String propertyId) {
    // Implemente a lógica de edição aqui, por exemplo, navegue para uma página de edição.
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => EditPropertyPage(propertyId: propertyId),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 40.0, bottom: 20.0, left: 20.0, right: 20.0),
          child: isLoading
              ? CircularProgressIndicator()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Exiba a imagem do imóvel aqui
                    if (propertyData!['images'] != null &&
                        propertyData!['images'].isNotEmpty)
                      Center(
                        child: Column(
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
                            SizedBox(height: 20.0),
                            Center(
                              child: SizedBox(
                                height: 300,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: propertyData!['images'].length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final imageUrl =
                                        propertyData!['images'][index];
                                    return Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 00.0),
                                        child: Center(
                                          child: Image.network(
                                            imageUrl,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 300,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 20),
                    if (propertyData != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${propertyData!['title']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Descrição: ${propertyData!['description']}',
                                style: TextStyle(),
                              ),
                              Text(
                                  'Especificação: ${propertyData!['specification']}'),
                              SizedBox(height: 20),
                              // Espaçamento entre a descrição/especificação e as informações abaixo

                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Preço: R\$ ${propertyData!['price']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'Status: ${propertyData!['status']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tipo: ${propertyData!['type']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                            'Localização: ${propertyData!['location']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    if (propertyData == null)
                      Text('Detalhes do imóvel não encontrados.'),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            editProperty(widget.propertyId);
                          },
                          icon: SvgPicture.asset(
                            'assets/editpen.svg', // Substitua pelo caminho do seu ícone SVG
                            height: 24, // Altura do ícone
                            width: 24, // Largura do ícone
                          ),
                          label: Text('Editar'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color(0xFF0D47A1)),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            deleteProperty(widget.propertyId);
                          },
                          icon: SvgPicture.asset(
                            'assets/deletetrash.svg', // Substitua pelo caminho do seu ícone SVG
                            height: 24, // Altura do ícone
                            width: 24, // Largura do ícone
                          ),
                          label: Text('Excluir'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color(0xFFB71C1C)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
        ),
      ),
    );
  }
}
