import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/components/my_button.dart';
import 'package:social_app/components/my_textfield.dart';
import 'package:social_app/helper/helper_functions.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  //login method
  void registerUser() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Image.asset('assets/loading-image-green.gif'),
        //child: CircularProgressIndicator(),
      ),
    );

    //make sure password match
    //パスワードが一致するようにする
    if (passwordController.text != confirmPwController.text) {
      //top loading circle
      Navigator.pop(context);

      //show error message to user
      //ユーザーにエラーメッセージを表示する
      displayMessageToUser("Passwords do not match!", context);
    }

    //if password do match
    //パスワードが一致した場合
    else {
      try {
        //create the user
        UserCredential? userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        //create a user document and add to firestore
        //ユーザーのドキュメントを作成して、firestoreに追加する
        createUserDocument(userCredential);

        //pop loading circle
        if(context.mounted) Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        //pop loading circle
        Navigator.pop(context);

        //display error message to user
        //ユーザーにエラーメッセージを表示する
        displayMessageToUser(e.code, context);
      }
    }
  }

  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
            'email': userCredential.user!.email,
            'username': usernameController.text,
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 150),

              /*
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              */
              const Image(
                image: AssetImage('assets/images/Miiverse_logo.png'),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),

              SizedBox(height: 25),
              const Text(
                "M i i v e r s e",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 50),
              MyTextField(
                hintText: "Username",
                obsecureText: false,
                controller: usernameController,
              ),
              SizedBox(height: 10),
              MyTextField(
                hintText: "Email",
                obsecureText: false,
                controller: emailController,
              ),
              SizedBox(height: 10),
              MyTextField(
                hintText: "Password",
                obsecureText: true,
                controller: passwordController,
              ),
              SizedBox(height: 10),
              MyTextField(
                hintText: "Confirm Password",
                obsecureText: true,
                controller: confirmPwController,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot Password?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                ],
              ),
              SizedBox(height: 25),
              MyButton(
                text: "Register",
                onTap: registerUser,
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Login Here",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}