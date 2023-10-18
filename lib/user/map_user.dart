import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreenUser extends StatefulWidget {
  const MapScreenUser({Key? key}) : super(key: key);
  @override
  State<MapScreenUser> createState() => _MapScreenUserState();
}

class _MapScreenUserState extends State<MapScreenUser> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('Locations').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //_markers.clear();
              for (var document in snapshot.data!.docs) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                double latitude = data['latitude'];
                double longitude = data['longitude'];
                _markers.add(Marker(
                  markerId: MarkerId(document.id),
                  position: LatLng(latitude, longitude),
                  infoWindow:
                      InfoWindow(title: data['name'], snippet: data['address']),
                ));
              }
            }
            return GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(13.7563, 100.5018),
                zoom: 12.0,
              ),
              markers:
                  _markers, // ให้ GoogleMap ดึงค่า markers จากตัวแปร _markers
            );
          },
        ),
      ),
    );
  }

  void getCurrentLocation() async {
    Location location = Location();
    var locationData = await location.getLocation();
    print(locationData);
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }
}
