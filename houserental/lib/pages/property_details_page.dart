import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houserental/pages/edit_property_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PropertyDetailsPage extends StatefulWidget {
  final String propertyId;

  PropertyDetailsPage({required this.propertyId});

  @override
  _PropertyDetailsPageState createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  Map<String, dynamic>? propertyData;
  bool isLoading = true;
  User? currentUser = FirebaseAuth.instance.currentUser;
  TextEditingController commentController = TextEditingController();

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

  Future<void> addComment() async {
    if (currentUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('properties')
            .doc(widget.propertyId)
            .collection('comments')
            .add({
          'text': commentController.text,
          'timestamp': FieldValue.serverTimestamp(),
          'userId': currentUser!.uid,
        });

        // Limpa o campo de texto após adicionar o comentário.
        commentController.clear();
      } catch (e) {
        print('Erro ao adicionar comentário: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao adicionar comentário: $e'),
          ),
        );
      }
    }
  }

  void navigateToEditProperty(String propertyId) {
    if (currentUser != null &&
        propertyData != null &&
        currentUser!.uid == propertyData!['ownerId']) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EditPropertyPage(propertyId: propertyId),
        ),
      );
    } else {
      // O usuário atual não é o proprietário, então você pode exibir uma mensagem de erro ou tomar outra ação apropriada.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Você não tem permissão para editar esta propriedade.'),
        ),
      );
    }
  }

  Future<Map<String, dynamic>> getUserData(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: isLoading
                ? CircularProgressIndicator()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                          padding: EdgeInsets.all(8.0),
                                          child: Image.network(
                                            imageUrl,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 300,
                                            fit: BoxFit.cover,
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
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (currentUser != null &&
                              propertyData != null &&
                              currentUser!.uid == propertyData!['ownerId'])
                            ElevatedButton.icon(
                              onPressed: () {
                                navigateToEditProperty(widget.propertyId);
                              },
                              icon: SvgPicture.asset(
                                'assets/editpen.svg',
                                height: 24,
                                width: 24,
                              ),
                              label: Text('Editar'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFF0D47A1)),
                              ),
                            ),
                          SizedBox(width: 10),
                          if (currentUser != null &&
                              propertyData != null &&
                              currentUser!.uid == propertyData!['ownerId'])
                            ElevatedButton.icon(
                              onPressed: () {
                                deleteProperty(widget.propertyId);
                              },
                              icon: SvgPicture.asset(
                                'assets/deletetrash.svg',
                                height: 24,
                                width: 24,
                              ),
                              label: Text('Excluir'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFFB71C1C)),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Comentários:',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      if (currentUser != null &&
                          propertyData != null &&
                          currentUser!.uid != propertyData!['ownerId'])
                        Column(
                          children: [
                            TextField(
                              controller: commentController,
                              decoration: InputDecoration(
                                labelText: 'Adicionar Comentário',
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.send),
                                  onPressed: () {
                                    addComment();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      // Consulta ao Firestore para obter os comentários
                      FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('properties')
                            .doc(widget.propertyId)
                            .collection('comments')
                            .orderBy('timestamp', descending: true)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return Text('Erro: ${snapshot.error}');
                          }
                          final comments = snapshot.data?.docs;

                          return Column(
                            children: comments!.map((comment) {
                              final commentText = comment['text'];
                              final commentUserId = comment['userId'];
                              final commentTimestamp = comment['timestamp'];

                              return FutureBuilder(
                                future: getUserData(commentUserId),
                                builder: (context, userDataSnapshot) {
                                  if (userDataSnapshot.connectionState ==
                                      ConnectionState.done) {
                                    final userData = userDataSnapshot.data
                                        as Map<String, dynamic>;
                                    final username = userData['username'];
                                    final profileImageUrl =
                                        userData['profileImageUrl'];

                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              if (profileImageUrl != null)
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      profileImageUrl),
                                                  radius: 16.0,
                                                )
                                              else
                                                Icon(Icons.person, size: 32.0),
                                              SizedBox(width: 8.0),
                                              Text(
                                                username ?? 'Nome do Usuário',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            commentTimestamp != null
                                                ? commentTimestamp
                                                    .toDate()
                                                    .toString()
                                                : '',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            commentText,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Divider(),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
