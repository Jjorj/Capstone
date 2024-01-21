import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goldy/chatbox/chatbox.dart';
import 'package:goldy/museum/museum.dart';
import 'package:goldy/cathedral/cathedral.dart';
import 'package:goldy/gaston/gaston.dart';
import 'package:goldy/sm/sm.dart';
import 'package:goldy/user_profile/user_profile.dart';
import 'package:goldy/LandingPage/LandingPage.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? showHomePage;

  const HomePage({Key? key, this.showHomePage}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? currentUsername;

  @override
  void initState() {
    super.initState();
    _getCurrentUserUsername().then((String username) {
      setState(() {
        currentUsername = username;
      });
    });
  }

  Future<String> _getCurrentUserUsername() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();

    return userSnapshot['username'];
  }

void logout() async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Logout Confirmation'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () async {
              var user = FirebaseAuth.instance.currentUser;
              if (user != null) { // Check if a user is currently logged in
                await FirebaseAuth.instance.signOut(); 
                Navigator.of(context).popUntil((route) => route.isFirst); // Pop until the root navigator if user was logged in
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LandingPage())); // Navigate to the landing page
              }
              Navigator.of(context).pop(); // Close the dialog regardless of whether a user was logged in or not
            },
            child: Text("Yes"),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/images/ground.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          children: [
            // Left Section
            Container(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  // Profile Picture and Greeting
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30.0,
                        backgroundImage: AssetImage("lib/images/Avatar1.png"),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, $currentUsername!',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Explore must-see places \nin Cagayan de Oro City',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'City of Golden Friendship',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 100),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    },
                    child: _buildRowWithIconAndText(Icons.home, 'Home', () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => UserProfile(),
                        ),
                      );
                    },
                    child: _buildRowWithIconAndText(
                        Icons.person, 'User Profile', () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => UserProfile(),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => ChatBox(),
                        ),
                      );
                    },
                    child:
                        _buildRowWithIconAndText(Icons.message, 'Messages', () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => ChatBox(),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: logout,
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.black,
                        decorationThickness: 2.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Move the Expanded widget inside the Column
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Tourist Spot Pictures
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Cathedral(),
                          ),
                        );
                      },
                      child: _buildPictureBox(
                        350,
                        150,
                        'Cathedral',
                        'lib/images/caption.jpg',
                        'Saint Augustine Metropolitan Cathedral',
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Museum(),
                              ),
                            );
                          },
                          child: _buildPictureBox(
                            350,
                            150,
                            'Cathedral',
                            'lib/images/museum.jfif',
                            'City Museum of Cagayan de Oro',
                          ),
                        ),
                        _buildPictureBox(
                          350,
                          150,
                          'Cathedral',
                          'lib/images/macahambus.jpg',
                          'Macahambus Cave',
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Gaston(),
                              ),
                            );
                          },
                          child: _buildPictureBox(
                            350,
                            150,
                            'Cathedral',
                            'lib/images/gaston.jpg',
                            'Gaston Park',
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SM(),
                                  ),
                                );
                              },
                              child: _buildPictureBox(
                                350,
                                150,
                                'Cathedral',
                                'lib/images/47.jpg',
                                'SM Downtown',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowWithIconAndText(
      IconData icon, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(width: 16),
          Icon(
            icon,
            color: Colors.black,
          ),
          SizedBox(width: 8.0),
          Text(
            text,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildPictureBox(double width, double height, String location,
      String imagePath, String description) {
    return Container(
      width: width,
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              imagePath,
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8.0),
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              description,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontFamily: 'assets/Montserrat-Bold.ttf',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Material(
      child: HomePage(
        showHomePage: () {
          // Handle navigation to the HomePage here
          // This is where you would navigate back to the HomePage
        },
      ),
    ),
  ));
}

