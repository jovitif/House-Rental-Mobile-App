import 'package:flutter/material.dart';
import 'package:houserental/models/imovel.dart';

class DetalhesImovelScreen extends StatelessWidget {
  final Imovel imovel;

  DetalhesImovelScreen({required this.imovel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(imovel.titulo),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exibir imagens do imóvel
            Container(
              height: 200, // Ajuste a altura conforme necessário
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:
                    imovel.imagens?.length ?? 0, // Verificação de nulidade
                itemBuilder: (context, index) {
                  String imagemUrl =
                      imovel.imagens?[index] ?? ''; // Verificação de nulidade
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image.network(imagemUrl),
                  );
                },
              ),
            ),

            // Outras informações do imóvel
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Preço: R\$ ${imovel.preco.toStringAsFixed(2)}'),
                  Text('Descrição: ${imovel.descricao}'),
                  Text('Especificações: ${imovel.especificacao}'),
                  Text('Localização: ${imovel.localizacao}'),
                  Text('Status: ${imovel.status}'),
                  Text('Tipo: ${imovel.tipo}'),
                  Text('Estrelas: ${imovel.estrelas}'),
                  Text('Proprietário: ${imovel.proprietario.nome}'),
                  Text(
                      'Email do Proprietário: ${imovel.proprietario.contato.email}'),
                  Text(
                      'Telefone do Proprietário: ${imovel.proprietario.contato.telefone}'),

                  // Adicionar informações de geolocalização
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
