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
  });
}
