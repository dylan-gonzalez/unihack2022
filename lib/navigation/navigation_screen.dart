import 'package:flutter/material.dart';
import 'package:food_app/navigation/navigation_routes.dart';
import 'package:food_app/pages/auth_screen.dart';
import 'package:food_app/pages/home.dart';

class NavigationScreen extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: navigatorKey,
        initialRoute: NavigationRoutes.home,
        onGenerateRoute: (routeSettings) {
          Widget page;
          switch (routeSettings.name) {
            case NavigationRoutes.home:
              page = HomeScreen();
              break;
            case NavigationRoutes.auth:
              page = AuthScreen();
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
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'login',
          ),
        ],
        onTap: (index) {
          currentIndex = index;
          navigatorKey.currentState!
              .pushReplacementNamed(NavigationRoutes.auth);
        },
      ),
    );
  }
}
