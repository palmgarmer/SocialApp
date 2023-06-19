import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/components/home/WallPost.dart';
import 'package:social_app/Screen/features/profiles/editProfilePage.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _signOutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userCollection = FirebaseFirestore.instance.collection('Users');
    final textController = TextEditingController();

    String timeToString(Timestamp time) {
      DateTime dateTime = time.toDate();

      String timeAgo = timeago.format(dateTime).toString();

      // return formatted string
      return timeAgo;
    }

    // edit field
    Future<void> editField(String field) async {
      String? newValue = "";
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Edit $field'),
          content: TextField(
            decoration: InputDecoration(
              hintText: 'Enter new $field',
            ),
            onChanged: (value) {
              // if field is empty, use current value
              newValue = value;
            },
          ),
          actions: [
            // cancel button
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            // save button
            TextButton(
              onPressed: () => {
                Navigator.of(context).pop(newValue),
              },
              child: Text('Save'),
            ),
          ],
        ),
      );

      // if new value is not empty, update field
      if (newValue != "" || newValue != null) {
        await userCollection.doc(user!.email).update({
          field: newValue,
        });
      }
    }

    void postMassage() {
      // post massage if text is not empty
      if (user!.displayName == null) {
        // use display name from collection if user has not set display name
        userCollection.doc(user!.email).get().then(
          (value) {
            if (value.exists && textController.text.isNotEmpty) {
              FirebaseFirestore.instance.collection("User Post").add({
                "massage": textController.text,
                "TimeStamp": DateTime.now(),
                "UserEmail": user!.email,
                "User": value.data()!['username'],
                "Likes": [],
              });
              textController.clear();
            }
          },
        );
      } else {
        if (textController.text.isNotEmpty) {
          FirebaseFirestore.instance.collection("User Post").add({
            "massage": textController.text,
            "TimeStamp": DateTime.now(),
            "UserEmail": user!.email,
            "User": user!.displayName,
            "Likes": [],
          });
          textController.clear();
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "P R O F I L E",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        // edit profile button
        actions: [
          IconButton(
            onPressed: () {
              // go to EditProfilePage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
            icon: Icon(
              // ... icon
              Icons.more_vert,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            Row(
              children: [
                // profile picture
                Container(
                  padding: const EdgeInsets.all(20),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      // if user has profile picture, use it
                      user!.photoURL ?? 'https://shorturl.at/pvBMR',
                    ),
                  ),
                ),
                // user name
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // user name
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StreamBuilder(
                                  builder: (context, snapshot) {
                                    return Text(
                                      snapshot.hasData
                                          ? snapshot.data!['username']
                                          : 'Loading...',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                  stream: userCollection
                                      .doc(user.email)
                                      .snapshots(),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                // user email
                                Text(
                                  user.email!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // My Posts
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy("TimeStamp", descending: true)
                    .snapshots(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    // user data only current user email
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final post = snapshot.data!.docs[index];
                          if (post['UserEmail'] == user!.email) {
                            return WallPost(
                              massage: post['massage'],
                              user: post['User'],
                              email: post['UserEmail'],
                              postId: post.id,
                              likes: List<String>.from(post['Likes'] ?? []),
                              time: timeToString(post['TimeStamp']),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        });
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error:${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      // add post button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.surface,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add Post'),
                content: TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'Write something...',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    obscureText: false),
                actions: [
                  TextButton(
                    onPressed: () {
                      postMassage();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Post',
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(
          Icons.edit,
          color: Colors.black,
        ),
      ),
    );
  }
}
