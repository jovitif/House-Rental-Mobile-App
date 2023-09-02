import 'package:flutter/material.dart';
import 'package:houserental/models/contato.dart';
import 'package:houserental/models/imovel.dart';
import 'package:houserental/models/enums.dart';
import 'package:houserental/models/proprietario.dart';

class AdicionarImovelScreen extends StatefulWidget {
  @override
  _AdicionarImovelScreenState createState() => _AdicionarImovelScreenState();
}

class _AdicionarImovelScreenState extends State<AdicionarImovelScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _especificacaoController =
      TextEditingController();
  final TextEditingController _localizacaoController = TextEditingController();

  EnumStatus _statusSelecionado = EnumStatus.NEGOCIACAO;
  EnumTipo _tipoSelecionado = EnumTipo.CASA;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Imóvel'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira um título';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _precoController,
                decoration: InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira um preço';
                  }
                  // Você pode adicionar validações adicionais aqui, como verificar se é um número válido.
                  return null;
                },
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _especificacaoController,
                decoration: InputDecoration(labelText: 'Especificações'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _localizacaoController,
                decoration: InputDecoration(labelText: 'Localização'),
              ),
              DropdownButtonFormField<EnumStatus>(
                value: _statusSelecionado,
                onChanged: (value) {
                  setState(() {
                    _statusSelecionado = value!;
                  });
                },
                items: EnumStatus.values.map((status) {
                  return DropdownMenuItem<EnumStatus>(
                    value: status,
                    child: Text(status.toString().split('.').last),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Status'),
              ),
              DropdownButtonFormField<EnumTipo>(
                value: _tipoSelecionado,
                onChanged: (value) {
                  setState(() {
                    _tipoSelecionado = value!;
                  });
                },
                items: EnumTipo.values.map((tipo) {
                  return DropdownMenuItem<EnumTipo>(
                    value: tipo,
                    child: Text(tipo.toString().split('.').last),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Tipo'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Crie um novo Imovel com os dados inseridos
                    Imovel novoImovel = Imovel(
                      id: imoveisHardcode.length +
                          1, // Você pode ajustar isso de acordo com a lógica real
                      titulo: _tituloController.text,
                      preco: double.parse(_precoController.text),
                      descricao: _descricaoController.text,
                      especificacao: _especificacaoController.text,
                      localizacao: _localizacaoController.text,
                      status: _statusSelecionado,
                      tipo: _tipoSelecionado,
                      estrelas: 0.0, // Você pode definir isso como necessário
                      proprietario: Proprietario(
                        id: 0, // Você pode definir isso como necessário
                        nome: '', // Você pode definir isso como necessário
                        contato: Contato(
                          email: '', // Você pode definir isso como necessário
                          telefone:
                              '', // Você pode definir isso como necessário
                        ),
                      ),
                      imagens: [], // Você pode definir isso como necessário
                    );

                    // Adicione o novo imóvel à lista de imóveis (ou envie para um servidor, banco de dados, etc.)
                    imoveisHardcode.add(novoImovel);

                    // Navegue de volta para a lista de imóveis
                    Navigator.pop(context);
                  }
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
