import 'package:houserental/models/contato.dart';
import 'package:houserental/models/enums.dart';

import 'proprietario.dart';

class Imovel {
  final int id;
  final String titulo;
  final double preco;
  final String descricao;
  final String especificacao;
  final EnumStatus status;
  final EnumTipo tipo;
  final String localizacao;
  final double estrelas;
  final Proprietario proprietario;
  final List<String>? imagens; // Alteração: tornar a lista de imagens opcional

  Imovel({
    required this.id,
    required this.titulo,
    required this.preco,
    required this.descricao,
    required this.especificacao,
    required this.estrelas,
    required this.localizacao,
    required this.status,
    required this.tipo,
    required this.proprietario,
    this.imagens, // Alteração: tornar a lista de imagens opcional
  });
}

List<Imovel> imoveisHardcode = [
  Imovel(
    id: 1,
    titulo: 'Casa de Praia',
    preco: 300.0,
    descricao: 'Uma bela casa à beira-mar.',
    especificacao: '3 quartos, 2 banheiros',
    estrelas: 4.5,
    localizacao: 'Praia da Teste',
    status: EnumStatus.NEGOCIACAO,
    tipo: EnumTipo.CASA,
    proprietario: Proprietario(
      id: 1,
      nome: "José Antonio",
      contato: Contato(email: "joseantonio@gmail.com", telefone: "98599-4235"),
    ),
    imagens: [
      'https://img.freepik.com/premium-photo/luxury-beautiful-house_967158-73.jpg?w=2000',
      'https://img.freepik.com/premium-photo/luxury-beautiful-house_967158-73.jpg?w=2000',
    ],
  ),
  Imovel(
    id: 2,
    titulo: 'Apartamento no Centro',
    preco: 250.0,
    descricao: 'Apartamento espaçoso no centro da cidade.',
    especificacao: '2 quartos, 1 banheiro',
    estrelas: 4.2,
    localizacao: 'Centro da Cidade',
    status: EnumStatus.VENDER,
    tipo: EnumTipo.APARTAMENTO,
    proprietario: Proprietario(
      id: 2,
      nome: "Maria Silva",
      contato: Contato(email: "mariasilva@gmail.com", telefone: "98765-1234"),
    ),
    imagens: [
      'https://img.freepik.com/premium-photo/luxury-beautiful-house_967158-73.jpg?w=2000',
      'https://img.freepik.com/premium-photo/luxury-beautiful-house_967158-73.jpg?w=2000',
    ],
  ),
  Imovel(
    id: 3,
    titulo: 'Chácara Relaxante',
    preco: 500.0,
    descricao: 'Chácara perfeita para relaxar nos finais de semana.',
    especificacao: '4 quartos, 3 banheiros',
    estrelas: 4.8,
    localizacao: 'Zona Rural',
    status: EnumStatus.NEGOCIACAO,
    tipo: EnumTipo.CASA,
    proprietario: Proprietario(
      id: 3,
      nome: "Pedro Souza",
      contato: Contato(email: "pedrosouza@gmail.com", telefone: "98712-3456"),
    ),
    imagens: [
      'https://img.freepik.com/premium-photo/luxury-beautiful-house_967158-73.jpg?w=2000',
      'https://img.freepik.com/premium-photo/luxury-beautiful-house_967158-73.jpg?w=2000',
    ],
  ),
  // Adicione mais imóveis aqui
];
