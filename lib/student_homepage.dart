// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentHomePage extends StatefulWidget {
  final User user;

  StudentHomePage({required this.user});

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Define your screens here with widget.user passed to HomeScreen
    final _screens = [
      HomeScreen(user: widget.user),
      CalendarScreen(),
      AddScreen(),
      AccountScreen(user: widget.user),
      SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('student')
              .doc(widget.user.uid)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Text('Welcome ${data['name']}');
            }

            return CircularProgressIndicator();
          },
        ),
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
            label: 'Account',
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
        appBar: AppBar(
          title: Text('Home'),
        ),

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
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
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
    Text("Your projects : ");
    return Container();
  }
}

class AccountScreen extends StatelessWidget {
  final User user;

  AccountScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('student').doc(user.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          String name = data['name'];
          return Text('Ooga Booga $name',
              style: TextStyle(fontWeight: FontWeight.bold));
        }

        return CircularProgressIndicator();
      },
    );
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

























/*

class _StudentHomePageState extends State<StudentHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar
      appBar: AppBar(
        title: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('student')
              .doc(widget.user.uid)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              String name = data['name'];
              return Text('Welcome $name',
                  style: TextStyle(fontWeight: FontWeight.bold));
            }

            return CircularProgressIndicator();
          },
        ),
      ),

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
      ),

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
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
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.blue,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (_selectedIndex == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentHomePage(user: widget.user),
                ),
              );


            } else if (_selectedIndex == 1) {
              Navigator.pushNamed(context, '/calendar');

            } else if (_selectedIndex == 2) {
              Navigator.pushNamed(context, '/add');

            } else if (_selectedIndex == 3) {
              Navigator.pushNamed(context, '/account');

              

            } else if (_selectedIndex == 4) {
              Navigator.pushNamed(context, '/settings');

            }



          });
        },
      ),
    );
  }
}
*/