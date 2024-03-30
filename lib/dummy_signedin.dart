import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DummySignedInPage extends StatelessWidget {
  final String email;

  DummySignedInPage({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Center(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('student').doc(email).get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
              String name = data['name'];
              print(data);
              return Text('Hello, $name');
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}