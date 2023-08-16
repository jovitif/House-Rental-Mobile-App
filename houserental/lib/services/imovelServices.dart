import 'package:houserental/models/imovel.dart';

class ImovelServices {
  List<Imovel> imoveis = [];

  bool create(Imovel imovel) {
    try {
      imoveis.add(imovel);
      return true;
    } catch (e) {
      return false;
    }
  }

  Imovel read(int id) {
    return imoveis.firstWhere((imovel) => imovel.id == id,
        orElse: () => throw Exception('Imóvel não encontrado'));
  }

  void update(int id, Imovel newImovel) {
    final index = imoveis.indexWhere((imovel) => imovel.id == id);
    if (index != -1) {
      imoveis[index] = newImovel;
    }
  }

  void delete(int id) {
    imoveis.removeWhere((imovel) => imovel.id == id);
  }
}
