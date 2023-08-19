import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapComponent extends StatelessWidget {
  final LatLng initialPosition;

  MapComponent({required this.initialPosition});

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: 14.0,
      ),
      markers: {
        Marker(
          markerId: MarkerId("marker_1"),
          position: initialPosition,
          infoWindow: InfoWindow(title: "Localização Inicial"),
        ),
      },
    );
  }
}
