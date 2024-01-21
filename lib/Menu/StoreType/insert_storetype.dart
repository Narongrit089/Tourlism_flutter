import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:tourlism_root_641463014/Menu/StoreType/list_storetype.dart';

class InsertStoreTypePage extends StatefulWidget {
  @override
  _InsertStoreTypePageState createState() => _InsertStoreTypePageState();
}

class _InsertStoreTypePageState extends State<InsertStoreTypePage> {
  late TextEditingController typeNameController;

  @override
  void initState() {
    super.initState();
    typeNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มประเภทร้านค้า'),
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
                    'images/laptop.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                buildTextField('ชื่อประเภทร้านค้า', typeNameController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String typeName = typeNameController.text;

                    String apiUrl =
                        'http://localhost:8080/tourlism/CRUD/crud_storetype.php?case=POST';

                    try {
                      var response = await http.post(
                        Uri.parse(apiUrl),
                        body: json.encode({
                          'typeName': typeName,
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
      ),
    );
  }

  @override
  void dispose() {
    typeNameController.dispose();
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
