import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:on_the_go_reminder/views/welcome_screen.dart';

import 'register_screen.dart';

class SignInScreen extends StatefulWidget {
  static const String idScreen = "signInScreen";

  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loginFail = false;
  bool passwordError = false;
  bool emailError = false;
  String loginErrorMessage = "";

  Future _signIn() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) {
        print("User signed in");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WelcomePage(title: "Sara")));
      });
    } on FirebaseAuthException catch (e) {
      print("ERROR HERE");
      print(e.message);
      loginFail = true;
      loginErrorMessage = e.message!;

      if (loginErrorMessage ==
          "There is no user record corresponding to this identifier. The user may have been deleted.") {
        emailError = true;
        loginErrorMessage = "User does not exist, please create an account";
      } else {
        passwordError = true;
        loginErrorMessage = "Incorrect password";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[40],
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Column(
            children: <Widget>[
              Image.asset('lib/assets/images/On_the_go_reminder_logo.png',
                  height: 130, width: 130),
              const Text(
                'On the Go Reminder',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.deepPurpleAccent),
                textAlign: TextAlign.center,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                      errorText: emailError ? loginErrorMessage : null),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  controller: passwordController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      errorText: passwordError ? loginErrorMessage : null),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 10),
              signUpOption(),
              SizedBox(height: 100),
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(15)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.deepPurpleAccent),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.deepPurpleAccent),
                    ),
                  ),
                ),
                onPressed: () => _signIn(),
                child: Text(
                  "Log In".toUpperCase(),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("No account? Create one for free! "),
        GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()));
            },
            child: const Text(
              "SIGN UP here",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
      ],
    );
  }
}
