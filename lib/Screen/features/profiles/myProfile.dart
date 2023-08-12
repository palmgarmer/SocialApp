import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/Screen/features/profiles/editProfilePage.dart';
import 'package:social_app/components/home/WallPost.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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

    void postMassage() {
      // post massage if text is not empty
      if (user!.displayName == null) {
        // use display name from collection if user has not set display name
        userCollection.doc(user.email).get().then(
          (value) {
            if (value.exists && textController.text.isNotEmpty) {
              FirebaseFirestore.instance.collection("User Post").add({
                "massage": textController.text,
                "TimeStamp": DateTime.now(),
                "UserEmail": user.email,
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
            "UserEmail": user.email,
            "User": user.displayName,
            "Likes": [],
          });
          textController.clear();
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              "P R O F I L E",
              style: TextStyle(
                color:
                    // if dark mode, use white
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
              ),
            ),
          ],
        ),
        backgroundColor:
            // if dark mode, use black
            Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
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
        color:
            // if dark mode, use black
            Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),

            // Profile Pic
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  // if user has profile picture, use it
                  user!.photoURL ?? 'https://shorturl.at/pvBMR',
                ),
              ),
            ),
            // Profile Name
            Text(
              user.displayName == null
                  ? "Loading..."
                  : user.displayName.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            // Profile Email
            Text(
              user.email.toString(),
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(
              height: 30,
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
                          if (post['UserEmail'] == user.email) {
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
