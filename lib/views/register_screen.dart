import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:on_the_go_reminder/views/welcome_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String idScreen = "registerScreen";

  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future _signUp() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) {
        print("Created new account");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WelcomePage(title: "Sara")));
      });
    } on FirebaseAuthException catch (e) {
      print("ERROR HERE");
      print(e.message);
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
                      labelText: "Enter your email"),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  controller: passwordController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter your password"),
                  obscureText: true,
                ),
              ),
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
                onPressed: () => _signUp(),
                child: Text(
                  "Sign Up".toUpperCase(),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
