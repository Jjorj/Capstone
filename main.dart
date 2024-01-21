import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import
import 'package:goldy/LandingPage/LandingPage.dart';
import 'package:goldy/navbar/navbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAe-1bmcXiZufHk9BfZ0oxWbqfVwtXOWHA",
      appId: "1:899327206864:web:ee46ba21f0c36c422e05d5",
      messagingSenderId: "899327206864",
      projectId: "tourist-spot-for-cgy-de-oro",
    ),
  );


  runApp(MyApp());
}

// Example function to add data to Firestore
Future<void> addUserData(String M02emfk7pZM17PF0g3P5, String Email, String Username) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  await users.doc(M02emfk7pZM17PF0g3P5).set({
    'email': Email,
    'username': Username,
    // Add more fields as needed
  });
}

class MyApp extends StatelessWidget {

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'goldy.com',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Montserrat'),
      initialRoute: '/',
      routes: {
        '/': (context) => Goldy(),
        '/landing': (context) => LandingPage(),
        // Add more routes as needed
      },
    );
  }
}

class Goldy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("lib/images/pool.jpg"), fit: BoxFit.cover)),
        child: Column(
          children: <Widget>[
            Navbar(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
              child: LandingPage(),
            )
          ],
        ),
      ),
    );
  }
}
