import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:tourlism_root_641463014/Menu/StoreName/list_storename.dart';

class InsertStoreNamePage extends StatefulWidget {
  @override
  _InsertStoreNamePageState createState() => _InsertStoreNamePageState();
}

class _InsertStoreNamePageState extends State<InsertStoreNamePage> {
  late TextEditingController storeNameController;
  late TextEditingController typeCodeController;

  @override
  void initState() {
    super.initState();
    storeNameController = TextEditingController();
    typeCodeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มชื่อร้านค้า'),
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
                    'images/store.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                buildTextField('ชื่อร้านค้า', storeNameController),
                buildTextField('รหัสประเภทร้านค้า', typeCodeController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String storeName = storeNameController.text;
                    String typeCode = typeCodeController.text;

                    String apiUrl =
                        'http://localhost:8080/tourlism/CRUD/crud_storename.php?case=POST';

                    try {
                      var response = await http.post(
                        Uri.parse(apiUrl),
                        body: json.encode({
                          'storeName': storeName,
                          'typeCode': typeCode,
                        }),
                        headers: {'Content-Type': 'application/json'},
                      );

                      if (response.statusCode == 200) {
                        showSuccessDialog(
                          context,
                          "บันทึกข้อมูลร้านค้าเรียบร้อยแล้ว.",
                        );
                      } else {
                        showSuccessDialog(
                          context,
                          "ไม่สามารถบันทึกข้อมูลร้านค้าได้. ${response.body}",
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
    storeNameController.dispose();
    typeCodeController.dispose();
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
                    builder: (context) => StoreNameListPage(),
                  ),
                );
              },
              child: Text('กลับไปที่รายการร้านค้า'),
            ),
          ],
        );
      },
    );
  }
}
