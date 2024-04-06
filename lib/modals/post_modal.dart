import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String userId;

  final String userName;

  final Timestamp timestamp;

  final String imageUrl;

  final String description;

  final String postID;

  Post({
    required this.timestamp,
    required this.description,
    required this.imageUrl,
    required this.userId,
    required this.userName,
    required this.postID,
  });

  Post.fromSnapshot(QueryDocumentSnapshot doc)
      : timestamp = doc["timeStamp"] as Timestamp,
        description = doc["description"] as String,
        imageUrl = doc["imageUrl"] as String,
        userId = doc["userId"] as String,
        userName = doc["userName"] as String,
        postID = doc.data().toString().contains("postID")? doc.get("postID"):'';
}
