import 'package:houserental/models/usuario.dart';

import 'contato.dart';

class Proprietario extends Usuario {
  // final List<Imovel> imoveis;
  Proprietario({
    required int id,
    required String nome,
    required Contato contato,
    //required this.imoveis
  }) : super(id: id, nome: nome, contato: contato);
}
