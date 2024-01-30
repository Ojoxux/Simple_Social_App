import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/components/my_back_button.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  //current logged in user
  //ログインしているユーザー
  final User? currentUser = FirebaseAuth.instance.currentUser;

  //future to fetch user details
  //ユーザーの詳細を取得するためのfuture
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        initialData: null,
        builder: (context, snapshot) {
          //loading...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          //error
          else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }

          //data received
          //memo
          //以前、FireStoreにないユーザデータでログインし、エラーが起こったことがあったので
          //_TypeErrorが出たらまずはFireStoreにデータがあるか確認すること。
          else if (snapshot.hasData) {
            //extract data
            Map<String, dynamic>? user = snapshot.data!.data();

            /*
            //dubug code
            if (snapshot != null) {
              // ここでデバッグコードやログを挿入
              print("snapshot is null");
            }
            */

            /*
            //nullではないことを担保しておくif文
            Map<String, dynamic>? user;
            if (snapshot.hasData) {
              user = snapshot.data!.data();
            } else {
              user = null;
            }
            */

            return Center(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //const SizedBox(height: 150),
                  //back button
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 50.0,
                      left: 25,
                    ),
                    child: Row(
                      children: [
                        MyBackButton(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  //profile picture
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.all(25),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // username
                  
                  Text(
                    user!['username'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  

                  //これだと行ける
                  //Text(user!['username']),

                  const SizedBox(height: 10),

                  // email
                  Text(
                    user['email'],
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  

                  //これだと行ける
                  //Text(user['email']),
                ],
              ),
            );
          } else {
            return Text("No data");
          }
        },
      ),
    );
  }
}
