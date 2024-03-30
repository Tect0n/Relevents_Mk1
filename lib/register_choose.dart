// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_org.dart';
import 'register_student.dart';

class RegisterChoosePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left : 20),
                  child: Text("Are you a Student or an Organizer?", style: TextStyle(fontSize: 30, fontWeight : FontWeight.bold,),),
                ),
                SizedBox(height: 50),
                Container(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StudentRegisterPage()),
                      );
                    },
                    child: Text('I am a Student', style: TextStyle(fontSize: 25, color: Colors.blue),),
                  ),
                ),
                SizedBox(height: 50),
                Container(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrganizerRegisterPage()),
                      );
                    },
                    child: Text('I am an Organizer', style: TextStyle(fontSize: 25, color: Colors.blue,)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}