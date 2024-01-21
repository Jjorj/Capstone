import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goldy/chatbox/chatbox.dart';
import 'package:goldy/homepage/homepage.dart';
import 'package:goldy/LandingPage/LandingPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserProfile(),
    );
  }
}

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _ageTextController = TextEditingController();
  final TextEditingController _addressTextController = TextEditingController();
  final TextEditingController _mobileNumberTextController =
      TextEditingController();

  bool isEditMode = false;
  String selectedAvatar = "lib/images/profile pic.jpg"; // Default avatar
  String username = "Username"; // Default username

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (snapshot.exists) {
        setState(() {
          username = snapshot['username'];
          _emailTextController.text = snapshot['email'];
          _addressTextController.text = snapshot['address'];
          _ageTextController.text = snapshot['age'];
          _mobileNumberTextController.text = snapshot['mobile number'];
          selectedAvatar = snapshot['profile_picture'] ?? selectedAvatar;
        });
      }
    }
  }
  

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

 Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LandingPage(), // Replace with your landing page
        ),
      );
    } catch (e) {
      print('Logout Error: $e');
    }
  }

  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
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
                await _logout(context);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }


  Future<void> _showAvatarPickerDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Profile', style: TextStyle(fontSize: 15)),
          content: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAvatar = "lib/images/avatar1.png";
                    isEditMode = true;
                  });
                  Navigator.of(context).pop(selectedAvatar); // Pass selectedAvatar back
                },
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage("lib/images/avatar1.png"),
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAvatar = "lib/images/avatar2.png";
                    isEditMode = true;
                  });
                  Navigator.of(context).pop(selectedAvatar); // Pass selectedAvatar back
                },
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage("lib/images/avatar2.png"),
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAvatar = "lib/images/avatar3.png";
                    isEditMode = true;
                  });
                  Navigator.of(context).pop(selectedAvatar); // Pass selectedAvatar back
                },
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage("lib/images/avatar3.png"),
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAvatar = "lib/images/avatar4.png";
                    isEditMode = true;
                  });
                  Navigator.of(context).pop(selectedAvatar); // Pass selectedAvatar back
                },
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage("lib/images/avatar4.png"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatarOption(String imagePath, String optionName) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedAvatar = imagePath;
          isEditMode = true;
        });
        Navigator.of(context).pop();
      },
      child: Text(optionName),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 200),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 16),
                          Icon(
                            Icons.home,
                            color: Colors.black,
                          ),
                          SizedBox(width: 8.0),
                          Text('Home',
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => UserProfile(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 16),
                          Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          SizedBox(width: 8.0),
                          Text('User Profile',
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(width: 16),
                        Icon(
                          Icons.message,
                          color: Colors.black,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => ChatBox(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              SizedBox(width: 8.0),
                              Text('Messages',
                                  style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 150),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                color: Colors.black,
                size: 20,
              ),
              SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  _showLogoutConfirmationDialog();
                },
                child: Text(
                  'Log out',
                  style: TextStyle(color: Colors.black, fontSize: 13),
                ),
              ),
                            SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 48.0,
                              backgroundImage: NetworkImage(selectedAvatar),
                            ),
                            if (isEditMode)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: _showAvatarPickerDialog,
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.edit,
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(width: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Tourist',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isEditMode = !isEditMode;
                                });
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                      fontSize: 13,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  if (isEditMode)
                                    Icon(
                                      Icons.edit,
                                      size: 15,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    buildTextField(
                      'Email',
                      _emailTextController,
                      labelFontWeight: FontWeight.bold,
                      isEditing: isEditMode,
                    ),
                    SizedBox(height: 20),
                    buildTextField(
                      'Address',
                      _addressTextController,
                      labelFontWeight: FontWeight.bold,
                      isEditing: isEditMode,
                    ),
                    SizedBox(height: 20),
                    buildTextField(
                      'Age',
                      _ageTextController,
                      labelFontWeight: FontWeight.bold,
                      isEditing: isEditMode,
                    ),
                    SizedBox(height: 20),
                    buildTextField(
                      'Mobile Number',
                      _mobileNumberTextController,
                      labelFontWeight: FontWeight.bold,
                      isEditing: isEditMode,
                    ),
                    SizedBox(height: 50),
                    if (isEditMode)
                      ElevatedButton(
                        onPressed: () async {
                          await _saveChanges();
                          setState(() {
                            isEditMode = false;
                          });
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          ),
                        ),
                        child: Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 10, color: Colors.black),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String labelText,
    TextEditingController controller, {
    double labelFontSize = 13,
    FontWeight labelFontWeight = FontWeight.normal,
    FontWeight fontWeight = FontWeight.bold,
    bool isEditing = false,
  }) {
    return Container(
      width: 550.0,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(fontSize: 13, color: Colors.black),
        enabled: isEditing,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: labelFontSize,
            fontWeight: labelFontWeight,
            color: Colors.black,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      try {
        await users.doc(user.uid).update({
          'email': _emailTextController.text,
          'age': _ageTextController.text,
          'address': _addressTextController.text,
          'mobile number': _mobileNumberTextController.text,
          'profile_picture': selectedAvatar,
        });

        print('User data updated successfully.');
      } catch (e) {
        print('Error updating user data: $e');
      }
    }
  }
}