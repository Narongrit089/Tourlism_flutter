import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:tourlism_root_641463014/Menu/Location/list_location.dart';

class EditLocationPage extends StatefulWidget {
  final Map<String, dynamic> data;

  EditLocationPage({required this.data});

  @override
  _EditLocationPageState createState() => _EditLocationPageState();
}

class _EditLocationPageState extends State<EditLocationPage> {
  late TextEditingController codeLoController;
  late TextEditingController nameLoController;
  late TextEditingController detailsController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;

  @override
  void initState() {
    super.initState();
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
        title: Text('แก้ไขสถานที่ท่องเที่ยว'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                  buildReadOnlyField('รหัส', codeLoController),
                  TextFormField(
                    controller: nameLoController,
                    decoration: InputDecoration(
                      labelText: 'ชื่อสถานที่ท่องเที่ยว',
                    ),
                  ),
                  TextFormField(
                    controller: detailsController,
                    decoration: InputDecoration(
                      labelText: 'รายละเอียด',
                    ),
                  ),
                  TextFormField(
                    controller: latitudeController,
                    decoration: InputDecoration(
                      labelText: 'ละติจูด',
                    ),
                  ),
                  TextFormField(
                    controller: longitudeController,
                    decoration: InputDecoration(
                      labelText: 'ลองจิจูด',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      String updatedCodeLo = codeLoController.text;
                      String updatedNameLo = nameLoController.text;
                      String updatedDetails = detailsController.text;
                      String updatedLatitude = latitudeController.text;
                      String updatedLongitude = longitudeController.text;

                      String apiUrl =
                          'http://localhost:8080/tourlism/CRUD/crud_location.php?case=PUT';

                      try {
                        var response = await http.put(
                          Uri.parse(apiUrl),
                          body: json.encode({
                            'codeLo': updatedCodeLo,
                            'nameLo': updatedNameLo,
                            'details': updatedDetails,
                            'latitude': updatedLatitude,
                            'longitude': updatedLongitude,
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
                        Image.asset('images/edit.png', width: 20, height: 20),
                        SizedBox(width: 8),
                        Text('บันทึกข้อมูล'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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

  @override
  void dispose() {
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
