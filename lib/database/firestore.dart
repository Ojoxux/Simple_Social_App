/*

This database stores posts that users have publisehd in the app.
It is stored in a collection calld 'Posts' in Firebase.

Each post contains;
- a message
- email of user
- timestamp

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase {
  //current logged in user
  User? user = FirebaseAuth.instance.currentUser;

  //get collection of posts from firebase
  final CollectionReference posts =
      FirebaseFirestore.instance.collection("Posts");

  //post a message
  Future<void> addPost(String message) {
    return posts.add({
      'UserEmail': user!.email,
      'PostMessage': message,
      'Timestamp': Timestamp.now(),
    });
  }

  //read posts from database
  Stream<QuerySnapshot> getPostsStream() {
    final postsStream = FirebaseFirestore.instance
        .collection("Posts")
        .orderBy("Timestamp", descending: true)
        .snapshots();

    return postsStream;
  }
}
