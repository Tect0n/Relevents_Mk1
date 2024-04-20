import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Project {
  final TextEditingController projectNameController;
  final Timestamp? startTimestamp;
  final Timestamp? endTimestamp;
  final String? selectedStudentType;
  final TextEditingController projectDescriptionController;
  final TextEditingController contactEmailController;

  Project({
    required this.projectNameController,
    this.startTimestamp,
    this.endTimestamp,
    this.selectedStudentType,
    required this.projectDescriptionController,
    required this.contactEmailController,
  });

  // A method to create a Project object from a Firestore document
  static Project fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Project(
      projectNameController: TextEditingController(text: data['Title']),
      startTimestamp: data['StartDate'],
      endTimestamp: data['EndDate'],
      selectedStudentType: data['StudentType'],
      projectDescriptionController:
          TextEditingController(text: data['Description']),
      contactEmailController: TextEditingController(text: data['contactEmail']),
    );
  }
}
