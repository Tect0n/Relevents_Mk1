import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class org_dummy extends StatelessWidget {
  final User user;

  org_dummy({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Center(
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('organizer')
              .where('email', isEqualTo: user.email)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data!.docs.isNotEmpty) {
                Map<String, dynamic> data =
                    snapshot.data!.docs.first.data() as Map<String, dynamic>;
                String name = data['name'];
                String orgname = data['orgname'];
                return Text('Welcome, $name from $orgname!');
              } else {
                return Text('No organizer found with that email');
              }
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
