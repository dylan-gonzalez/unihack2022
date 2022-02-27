import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

// List<String> shopNames = []

class FirebaseHelper {

  static Future<QuerySnapshot<Map<String, dynamic>>> getMerchantOffers() {
    return FirebaseFirestore.instance
        .collection('offers')
        .where('completed', isEqualTo: false)
        .where('taken', isEqualTo: false)
        .get();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getReceiverOffers() {
    return FirebaseFirestore.instance
        .collection('asks')
        .where('completed', isEqualTo: false)
        .where('taken', isEqualTo: false)
        .get();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getUsers() { 
    return FirebaseFirestore.instance
        .collection('users')
        .get();
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String userid) { 
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userid)
        .get();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getRoutes() { 
    return FirebaseFirestore.instance
        .collection('routes')
        .get();
  }

  static generateRandomUsers() async {
    List<String> roles = ['Merchant', 'Volunteer', 'Receiver'];
    
    for (var i = 0; i < 100; i++) {
      UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: getRandomString(5), password: getRandomString(5));

      FirebaseFirestore.instance
        .collection('users')
        .doc(user.user!.uid)
        .set({'Role': roles[i % 3]});
    }
  }

  static String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

}