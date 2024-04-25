// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relevents/student_homepage.dart';
import 'package:intl/intl.dart';

/*
class NewSurvey extends StatefulWidget {
  @override
  _NewSurveyState createState() => _NewSurveyState();
}

class _NewSurveyState extends State<NewSurvey> {
  final TextEditingController surveyNameController = TextEditingController();
  String? _selectedStudentType;
  final TextEditingController surveyDescriptionController =
      TextEditingController();
  final TextEditingController surveyLinkController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void registerSurvey() async {
    String name = surveyNameController.text;
    String description = surveyDescriptionController.text;
    String link = surveyLinkController.text;

    try {
      await _firestore.collection('surveys').add({
        'name': name,
        'studentType': _selectedStudentType,
        'description': description,
        'link': link,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Survey registered successfully!'),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Survey'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),

                    // Project Name
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: surveyNameController,
                        decoration: InputDecoration(
                          hintText: 'Survey Name',
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        maxLength: 50,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Select Student Type
                DropdownButton<String>(
                  value: _selectedStudentType,
                  hint: Text('Select Student Type'),
                  items: <String>['Computing', 'Business', 'Science', 'Art']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStudentType = newValue;
                    });
                  },
                ),

                SizedBox(height: 20),

                // Survey Description
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
                        controller: surveyDescriptionController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Survey Description',
                          border: InputBorder.none,
                        ),
                        maxLength: 500,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Survey Link

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
                        controller: surveyLinkController,
                        decoration: InputDecoration(
                          hintText: 'Survey Link',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Submit Button

                ElevatedButton(
                  onPressed: () {
                    registerSurvey();
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/

class NewSurvey extends StatefulWidget {
  final User user;

  NewSurvey({required this.user});

  @override
  _NewSurveyState createState() => _NewSurveyState();
}

class _NewSurveyState extends State<NewSurvey> {
  final TextEditingController surveyNameController = TextEditingController();
  String? _selectedStudentType;
  final TextEditingController surveyDescriptionController =
      TextEditingController();
  final TextEditingController surveyLinkController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic> _userData = {};
  bool isFormFilled = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    initializeSurveyCounter();
  }

  void initializeSurveyCounter() async {
    DocumentReference counterDocRef =
        _firestore.collection('metadata').doc('SurveyCounter');
    DocumentSnapshot counterDoc = await counterDocRef.get();

    if (!counterDoc.exists) {
      await counterDocRef.set({'SID': 0});
    }
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    DocumentSnapshot doc =
        await _firestore.collection('student').doc(widget.user.uid).get();
    if (mounted) {
      setState(() {
        _userData = doc.data() as Map<String, dynamic>;
      });
    }
  }

  void checkFormCompletion() {
    if (surveyDescriptionController.text.isNotEmpty &&
        _selectedStudentType != null &&
        surveyNameController.text.isNotEmpty != null &&
        surveyLinkController.text.isNotEmpty) {
      setState(() {
        isFormFilled = true;
      });
    } else {
      setState(() {
        isFormFilled = false;
      });
    }
  }

  void registerProject() async {
    DocumentSnapshot counterDoc =
        await _firestore.collection('metadata').doc('SurveyCounter').get();
    Map<String, dynamic> data = counterDoc.data() as Map<String, dynamic>;
    int currentCounter = data['SID'] ?? 0;

    int newCounter = currentCounter + 1;

    DocumentReference newProjectRef =
        _firestore.collection('surveys').doc(newCounter.toString());

    String lead = _userData['email'];
    String title = surveyNameController.text;
    String description = surveyDescriptionController.text;
    String link = surveyLinkController.text;

    try {
      await newProjectRef.set({
        'SID': newCounter,
        'Lead': lead,
        'Title': title,
        'StudentType': _selectedStudentType,
        'Description': description,
        'Link': link,
      });

      await _firestore
          .collection('metadata')
          .doc('SurveyCounter')
          .update({'SID': newCounter});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Survey'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),

                    // Project Name
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: surveyNameController,
                        onChanged: (value) {
                          checkFormCompletion();
                        },
                        decoration: InputDecoration(
                          hintText: 'Survey Name',
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        maxLength: 50,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Select Student Type
                DropdownButton<String>(
                  value: _selectedStudentType,
                  hint: Text('Select Student Type'),
                  items: <String>['Computing', 'Business', 'Science', 'Art']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStudentType = newValue;
                      checkFormCompletion();
                    });
                  },
                ),

                SizedBox(height: 20),

                // Survey Description
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
                        controller: surveyDescriptionController,
                        maxLines: 5,
                        onChanged: (value) {
                          checkFormCompletion();
                        },
                        decoration: InputDecoration(
                          hintText: 'Survey Description',
                          border: InputBorder.none,
                        ),
                        maxLength: 500,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Survey Link

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
                        controller: surveyLinkController,
                        onChanged: (value) {
                          checkFormCompletion();
                        },
                        decoration: InputDecoration(
                          hintText: 'Survey Link',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Submit Button

                ElevatedButton(
                  onPressed: isFormFilled
                      ? () async {
                          registerProject();
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Survey registered successfully!'),
                            ),
                          );
                          Navigator.pop(context, 'surveyCreated');
                        }
                      : null,
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.blue),
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
