<<<<<<< HEAD
// home page
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
=======
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

>>>>>>> eed4b58d352a4c9ed966d9e7accab25cc111e86e
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
=======
    return Scaffold(appBar: AppBar(title: const Text('Home')));
>>>>>>> eed4b58d352a4c9ed966d9e7accab25cc111e86e
  }
}
