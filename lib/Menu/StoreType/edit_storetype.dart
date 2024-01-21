import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:tourlism_root_641463014/Menu/StoreType/list_storetype.dart';

class EditStoreTypePage extends StatefulWidget {
  final Map<String, dynamic> data;

  EditStoreTypePage({required this.data});

  @override
  _EditStoreTypePageState createState() => _EditStoreTypePageState();
}

class _EditStoreTypePageState extends State<EditStoreTypePage> {
  late TextEditingController codeStoreTypeController;
  late TextEditingController nameStoreTypeController;

  @override
  void initState() {
    super.initState();
    codeStoreTypeController =
        TextEditingController(text: widget.data['typeCode'].toString());
    nameStoreTypeController =
        TextEditingController(text: widget.data['typeName'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขประเภทร้านค้า'),
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
                      'images/laptop.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  buildReadOnlyField(
                      'รหัสประเภทร้านค้า', codeStoreTypeController),
                  TextFormField(
                    controller: nameStoreTypeController,
                    decoration: InputDecoration(
                      labelText: 'ชื่อประเภทร้านค้า',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      String updatedCodeStoreType =
                          codeStoreTypeController.text;
                      String updatedNameStoreType =
                          nameStoreTypeController.text;

                      String apiUrl =
                          'http://localhost:8080/tourlism/CRUD/crud_storetype.php?case=PUT';

                      try {
                        var response = await http.put(
                          Uri.parse(apiUrl),
                          body: json.encode({
                            'codeStoreType': updatedCodeStoreType,
                            'nameStoreType': updatedNameStoreType,
                          }),
                          headers: {'Content-Type': 'application/json'},
                        );

                        if (response.statusCode == 200) {
                          showSuccessDialog(
                            context,
                            "บันทึกข้อมูลประเภทร้านค้าเรียบร้อยแล้ว.",
                          );
                        } else {
                          showSuccessDialog(
                            context,
                            "ไม่สามารถบันทึกข้อมูลประเภทร้านค้าได้. ${response.body}",
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
    codeStoreTypeController.dispose();
    nameStoreTypeController.dispose();
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
                    builder: (context) => StoreTypeListPage(),
                  ),
                );
              },
              child: Text('กลับไปที่รายการประเภทร้านค้า'),
            ),
          ],
        );
      },
    );
  }
}
