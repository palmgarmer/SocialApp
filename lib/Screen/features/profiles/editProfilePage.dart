import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/components/home/text_box.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  void _signOutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userCollection = FirebaseFirestore.instance.collection('Users');

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

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color:
              // if dark mode is enabled, then use white color
              Brightness.dark == Theme.of(context).brightness
                  ? Colors.white
                  : Colors.grey,
        ),
        title: Text(
          "P R O F I L E",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(user!.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // get user data
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                const SizedBox(height: 50),
                // user profile
                Center(
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        // if user profile pic is empty, use default image
                        userData['profilePic'] == ""
                            ? "https://shorturl.at/pvBMR"
                            : userData['profilePic'],
                      )),
                ),
                const SizedBox(height: 20),

                // user name
                Center(
                  child: Text(
                    userData['username'],
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // user detail
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text('My detail'),
                ),

                // username
                MyTextBox(
                  sectionName: 'Username',
                  text: userData['username'],
                  onPressed: () => editField('username'),
                ),

                // bio
                MyTextBox(
                  sectionName: 'Bio',
                  text: userData['bio'],
                  onPressed: () => editField('bio'),
                ),

                // user post
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error' + snapshot.error.toString()),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // sign out button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _signOutUser();
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.logout,
          color: Colors.black,
        ),
      ),
    );
  }
}
