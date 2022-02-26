import 'package:flutter/material.dart';
import 'package:food_app/pages/auth_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AuthScreen.routeName);
            },
            icon: Icon(Icons.login),
          )
        ],
      ),
    );
  }
}
