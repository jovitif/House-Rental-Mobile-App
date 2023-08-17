import 'package:houserental/models/usuario.dart';

class UsuarioServices {
  List<Usuario> usuarios = [];

  bool create(Usuario usuario) {
    try {
      usuarios.add(usuario);
      return true;
    } catch (e) {
      return false;
    }
  }

  Usuario read(int id) {
    return usuarios.firstWhere((usuario) => usuario.id == id,
        orElse: () => throw Exception('Usuário não encontrado'));
  }

  void update(int id, Usuario newUsuario) {
    final index = usuarios.indexWhere((usuario) => usuario.id == id);
    if (index != -1) {
      usuarios[index] = newUsuario;
    }
  }

  void delete(int id) {
    usuarios.removeWhere((usuario) => usuario.id == id);
  }
}
