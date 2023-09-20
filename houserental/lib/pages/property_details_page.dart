import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      appBar: AppBar(
        title: Text('Detalhes do Imóvel'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: isLoading
              ? CircularProgressIndicator()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detalhes do Imóvel:',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    if (propertyData != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Título: ${propertyData!['title']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Preço: ${propertyData!['price']}'),
                          Text('Descrição: ${propertyData!['description']}'),
                          Text(
                              'Especificação: ${propertyData!['specification']}'),
                          Text('Status: ${propertyData!['status']}'),
                          Text('Tipo: ${propertyData!['type']}'),
                          Text('Localização: ${propertyData!['location']}'),
                          // Exiba a imagem do imóvel aqui
                          if (propertyData!['images'] != null &&
                              propertyData!['images'].isNotEmpty)
                            Column(
                              children: [
                                Text(
                                  'Imagens:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 150,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: propertyData!['images'].length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final imageUrl =
                                          propertyData!['images'][index];
                                      return Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Image.network(
                                          imageUrl,
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              if (currentUser != null &&
                                  propertyData != null &&
                                  currentUser!.uid == propertyData!['ownerId'])
                                ElevatedButton(
                                  onPressed: () {
                                    navigateToEditProperty(widget.propertyId);
                                  },
                                  child: Text('Editar'),
                                ),
                              SizedBox(width: 10),
                              if (currentUser != null &&
                                  propertyData != null &&
                                  currentUser!.uid == propertyData!['ownerId'])
                                ElevatedButton(
                                  onPressed: () {
                                    deleteProperty(widget.propertyId);
                                  },
                                  child: Text('Remover'),
                                ),
                            ],
                          ),
                        ],
                      ),
                    if (propertyData == null)
                      Text('Detalhes do imóvel não encontrados.'),
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
                    Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('properties')
                            .doc(widget.propertyId)
                            .collection('comments')
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }
                          final comments = snapshot.data?.docs;
                          List<Widget> commentWidgets = [];
                          for (var comment in comments!) {
                            final commentText = comment['text'];
                            final commentUserId = comment['userId'];
                            final commentTimestamp = comment['timestamp'];

                            final commentWidget = FutureBuilder(
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
                                        // Nome do usuário
                                        Text(
                                          username ?? 'Nome do Usuário',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        // Data e hora do comentário
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
                                        // Comentário
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
                            commentWidgets.add(commentWidget);
                          }
                          return ListView(
                            children: commentWidgets,
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
