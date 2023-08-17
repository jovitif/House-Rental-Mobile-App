import 'package:test/test.dart';
import 'package:houserental/models/contato.dart';
import 'package:houserental/models/proprietario.dart';
import 'package:houserental/services/imovelServices.dart';
import 'package:houserental/models/imovel.dart';
import 'package:houserental/models/enums.dart';

void main() {
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
        contato:
            Contato(email: "joseantonio@gmail.com", telefone: "98599-4235")),
    tipo: EnumTipo.APARTAMENTO,
  );

  group('Imóvel', () {
    test('Verificar status', () {
      expect(imovel.status, EnumStatus.ALUGAR);
    });

    test("Verificar id", () {
      expect(imovel.id, 1);
    });

    test("Verificar titulo", () {
      expect(imovel.titulo, 'Apartamento A');
    });

    test("Valor imovel é menor do que 500", () {
      expect(imovel.preco, lessThan(500));
    });

    test("Valor imovel maior do que 500", () {
      expect(imovel.preco, greaterThan(500));
    });

    group("CRUD", () {
      final imovelServices = ImovelServices();
      test("Criar Imóvel", () {
        expect(imovelServices.create(imovel), true);
      });

      test("Ler Imóvel", () {
        final retrievedImovel = imovelServices.read(1);
        expect(retrievedImovel, isNotNull);
        expect(retrievedImovel.id, 1);
      });

      test("Ler Imóvel (2)", () {
        final retrievedImovel = imovelServices.read(2);
        expect(retrievedImovel, isNotNull);
        expect(retrievedImovel.id, 2);
      });

      test("Atualizar Imóvel", () {
        final newImovel = Imovel(
          id: 1,
          titulo: 'Apartamento B',
          preco: 1200.0,
          descricao: 'Um belo apartamento renovado',
          especificacao: '2 quartos, 1 banheiro',
          estrelas: 4.7,
          localizacao: 'Rua B, Cidade Y',
          status: EnumStatus.VENDER,
          proprietario: Proprietario(
              id: 1,
              nome: "José Antonio",
              contato: Contato(
                  email: "joseantonio@gmail.com", telefone: "98599-4235")),
          tipo: EnumTipo.APARTAMENTO,
        );
        imovelServices.create(imovel);
        imovelServices.update(1, newImovel);

        final updatedImovel = imovelServices.read(1);
        expect(updatedImovel, isNotNull);
        expect(updatedImovel.titulo, 'Apartamento B');
        expect(updatedImovel.preco, 1200.0);
        expect(updatedImovel.descricao, 'Um belo apartamento renovado');
        expect(updatedImovel.estrelas, 4.7);
        expect(updatedImovel.localizacao, 'Rua B, Cidade Y');
        expect(updatedImovel.status, EnumStatus.VENDER);
      });

      test("Remover Imóvel", () {
        imovelServices.create(imovel);
        imovelServices.delete(1);
        expect(imovelServices.imoveis.length, 0);
      });
    });
  });
}
