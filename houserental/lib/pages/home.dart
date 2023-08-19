import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Importe o arquivo
import 'package:houserental/components/map_component.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final initialPosition =
        LatLng(37.7749, -122.4194); // Exemplo de posição inicial

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
      ),
      body: Center(
        child: MapComponent(initialPosition: initialPosition),
      ),
    );
  }
}
