import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:tourlism_root_641463014/Menu/Location/list_location.dart';

class InsertLocationPage extends StatefulWidget {
  @override
  _InsertLocationPageState createState() => _InsertLocationPageState();
}

class _InsertLocationPageState extends State<InsertLocationPage> {
  late TextEditingController nameLoController;
  late TextEditingController detailsController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;

  @override
  void initState() {
    super.initState();
    nameLoController = TextEditingController();
    detailsController = TextEditingController();
    latitudeController = TextEditingController();
    longitudeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มสถานที่ท่องเที่ยว'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5.0,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                buildTextField('ชื่อสถานที่ท่องเที่ยว', nameLoController),
                buildTextField('รายละเอียด', detailsController),
                buildTextField('ละติจูด', latitudeController),
                buildTextField('ลองจิจูด', longitudeController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String nameLo = nameLoController.text;
                    String details = detailsController.text;
                    String latitude = latitudeController.text;
                    String longitude = longitudeController.text;

                    String apiUrl =
                        'http://localhost:8080/tourlism/CRUD/crud_location.php?case=POST';

                    try {
                      var response = await http.post(
                        Uri.parse(apiUrl),
                        body: json.encode({
                          'nameLo': nameLo,
                          'details': details,
                          'latitude': latitude,
                          'longitude': longitude,
                        }),
                        headers: {'Content-Type': 'application/json'},
                      );

                      if (response.statusCode == 200) {
                        showSuccessDialog(
                          context,
                          "บันทึกข้อมูลสถานที่เรียบร้อยแล้ว.",
                        );
                      } else {
                        showSuccessDialog(
                          context,
                          "ไม่สามารถบันทึกข้อมูลสถานที่ได้. ${response.body}",
                        );
                      }
                    } catch (error) {
                      print('Error: $error');
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/sign.png', width: 20, height: 20),
                      SizedBox(width: 8),
                      Text('เพิ่มข้อมูล'),
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

  Widget buildTextField(String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        // prefixIcon: Image.asset('images/delete1.png', width: 20, height: 20),
      ),
    );
  }

  @override
  void dispose() {
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
                // รีเฟรชหน้า List
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
