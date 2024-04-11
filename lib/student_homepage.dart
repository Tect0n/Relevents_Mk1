// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:relevents/new_project.dart';
import 'package:relevents/new_survey.dart';
//import 'package:popup_card/styles.dart';

import 'CustomRectTween.dart';
import 'hero_dialog_route.dart';

class StudentHomePage extends StatefulWidget {
  final User user;

  StudentHomePage({required this.user});

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

// This is the state for the StudentHomePage widget
class _StudentHomePageState extends State<StudentHomePage> {
  // This is the index for the currently selected screen
  int _selectedIndex = 0;

  // This is a map to store the user data fetched from Firebase
  Map<String, dynamic> _userData = {};

  // This is a list of titles for the screens
  static const List<String> _titles = [
    "Home",
    "Calendar",
    "Projects and Surveys",
    "Profile",
    "Settings"
  ];

  // This method is called when this state object is created
  @override
  void initState() {
    super.initState();
    // Fetch the user data when the state is initialized
    _fetchUserData();
  }

  // This method fetches the user data from Firebase
  Future<void> _fetchUserData() async {
    // Get the document for the current user
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('student')
        .doc(widget.user.uid)
        .get();
    // Update _userData with the fetched data
    setState(() {
      _userData = doc.data() as Map<String, dynamic>;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define your screens here with widget.user passed to HomeScreen
    final _screens = [
      HomeScreen(user: widget.user),
      CalendarScreen(),
      AddScreen(),
      AccountScreen(user: widget.user, userData: _userData),
      SettingsScreen(),
    ];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: _userData.isEmpty
              ? CircularProgressIndicator()
              : _selectedIndex == 0
                  ? Text('Welcome ${_userData['name']}')
                  : Text(_titles[_selectedIndex]),
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.blue,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final User user;

  HomeScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // App bar

        // Body of the page
        body: Column(
      children: <Widget>[
        Flexible(
          child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Events for you :',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  CarouselSlider(
                    options: CarouselOptions(
                        height: MediaQuery.of(context).size.height * 0.2),
                    items: [1, 2, 3, 4, 5].map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Center(
                                child: Text(
                                  'Event $i',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ));
                        },
                      );
                    }).toList(),
                  ),
                ]),
          ),
        ),

        // Project carousel
        Flexible(
          child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 15),
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Projects for you :',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  CarouselSlider(
                    options: CarouselOptions(
                        height: MediaQuery.of(context).size.height * 0.2),
                    items: [1, 2, 3, 4, 5].map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Center(
                                child: Text(
                                  'Project $i',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ));
                        },
                      );
                    }).toList(),
                  ),
                ]),
          ),
        ),

        //SizedBox(height: 30),

        // Survey carousel
        Flexible(
          child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 50),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Surveys for you :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 15),
                  CarouselSlider(
                    options: CarouselOptions(
                        height: MediaQuery.of(context).size.height * 0.1),
                    items: [1, 2, 3, 4, 5].map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Center(
                                child: Text(
                                  'Survey $i',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ));
                        },
                      );
                    }).toList(),
                  ),
                ]),
          ),
        ),
      ],
    ));
  }
}

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Your content for CalendarScreen
    return Container();
  }
}

class AddScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text("Click the + to add a project or survey"),
          ),
          // Add more widgets here...

          AddJobButton(),
        ],
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  final User user;
  final Map<String, dynamic> userData;

  AccountScreen({required this.user, required this.userData});

  @override
  Widget build(BuildContext context) {
    // Your content for AddScreen
    return Container();
  }
}

class SettingsScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text(
          'Logout',
          style: TextStyle(fontSize: 25, color: Colors.blue),
        ),
        onPressed: () async {
          await _auth.signOut();
          // Navigate to the login screen after logging out
          Navigator.of(context).pushReplacementNamed('/login');
        },
      ),
    );
  }
}

class AddJobButton extends StatelessWidget {
  /// {@macro add_todo_button}
  const AddJobButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(
              builder: (context) {
                return const _AddJobPopupCard();
              },
              settings: RouteSettings(name: '/addJobPopupCard')));
        },
        child: Hero(
          tag: '_heroAddJob',

          /*
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },*/

          child: Material(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: const Icon(
              Icons.add_rounded,
              size: 56,
            ),
          ),
        ),
      ),
    );
  }
}

class _AddJobPopupCard extends StatelessWidget {
  const _AddJobPopupCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: '_heroAddJob',
          createRectTween: (begin, end) {
            return RectTween(begin: begin, end: end);
          },
          child: Material(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: AnimatedContainer(
              duration: Duration(seconds: 1),
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => NewProject(),
                              ),
                            );
                          },
                          child: const Text('Project',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                              )),
                        ),
                        const Divider(
                          color: Colors.white,
                          thickness: 0.2,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => NewSurvey(),
                              ),
                            );
                          },
                          child: const Text('Survey',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                              )),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
