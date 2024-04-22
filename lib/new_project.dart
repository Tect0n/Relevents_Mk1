// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relevents/student_homepage.dart';
import 'package:intl/intl.dart';

class NewProject extends StatefulWidget {
  final User user;

  NewProject({required this.user});

  @override
  _NewProjectState createState() => _NewProjectState();
}

class _NewProjectState extends State<NewProject> {
  final TextEditingController projectNameController = TextEditingController();
  Timestamp? startTimestamp;
  Timestamp? endTimestamp;
  String? _selectedStudentType;
  final TextEditingController projectDescriptionController =
      TextEditingController();
  final TextEditingController contactEmailController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic> _userData = {};
  bool isFormFilled = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    initializeCounter();
  }

  void initializeCounter() async {
    DocumentReference counterDocRef =
        _firestore.collection('metadata').doc('projectCounter');
    DocumentSnapshot counterDoc = await counterDocRef.get();

    if (!counterDoc.exists) {
      await counterDocRef.set({'PID': 0});
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
    if (projectDescriptionController.text.isNotEmpty &&
        _selectedStudentType != null &&
        startTimestamp != null &&
        endTimestamp != null) {
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
        await _firestore.collection('metadata').doc('projectCounter').get();
    Map<String, dynamic> data = counterDoc.data() as Map<String, dynamic>;
    int currentCounter = data['PID'] ?? 0;

    int newCounter = currentCounter + 1;

    DocumentReference newProjectRef =
        _firestore.collection('projects').doc(newCounter.toString());

    String lead = _userData['email'];
    String title = projectNameController.text;
    String description = projectDescriptionController.text;
    String contactEmail = contactEmailController.text;

    try {
      await newProjectRef.set({
        'PID': newCounter,
        'Lead': lead,
        'Title': title,
        'StartDate': startTimestamp,
        'EndDate': endTimestamp,
        'StudentType': _selectedStudentType,
        'Description': description,
        'ContactEmail': contactEmail,
      });

      await _firestore
          .collection('metadata')
          .doc('projectCounter')
          .update({'PID': newCounter});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Project'),
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
                        controller: projectNameController,
                        onChanged: (value) {
                          checkFormCompletion();
                        },
                        decoration: InputDecoration(
                          hintText: 'Project Name',
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        maxLength: 50,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Select Date Range

                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () async {
                    final DateTimeRange? dateRange = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(DateTime.now().year - 5),
                      lastDate: DateTime(DateTime.now().year + 5),
                    );

                    if (dateRange != null) {
                      final DateTime startDate = dateRange.start;
                      final DateTime endDate = dateRange.end;
                      // Use the selected date range

                      // Convert the DateTime objects to Timestamps
                      startTimestamp = Timestamp.fromDate(startDate);
                      endTimestamp = Timestamp.fromDate(endDate);

                      checkFormCompletion();

                      // Rebuild the widget to display the selected date range
                      setState(() {});
                    }
                  },
                  child: Text(
                    'Select Date Range',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),

                SizedBox(height: 20),

                if (startTimestamp != null && endTimestamp != null)
                  Text(
                    'Selected Dates: ${DateFormat('dd/MM/yy').format(startTimestamp!.toDate())} - ${DateFormat('dd/MM/yy').format(endTimestamp!.toDate())}',
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

                // Project Description
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
                        controller: projectDescriptionController,
                        maxLines: 5,
                        onChanged: (value) {
                          checkFormCompletion();
                        },
                        decoration: InputDecoration(
                          hintText: 'Project Description',
                          border: InputBorder.none,
                        ),
                        maxLength: 500,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Contact Email

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
                        controller: contactEmailController,
                        onChanged: (value) {
                          checkFormCompletion();
                        },
                        decoration: InputDecoration(
                          hintText: 'Contact Email',
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
                              content: Text('Project registered successfully!'),
                            ),
                          );
                          Navigator.pop(context, 'projectCreated');
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
