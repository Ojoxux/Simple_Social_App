import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/components/my_button.dart';
import 'package:social_app/components/my_textfield.dart';
import 'package:social_app/helper/helper_functions.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  //login method
  void login() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Image.asset('assets/loading-image-green.gif'),
        //child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      //pop loading circle
      if (context.mounted) Navigator.pop(context);
    }

    //display any error
    on FirebaseAuthException catch (e) {
      //pop loading circle
      Navigator.pop(context);
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //person logo

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

              //app name
              const Text(
                "M i i v e r s e",
                style: TextStyle(fontSize: 20),
              ),

              SizedBox(height: 50),

              //email textfield
              MyTextField(
                hintText: "Email",
                obsecureText: false,
                controller: emailController,
              ),

              SizedBox(height: 10),

              //password textfield
              MyTextField(
                hintText: "Password",
                obsecureText: true,
                controller: passwordController,
              ),

              SizedBox(height: 10),

              //forgot password
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

              //sign in button
              MyButton(
                text: "Login",
                onTap: login,
              ),

              SizedBox(height: 25),

              //dont have an account?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Register Here",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const Image(
                image: AssetImage('assets/images/welcome-image.png'),
                width: 500,
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
