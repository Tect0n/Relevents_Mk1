// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:relevents/dummy_signedin.dart';
import 'package:relevents/register_choose.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';
  String errorMessage = '';
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signInUser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Navigate to the next page if sign in was successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DummySignedInPage(email: emailController.text)),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided for that user.';
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'An unknown error occurred.';
      });
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
                Text('Welcome to Relevents', 
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
                Text('Connecting students to career building events!',
                style: TextStyle(
                  fontSize: 15),
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
                        padding: const EdgeInsets.only(left : 20.0),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            border: InputBorder.none,
                          ),
                        ),
                      )
                      ),
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
                        padding: const EdgeInsets.only(left : 20.0),
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: InputBorder.none,
                          ),
                        ),
                      )
                      ),
                  ),
        
                  SizedBox(height: 25),

                  // Error message
                  Text(
                    errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                    ),
                  ),
        
        
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
                          child: Text('Login',
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
                  Text("Not a member?", style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterChoosePage()),
                      );
                    },
                    child: Text(" Register here!", style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                     ) 
                    ),
                  )
                ],
              )
        
        
        
            ],)
            
            
            
            ),
        ),
      )
    );
  }
}