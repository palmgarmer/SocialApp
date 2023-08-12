import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderEmail;
  final String reciverEmail;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderEmail,
    required this.reciverEmail,
    required this.message,
    required this.timestamp,
  });  

  // convert to map
  Map<String, dynamic> toMap() {
    return {
      'senderEmail': senderEmail,
      'reciverEmail': reciverEmail,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
