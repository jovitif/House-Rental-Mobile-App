import 'package:houserental/models/contato.dart';
import 'package:houserental/models/proprietario.dart';
import 'package:test/test.dart';
import 'package:houserental/models/imovel.dart';
import 'package:houserental/models/enums.dart';

void main() {
  group('Imovel', () {
    test('Criar Imovel', () {
      final imovel = Imovel(
        id: 1,
        titulo: 'Apartamento A',
        preco: 1000.0,
        descricao: 'Um belo apartamento',
        especificacao: '2 quartos, 1 banheiro',
        estrelas: 4.5,
        localizacao: 'Rua A, Cidade X',
        status: EnumStatus.ALUGAR,
        proprietario: Proprietario(
            id: 1,
            nome: "José Antonio",
            contato: Contato(
                email: "joseantonio@gmail.com", telefone: "98599-4235")),
        tipo: EnumTipo.APARTAMENTO,
      );

      expect(imovel.id, 1);
      expect(imovel.titulo, 'Apartamento A');
      expect(imovel.preco, 1000.0);
      expect(imovel.status, EnumStatus.ALUGAR);
    });
  });
}
