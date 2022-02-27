// map page for volunteers

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:food_app/helpers/firebase_helper.dart';


//center:-37.8136, 144.9631 




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
  Random rnd = Random();

  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};

  late BitmapDescriptor redMarker, blueMarker;

  @override
  void initState() {
    super.initState();
    setCustomMarkers();
  }


  void setCustomMarkers() async {
    redMarker = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'lib/assets/red_marker.png');
    blueMarker = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'lib/assets/blue_marker.png');
  }

  void _onMapCreated(GoogleMapController controller) async {
    var merchantOffers = await FirebaseHelper.getMerchantOffers();
    var receiverAsks = await FirebaseHelper.getReceiverOffers();


    Marker _createMarker(String role, var OfferOrAsk, var user) {
    
      GeoPoint loc = OfferOrAsk['location'];
      print("LATITUDE: " + loc.latitude.toString());

      return Marker(
          markerId: MarkerId(rnd.nextDouble().toString()),
          position: LatLng(loc.latitude, loc.longitude),
          icon: role == "Merchant" ? redMarker : blueMarker,
          infoWindow:
              InfoWindow(title: user['Name'], snippet: "Qty: " + OfferOrAsk['qty'].toString()),
          // onTap: 
              
              );
    }

    Set<Marker> markers = {};

    for (var merchantOffer in merchantOffers.docs) {
      print("MARKER");
      var offer = merchantOffer.data();
      var user = await FirebaseHelper.getUser(offer['userId']);
      print("USER");

      Marker marker = _createMarker("Merchant", offer, user);
      markers.add(marker);
    }

    for (var ask in receiverAsks.docs) {
      var offer = ask.data();
      var user = await FirebaseHelper.getUser(offer['userId']);

      // GeoPoint loc = offer['location'];
      markers.add(_createMarker("Receiver", offer, user));
    }

    setState(() {
      _markers.addAll(markers);
    });
  }

  static final CameraPosition startPosition = CameraPosition(
    target: LatLng(-36.3821, 145.4072),
    zoom: 11,
  );

  @override
  Widget build(BuildContext context) {
    FirebaseHelper.getMerchantOffers().then((value) {
      print(value);
    });

    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: startPosition,
        markers: _markers,
        onMapCreated: _onMapCreated,
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('hey you'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
