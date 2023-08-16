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

  final imovelServices = ImovelServices();

  test('Verificar status', () {
    expect(imovel.status, EnumStatus.ALUGAR);
  });

  test("Verificar id", () {
    expect(imovel.id, 1);
  });

  test("Verificar titulo", () {
    expect(imovel.titulo, 'Apartamento A');
  });

  test("Valor imovel maior do que 500", () {
    expect(imovel.preco, greaterThan(500));
  });

  test("Criar, Ler, Atualizar e Remover Imovel", () {
    // Teste de criação

    expect(imovelServices.create(imovel), true);

    // Teste de leitura
    final retrievedImovel = imovelServices.read(1);
    expect(retrievedImovel, isNotNull);
    expect(retrievedImovel.id, 1);

    // Teste de atualização
    final newImovel = Imovel(
      id: 1,
      titulo: 'Apartamento B', // Novo título
      preco: 1200.0, // Novo preço
      descricao: 'Um belo apartamento renovado', // Nova descrição
      especificacao: '2 quartos, 1 banheiro',
      estrelas: 4.7, // Nova avaliação
      localizacao: 'Rua B, Cidade Y', // Nova localização
      status: EnumStatus.VENDER, // Novo status
      proprietario: Proprietario(
          id: 1,
          nome: "José Antonio",
          contato:
              Contato(email: "joseantonio@gmail.com", telefone: "98599-4235")),
      tipo: EnumTipo.APARTAMENTO,
    );
    imovelServices.update(1, newImovel);

    final updatedImovel = imovelServices.read(1);
    expect(updatedImovel, isNotNull);
    expect(updatedImovel.titulo, 'Apartamento B');
    expect(updatedImovel.preco, 1200.0);
    expect(updatedImovel.descricao, 'Um belo apartamento renovado');
    expect(updatedImovel.estrelas, 4.7);
    expect(updatedImovel.localizacao, 'Rua B, Cidade Y');
    expect(updatedImovel.status, EnumStatus.VENDER);

    // Teste de remoção
    imovelServices.delete(3);
    expect(imovelServices.imoveis.length, 0);
  });
}
