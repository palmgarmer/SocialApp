import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/components/home/WallPost.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedPage extends StatelessWidget {
  FeedPage({super.key});
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
      userCollection.doc(user!.email).get().then(
        (value) {
          if (value.exists && textController.text.isNotEmpty) {
            FirebaseFirestore.instance.collection("User Posts").add({
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
        FirebaseFirestore.instance.collection("User Posts").add({
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // wall post
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy("TimeStamp", descending: true)
                    .snapshots(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final post = snapshot.data!.docs[index];

                          return WallPost(
                            massage: post['massage'],
                            user: post['User'],
                            email: post['UserEmail'],
                            postId: post.id,
                            likes: List<String>.from(post['Likes'] ?? []),
                            time: timeToString(post['TimeStamp']),
                          );
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
          Icons.mode_edit,
          color: Colors.black,
        ),
      ),
    );
  }
}
