import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:tourlism_root_641463014/Menu/Location/list_location.dart';

class DeleteLocationPage extends StatefulWidget {
  final Map<String, dynamic> data;

  DeleteLocationPage({required this.data});

  @override
  _DeleteLocationPageState createState() => _DeleteLocationPageState();
}

class _DeleteLocationPageState extends State<DeleteLocationPage> {
  // Remove TextEditingController for readonly fields
  late TextEditingController codeLoController;
  late TextEditingController nameLoController;
  late TextEditingController detailsController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with data
    codeLoController =
        TextEditingController(text: widget.data['codeLo'].toString());
    nameLoController =
        TextEditingController(text: widget.data['nameLo'].toString());
    detailsController =
        TextEditingController(text: widget.data['details'].toString());
    latitudeController =
        TextEditingController(text: widget.data['latitude'].toString());
    longitudeController =
        TextEditingController(text: widget.data['longitude'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ลบข้อมูลสถานที่ท่องเที่ยว'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Display data without allowing user input

                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Image.asset(
                    'images/loca.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                buildReadOnlyField('รหัส', codeLoController),
                buildReadOnlyField('ชื่อสถานที่ท่องเที่ยว', nameLoController),
                buildReadOnlyField('รายละเอียด', detailsController),
                buildReadOnlyField('ละติจูด', latitudeController),
                buildReadOnlyField('ลองจิจูด', longitudeController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Show confirmation dialog
                    showConfirmationDialog(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/delete1.png', width: 20, height: 20),
                      SizedBox(width: 8),
                      Text('ลบข้อมูล'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create readonly form field
  Widget buildReadOnlyField(
      String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true, // Set to true to disable user input
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }

  // Helper method to show confirmation dialog
  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบสถานที่นี้'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () async {
                // Close the confirmation dialog
                Navigator.of(context).pop();
                // Perform the delete operation
                await deleteLocation();
              },
              child: Text('ลบ'),
            ),
          ],
        );
      },
    );
  }

  // Helper method to perform the delete operation
  Future<void> deleteLocation() async {
    String updatedCodeLo = codeLoController.text;

    String apiUrl =
        'http://localhost:8080/tourlism/CRUD/crud_location.php?case=DELETE';

    try {
      var response = await http.delete(
        Uri.parse(apiUrl),
        body: json.encode({
          'codeLo': updatedCodeLo,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        showSuccessDialog(context, "ลบข้อมูลสถานที่เรียบร้อยแล้ว");
      } else {
        showSuccessDialog(
            context, "ลบข้อมูลสถานที่ไม่สำเร็จ. ${response.body}");
      }
    } catch (error) {
      showSuccessDialog(context, 'Error connecting to the server: $error');
    }
  }

  @override
  void dispose() {
    // Dispose text controllers
    codeLoController.dispose();
    nameLoController.dispose();
    detailsController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                // Navigate back to the Location List page
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationListPage(),
                  ),
                );
              },
              child: Text('กลับไปที่รายการสถานที่'),
            ),
          ],
        );
      },
    );
  }
}
