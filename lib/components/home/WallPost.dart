import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/components/home/comment.dart';
import 'package:social_app/components/home/commentButton.dart';
import 'package:social_app/components/home/deleteButton.dart';
import 'package:social_app/components/home/likeButton.dart';
import 'package:social_app/components/home/shareButton.dart';
import 'package:timeago/timeago.dart' as timeago;

enum SampleItem { itemOne, itemTwo, itemThree }

class WallPost extends StatefulWidget {
  final String massage;
  final String user;
  final String email;
  final String time;
  final String postId;
  final List<String> likes;
  const WallPost({
    super.key,
    required this.massage,
    required this.user,
    required this.email,
    required this.time,
    required this.postId,
    required this.likes,
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  // User
  final currentUser = FirebaseAuth.instance.currentUser!;

  bool isLike = false;
  bool isComment = false;
  int commentCount = 0;

  SampleItem? selectedMenu;

  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLike = widget.likes.contains(currentUser.email);
  }

  // toggle like
  void toggleLike() {
    setState(() {
      isLike = !isLike;
    });

    // Access the Document is Firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);

    if (isLike) {
      // if post is now liked, add user's user to likes field
      postRef.update({
        "Likes": FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      // if post is now unliked, remove user's user from likes field
      postRef.update({
        "Likes": FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  // add comment
  void addComment(String commentText) {
    // write comment to firestore under the comment collection for this post if comment is not empty
    if (commentText.isNotEmpty) {
      FirebaseFirestore.instance
          .collection("User Posts")
          .doc(widget.postId)
          .collection("Comments")
          .add({
        "CommentText": commentText,
        "CommentBy": currentUser.displayName,
        "CommentByEmail": currentUser.email,
        "CommentTime": Timestamp.now(),
      });

      // update comment count in post
      FirebaseFirestore.instance
          .collection("User Posts")
          .doc(widget.postId)
          .update({
        "CommentCount": FieldValue.increment(1),
      });
    }
  }

  // show dialog for adding comment
  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add a comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: InputDecoration(
            hintText: "Write a comment...",
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // add comment
              addComment(_commentTextController.text);

              // clear text field
              _commentTextController.clear();

              // close dialog
              Navigator.pop(context);
            },
            child: const Text(
              "Comment",
            ),
          ),
        ],
      ),
    );
  }

  // share post
  void sharePost() {
    // copy post text to clipboard

    // show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Post copied to clipboard"),
      ),
    );
  }

  // delete post
  void deletePost() {
    // show dialog to confirm delete
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        content: const Text("Are you sure you want to delete this post?"),
        actions: [
          TextButton(
            onPressed: () async {
              // get all comments for this post
              // then delete comment first
              final commentDocs = await FirebaseFirestore.instance
                  .collection("User Posts")
                  .doc(widget.postId)
                  .collection("Comments")
                  .get();
              for (var doc in commentDocs.docs) {
                await FirebaseFirestore.instance
                    .collection("User Posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .doc(doc.id)
                    .delete();
              }

              // delete post
              await FirebaseFirestore.instance
                  .collection("User Posts")
                  .doc(widget.postId)
                  .delete()
                  .then((value) => print("Post Deleted"))
                  .catchError(
                      (onError) => print("Failed to delete post: $onError"));

              // close dialog
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
          TextButton(
            onPressed: () {
              // close dialog
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  String timeToString(Timestamp time) {
    DateTime dateTime = time.toDate();

    String timeAgo = timeago.format(dateTime).toString();

    // return formatted string
    return timeAgo;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(top: 1, left: 1, right: 1),
      padding: const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // group of text (massage, user, time)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.user,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      const Text(" · "),
                      Text(
                        widget.time,
                        style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.massage,
                  ),
                ],
              ),

              if (currentUser.email == widget.email)
                PopupMenuButton<SampleItem>(
                  initialValue: selectedMenu,
                  // Callback that sets the selected popup menu item.
                  onSelected: (SampleItem item) {
                    setState(() {
                      selectedMenu = item;
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<SampleItem>>[
                    PopupMenuItem<SampleItem>(
                      value: SampleItem.itemOne,
                      child: DeleteButton(onTap: deletePost),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // const SizedBox(width: 50),

              // like button
              MyLikeButton(
                isLike: isLike,
                onTap: toggleLike,
                likeCount: widget.likes.length,
              ),

              // const SizedBox(width: 50),

              // comment button
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .snapshots(),
                builder: (context, snapshot) {
                  // if comment count > 0 isComment is true
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      isComment = true;
                    } else {
                      isComment = false;
                    }
                  }

                  // show loading if snapshot is not ready
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return CommentButton(
                    onTap: showCommentDialog,
                    isComment: isComment,
                    commentCount: snapshot.data!.docs.length,
                  );
                },
              ),

              // const SizedBox(width: 50),

              // share button
              ShareButton(
                onTap: sharePost,
                isShare: true,
                shareCount: 5,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // comment under the post
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("User Posts")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy("CommentTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              // show loading if snapshot is not ready
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  // get comment data
                  final commentData = doc.data() as Map<String, dynamic>;

                  // return comment widget
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Comment(
                      text: commentData["CommentText"],
                      user: commentData["CommentBy"],
                      time: timeToString(commentData["CommentTime"]),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
