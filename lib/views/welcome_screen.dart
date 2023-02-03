import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key, required this.title});

  final String title;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[40],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/assets/images/On_the_go_reminder_logo.png',
                height: 130, width: 130),
            const SizedBox(height: 20),
            const Text(
              'On the Go Reminder',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: Colors.deepPurpleAccent),
              textAlign: TextAlign.center,
            ),
            const Padding(
              padding:
                  EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 40),
              //apply padding to all four sides
              child: Text(
                'An app that makes your life more organized. Simple and easy to use design.',
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(15)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.deepPurpleAccent),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Colors.deepPurpleAccent),
                  ),
                ),
              ),
              onPressed: () => null,
              child: Text(
                "Log In".toUpperCase(),
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 30),
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.all(15)),
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.deepPurpleAccent),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Colors.deepPurpleAccent),
                  ),
                ),
              ),
              onPressed: () => null,
              child: Text(
                "Sign Up".toUpperCase(),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
