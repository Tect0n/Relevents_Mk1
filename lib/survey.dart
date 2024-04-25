import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Survey {
  final int SID;
  final String lead;
  final TextEditingController surveyNameController;
  final String? selectedStudentType;
  final TextEditingController surveyDescriptionController;
  final TextEditingController surveyLinkController;

  Survey({
    required this.SID,
    required this.lead,
    required this.surveyNameController,
    this.selectedStudentType,
    required this.surveyDescriptionController,
    required this.surveyLinkController,
  });

  // A method to create a Project object from a Firestore document
  static Survey fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Survey(
      SID: data['SID'],
      lead: data['Lead'],
      surveyNameController: TextEditingController(text: data['Title']),
      selectedStudentType: data['StudentType'],
      surveyDescriptionController:
          TextEditingController(text: data['Description']),
      surveyLinkController: TextEditingController(text: data['Link']),
    );
  }
}
