import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_app/navigation/navigation_routes.dart';
import 'package:food_app/navigation/navigation_screen.dart';
import 'package:food_app/pages/auth_screen.dart';
import 'package:food_app/pages/home.dart';
import 'package:food_app/pages/search.dart';
import 'package:food_app/widgets/navbar.dart';
import 'package:food_app/widgets/base.dart';
import 'package:food_app/pages/map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCfRNOy_znlike-dDUl1wL4NFEBkyptwNk", // Your apiKey
      appId: "1:665745974993:android:e44c4ef638602b823b87f0", // Your appId
      messagingSenderId: "665745974993", // Your messagingSenderId
      projectId: "food-app-ef0cd", // Your projectId
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NavigationScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        NavigationRoutes.homeRoute: (_) => HomeScreen(),
        NavigationRoutes.authRoute: (_) => AuthScreen(),
        NavigationRoutes.mapRoute: (_) => Map(),
        NavigationRoutes.searchRoute: (_) => SearchScreen(),
      },
    );
  }
}
