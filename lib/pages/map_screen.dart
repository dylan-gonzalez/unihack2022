// map page for volunteers

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:food_app/helpers/firebase_helper.dart';

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
    var merchantOffers = await FirebaseHelper.getMerchantOffers();
    for (var offer in merchantOffers.docs) {
      print(
          '----------------------------------------------------------------------' +
              (offer.data()['location'] as GeoPoint).latitude.toString());
    }

    Set<Marker> markers = {};
    for (var merchantOffer in merchantOffers.docs) {
      var offer = merchantOffer.data();
      var merchant = await FirebaseHelper.getUser(offer['userID']);

      GeoPoint loc = offer['location'];
      markers.add(Marker(
          markerId: MarkerId('id-1'),
          position: LatLng(loc.latitude, loc.longitude),
          infoWindow:
              InfoWindow(title: merchant['name'], snippet: "another test")));
    }
    setState(() {
      _markers.addAll(markers);
    });
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
    FirebaseHelper.getMerchantOffers().then((value) {
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
