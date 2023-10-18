import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OpenMapAdmin extends StatefulWidget {
  @override
  _OpenMapAdminState createState() => _OpenMapAdminState();
}

class _OpenMapAdminState extends State<OpenMapAdmin> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Locations').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _markers.clear();
            for (var document in snapshot.data!.docs) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              double latitude = data['latitude'];
              double longitude = data['longitude'];
              _markers.add(Marker(
                markerId: MarkerId(document.id),
                position: LatLng(latitude, longitude),
              ));
            }
          }
          return GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(13.7563, 100.5018),
              zoom: 10.0,
            ),
            markers:
                _markers, // ให้ GoogleMap ดึงค่า markers จากตัวแปร _markers
          );
        },
      ),
    );
  }
}
