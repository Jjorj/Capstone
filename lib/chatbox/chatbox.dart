import 'package:flutter/material.dart';
import 'package:goldy/homepage/homepage.dart';
import 'package:goldy/user_profile/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goldy/LandingPage/LandingPage.dart';

FocusNode replyFocusNode = FocusNode();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatBox(),
    );
  }
}

class Comment {
  String text;
  String userId;
  Comment? repliedTo;

  Comment({
    required this.text,
    required this.userId,
    this.repliedTo,
  });
}

class ChatBox extends StatefulWidget {
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  _ChatBoxState createState() => _ChatBoxState();
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

class _ChatBoxState extends State<ChatBox> {
  List<Comment> comments = [];
  TextEditingController messageController = TextEditingController();

  Comment? replyToComment;

  Future<void> _addComment(String comment) async {
    CollectionReference commentsCollection =
        FirebaseFirestore.instance.collection('comments');

    await commentsCollection.add({
      'text': comment,
      'user_id': widget.currentUser.uid,
    });

    setState(() {
      replyToComment = null;
    });
  }

  Future<List<Comment>> _getComments() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('comments').get();

    return querySnapshot.docs.map((doc) {
      return Comment(
        text: doc['text'],
        userId: doc['user_id'],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Section
          Container(
            padding: EdgeInsets.all(30),
            width: 250,
            color: Color.fromARGB(255, 252, 255, 74),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text('Comments',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  child: _buildSidebarOption(Icons.home, 'Home'),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => UserProfile(),
                      ),
                    );
                  },
                  child: _buildSidebarOption(Icons.person, 'User Profile'),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => ChatBox(),
                      ),
                    );
                  },
                  child: _buildSidebarOption(Icons.message, 'Messages'),
                ),
                SizedBox(height: 50),
                GestureDetector(
                  onTap: () async {
                    await _logout(context);
                  },
                  child: _buildRowWithIconAndText(Icons.logout, 'Log out'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder<List<Comment>>(
                    future: _getComments(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Handle loading state

                      }

                      if (snapshot.hasError) {
                        // Handle error state
                        return Text('Error: ${snapshot.error}');
                      }

                      comments = snapshot.data ?? [];

                      return ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          Comment comment = comments[index];
                          return Column(
                            children: [
                              ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 3),
                                        CircleAvatar(
                                          radius: 15.0,
                                          backgroundImage:
                                              AssetImage("lib/images/avatar1.png"),
                                        ),
                                        SizedBox(width: 10),
                                        FutureBuilder<DocumentSnapshot>(
                                          future: FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget.currentUser.uid)
                                              .get(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {}
                                            if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            }
                                            String username =
                                                snapshot.data?['username'] ?? '...';

                                            return Text(
                                              username,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2),
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 43),
                                      child: Text(
                                        comment.text,
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: comment.repliedTo != null
                                    ? Row(
                                        children: [
                                          SizedBox(width: 43),
                                          Icon(Icons.reply),
                                          SizedBox(width: 5),
                                          Text(
                                            '${comment.userId} replied to ${comment.repliedTo!.userId}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      )
                                    : null,
                              ),
                              Divider(),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle:
                                TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          String comment =
                              messageController.text.trim();
                          if (comment.isNotEmpty) {
                            _addComment(comment);
                            messageController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarOption(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 12),
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

  Widget _buildRowWithIconAndText(IconData icon, String text) {
    return GestureDetector(
      onTap: () async {
        if (icon == Icons.logout) {
          await _logout(context);
        } else {
          // Handle other onTap actions
        }
      },
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
}
