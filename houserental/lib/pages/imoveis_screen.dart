import 'package:flutter/material.dart';
import 'package:houserental/models/imovel.dart';
import 'package:houserental/pages/detalhes_imovel_screen.dart';
import 'package:houserental/pages/detalhes_usuarios_screen.dart';

import '../models/usuario.dart';

// Importe a classe Usuario e DetalhesUsuarioScreen aqui
class ImoveisScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Imóveis'),
      ),
      body: Column(
        children: [
          // Botão para adicionar um novo imóvel
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Navegue para a página de adicionar/imóvel
                Navigator.pushNamed(context, '/adicionar_imovel');
              },
              child: Text('Adicionar Imóvel'),
            ),
          ),
          // Exibir quantidade de imóveis no topo
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Quantidade de Imóveis: ${imoveisHardcode.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Lista de imóveis
          Expanded(
            child: ListView.builder(
              itemCount: imoveisHardcode.length,
              itemBuilder: (context, index) {
                Imovel imovel = imoveisHardcode[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Espaçamento entre os containers
                      SizedBox(height: 16.0),
                      // Imagem do imóvel
                      Container(
                        height: 200, // Ajuste a altura conforme necessário
                        width: double.infinity,
                        child: Image.network(
                          imovel.imagens?.isNotEmpty == true
                              ? imovel.imagens![0]
                              : 'https://via.placeholder.com/150', // Imagem de substituição
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Tipo e status do imóvel
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                'Tipo: ${imovel.tipo.toString().split('.').last}'),
                            Text(
                                'Status: ${imovel.status.toString().split('.').last}'),
                          ],
                        ),
                      ),
                      // Preço
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Preço: R\$ ${imovel.preco.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Localização
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Localização: ${imovel.localizacao}'),
                      ),
                      // Botão para visualizar centralizado
                      Container(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navegue para a página de detalhes do imóvel ao clicar no botão
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetalhesImovelScreen(imovel: imovel),
                              ),
                            );
                          },
                          child: Text('Visualizar'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
