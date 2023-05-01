import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowLocationGoogleMap extends StatefulWidget {
  final LatLng center;

  ShowLocationGoogleMap({required this.center});

  @override
  _ShowLocationGoogleMapState createState() => _ShowLocationGoogleMapState();
}

class _ShowLocationGoogleMapState extends State<ShowLocationGoogleMap> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('center_marker'),
          position: widget.center,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: widget.center,
        zoom: 13.0,
      ),
      markers: _markers,
    );
  }
}
