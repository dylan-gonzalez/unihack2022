// map page for volunteers

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) async {
    var merchantOffers = await getMerchantOffers();
    for (var offer in merchantOffers.docs) {
      print(
          '----------------------------------------------------------------------' +
              (offer.data()['location'] as GeoPoint).latitude.toString());
    }

    setState(() {
      _markers.add(Marker(
          markerId: MarkerId('id-1'),
          position: LatLng(37.42796133580664, -122.085749655962),
          infoWindow: InfoWindow(title: 'Test', snippet: "another test")));
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getMerchantOffers() {
    return FirebaseFirestore.instance
        .collection('offers')
        .where('completed', isEqualTo: false)
        .where('taken', isEqualTo: false)
        .limit(1)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getReceiverOffers() {
    return FirebaseFirestore.instance
        .collection('asks')
        .where('completed', isEqualTo: false)
        .where('taken', isEqualTo: false)
        .get();
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    getMerchantOffers().then((value) {
      print(value);
    });

    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        markers: _markers,
        onMapCreated: _onMapCreated,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('hey you'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
