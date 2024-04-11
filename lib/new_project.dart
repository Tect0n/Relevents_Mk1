// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class NewProject extends StatefulWidget {
  @override
  _NewProjectState createState() => _NewProjectState();
}

class _NewProjectState extends State<NewProject> {
  final TextEditingController projectNameController = TextEditingController();
  String? _selectedStudentType;

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
                    }
                  },
                  child: Text(
                    'Select Date Range',
                    style: TextStyle(color: Colors.blue),
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
                        maxLines: 5,
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
                  onPressed: () {
                    // Submit the form
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
