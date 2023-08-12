import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_app/Screen/model/massage.dart';

class ChatService extends ChangeNotifier {
  // get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // send message
  Future<void> sendMessage(String recivedEmail, String message) async {
    // get current user id
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderEmail: currentUserEmail,
      reciverEmail: recivedEmail,
      message: message,
      timestamp: timestamp,
    );

    // constrct chat room id from current user id and recived user id (sort to ensure uniqueness)
    List<String> ids = [currentUserEmail, recivedEmail];
    ids.sort();
    String chatRoomID = ids.join("_");

    // add a new message to database
    await _firestore
        .collection("chatRooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // get messages
  Stream<QuerySnapshot> getMessage(String userEmail, String otherUserEmail) {
    // constuct chat room id form user ids (sort to ensure it matches the id user when sending message)
    List<String> ids = [userEmail, otherUserEmail];
    ids.sort();
    String chatRoomID = ids.join("_");

    // get messages from database
    return _firestore
        .collection("chatRooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
