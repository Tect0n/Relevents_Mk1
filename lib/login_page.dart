// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relevents/dummy_signedin.dart';
import 'package:relevents/org_dummy.dart';
import 'package:relevents/org_homepage.dart';
import 'package:relevents/register_choose.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:relevents/student_homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';
  String errorMessage =
      'Login failed! Please check your details and try again.';
  bool rememberMe = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Check if user details are remembered
    checkRememberedUser();
  }

  // Function to check if user details are remembered
  Future<void> checkRememberedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = prefs.getBool('rememberMe') ?? false;
      if (rememberMe) {
        email = prefs.getString('email') ?? '';
        password = prefs.getString('password') ?? '';
        emailController.text = email;
        passwordController.text = password;
      }
    });
  }

  // Function to sign in the user

  Future<void> signInUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Remember user details if "Remember Me" is checked
      if (rememberMe) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', emailController.text);
        await prefs.setString('password', passwordController.text);
        await prefs.setBool('rememberMe', true);
      } else {
        // Clear remembered user details if "Remember Me" is unchecked
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('email');
        await prefs.remove('password');
        await prefs.remove('rememberMe');
      }

      DocumentSnapshot orgDoc = await FirebaseFirestore.instance
          .collection('organizer')
          .doc(userCredential.user!.uid)
          .get();

      if (orgDoc.exists) {
        // The user is an organizer
        // Map<String, dynamic> orgData = orgDoc.data() as Map<String, dynamic>;

        // Navigate to the organizer welcome page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => OrgHomePage(user: userCredential.user!)),
        );
      } else {
        // The user is not an organizer
        // Navigate to the regular welcome page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  StudentHomePage(user: userCredential.user!)),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unknown error occurred.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Relevents logo
                Container(
                    width: 200,
                    height: 200,
                    child: Image.asset('assets/Relevents_logo.jpg')),

                SizedBox(height: 10),

                // Welcome to Relevents
                Text(
                  'Welcome to Relevents',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  // style: GoogleFonts.signikaNegative(
                  //  fontSize: 30,
                  // fontWeight: FontWeight.bold,
                  // ),
                ),

                SizedBox(height: 10),

                // Tagline
                Text(
                  'Connecting students to career building events!',
                  style: TextStyle(fontSize: 15),
                ),

                SizedBox(height: 30),

                // Email

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            border: InputBorder.none,
                          ),
                        ),
                      )),
                ),

                SizedBox(height: 10),

                // Password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: InputBorder.none,
                          ),
                        ),
                      )),
                ),

                SizedBox(height: 10),

                // Remember me
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: rememberMe,
                      activeColor: Colors.blue, // Set the color to blue
                      onChanged: (bool? value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      },
                    ),
                    Text('Remember me'),
                  ],
                ),

                SizedBox(height: 5),

                // login button
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: GestureDetector(
                    onTap: signInUser,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // Register button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterChoosePage()),
                        );
                      },
                      child: Text(" Register here!",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          )),
                    )
                  ],
                )
              ],
            )),
          ),
        ));
  }
}
