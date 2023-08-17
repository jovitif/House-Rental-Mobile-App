import 'package:flutter_test/flutter_test.dart';
import 'package:houserental/models/contato.dart';
import 'package:houserental/models/usuario.dart';
import 'package:houserental/services/usuarioServices.dart';

void main() {
  final user01 = Usuario(
      id: 1,
      nome: "João Sales",
      contato: Contato(
          email: "joaosales911@gmail.com", telefone: "+55(84)98891-9268"));

  final userServices = UsuarioServices();

  test("Adicionar Usuário", () {
    expect(userServices.create(user01), true);
    expect(userServices.usuarios.length, 1);
  });

  test("Ler Usuário", () {
    final retrievedUser = userServices.read(1);
    expect(retrievedUser, isNotNull);
    expect(retrievedUser.nome, "João Sales");
  });

  test("Ler Usuário 2", () {
    final retrievedUser = userServices.read(3);
    expect(retrievedUser, isNotNull);
  });

  test("Atualizar Usuário", () {
    final newUser = Usuario(
      id: 1,
      nome: "João Vitor",
      contato: Contato(
          email: "joaovitor@example.com", telefone: "+55(84)98765-4321"),
    );
    userServices.update(1, newUser);
    final updatedUser = userServices.read(1);
    expect(updatedUser, isNotNull);
    expect(updatedUser.nome, "João Vitor");
    expect(updatedUser.contato.email, "joaovitor@example.com");
  });

  test("Ler Usuário Inexistente", () {
    expect(() => userServices.read(1), throwsException);
    print(throwsException);
  });

  test("Excluir Usuário 1", () {
    userServices.delete(1);
    expect(userServices.usuarios.length, 0);
  });

  test("Ler Usuário Inexistente 2", () {
    expect(() => userServices.read(1), throwsException);
    print(throwsException);
  });
}
