import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/navigation/navigation_routes.dart';
import 'package:food_app/pages/auth_screen.dart';
import 'package:food_app/pages/home.dart';
import 'package:food_app/pages/map_screen.dart';
import 'package:food_app/pages/search.dart';

class NavigationScreen extends StatefulWidget {
  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  int currentIndex = 0;

  List<BottomNavigationBarItem> bottomNavigationTabSetup() {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.map),
        label: 'Places',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Search',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.logout),
        label: 'logout',
      ),
    ];
  }

  void onNavigationBarTap(int index) {
    setState(() {
      currentIndex = index;
    });
    switch (index) {
      case 0:
        navigatorKey.currentState!.pushNamed(NavigationRoutes.homeRoute);
        break;
      case 1:
        navigatorKey.currentState!.pushNamed(NavigationRoutes.mapRoute);
        break;
      case 2:
        navigatorKey.currentState!.pushNamed(NavigationRoutes.searchRoute);
        break;
      case 3:
        FirebaseAuth.instance.signOut();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> tabItems = bottomNavigationTabSetup();
    return Scaffold(
      body: Navigator(
        key: navigatorKey,
        initialRoute: NavigationRoutes.homeRoute,
        onGenerateRoute: (routeSettings) {
          Widget page;
          switch (routeSettings.name) {
            case NavigationRoutes.homeRoute:
              page = HomeScreen();
              break;
            case NavigationRoutes.mapRoute:
              page = MapScreen();
              break;
            case NavigationRoutes.searchRoute:
              page = SearchScreen();
              break;
            default:
              throw Exception('Unknown route: ${routeSettings.name}');
          }
          return MaterialPageRoute<dynamic>(
            builder: (context) {
              return page;
            },
            settings: routeSettings,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.orange,
        currentIndex: currentIndex,
        items: tabItems,
        onTap: onNavigationBarTap,
      ),
    );
  }
}
