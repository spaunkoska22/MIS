import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:on_the_go_reminder/views/main_screen.dart';
import 'package:on_the_go_reminder/views/register_screen.dart';

class LogInScreen extends StatefulWidget {
  static const String idScreen = "signInScreen";

  const LogInScreen({super.key});

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loginFail = false;
  bool passwordError = false;
  bool emailError = false;
  String loginErrorMessage = "";

  Future _logIn() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) {
        print("User logged in");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
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

  PreferredSizeWidget _createAppBar(BuildContext context) {
    return AppBar(
      title: const Text("On the Go Reminder"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[40],
      resizeToAvoidBottomInset: false,
      appBar: _createAppBar(context),
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.1, 20, 0),
          child: Column(
            children: <Widget>[
              Image.asset('lib/assets/images/On_the_go_reminder_logo.png',
                  height: 180, width: 180),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
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
                      border: const OutlineInputBorder(),
                      labelText: "Password",
                      errorText: passwordError ? loginErrorMessage : null),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 10),
              signUpOption(),
              const SizedBox(height: 80),
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
                onPressed: () => _logIn(),
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
        const Text("Don't have an account? "),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegisterScreen()));
          },
          child: const Text(
            "Register",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
        ),
      ],
    );
  }
}
