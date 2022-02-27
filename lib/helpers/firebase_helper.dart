import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'random_data.dart';

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
    return FirebaseFirestore.instance.collection('users').get();
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String userid) {
    return FirebaseFirestore.instance.collection('users').doc(userid).get();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getRoutes() {
    return FirebaseFirestore.instance.collection('routes').get();
  }

  // static generateRandomUsers() async {
  //   List<String> roles = ['MERCHANT', 'VOLUNTEER', 'RECEIVER'];
  //   int j = 0;
  //   for (var i = 0; i < RandomData.data.length; i++) {
  //     var row = RandomData.data[i];
  //     UserCredential user = await FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(
  //             email: row["email"]!, password: getRandomString(9));

  //     FirebaseFirestore.instance.collection('users').doc(user.user!.uid).set({
  //       'Role': roles[i % 3],
  //       'Name': row['name'],
  //       'Contact': row['phone'],
  //     });
  //     var rnd = Random();
  //     switch (i % 3) {
  //       case 0:
  //         FirebaseFirestore.instance.collection('offers').add({
  //           'completed': false,
  //           'location':
  //               GeoPoint(RandomData.lngltd[j], RandomData.lngltd[j + 1]),
  //           'photo': 'https://picsum.photos/200/300',
  //           'qty': rnd.nextInt(500),
  //           'taken': false,
  //           'time': DateTime.now(),
  //           'userId': user.user!.uid,
  //         });
  //         j = j + 2;
  //         break;
  //       case 2:
  //         FirebaseFirestore.instance.collection('asks').add({
  //           'completed': false,
  //           'location':
  //               GeoPoint(RandomData.lngltd[j], RandomData.lngltd[j + 1]),
  //           'qty': rnd.nextInt(500),
  //           'taken': false,
  //           'userId': user.user!.uid,
  //         });
  //         j = j + 2;
  //         break;
  //       default:
  //     }

  //     i++;
  //   }
  // }

  static String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(
          length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
