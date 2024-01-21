import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:tourlism_root_641463014/Menu/StoreType/list_storetype.dart';

class DeleteStoreTypePage extends StatefulWidget {
  final Map<String, dynamic> data;

  DeleteStoreTypePage({required this.data});

  @override
  _DeleteStoreTypePageState createState() => _DeleteStoreTypePageState();
}

class _DeleteStoreTypePageState extends State<DeleteStoreTypePage> {
  late TextEditingController typeCodeController;
  late TextEditingController typeNameController;

  @override
  void initState() {
    super.initState();
    typeCodeController =
        TextEditingController(text: widget.data['typeCode'].toString());
    typeNameController =
        TextEditingController(text: widget.data['typeName'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ลบประเภทร้านค้า'),
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
                buildReadOnlyField('รหัสประเภท', typeCodeController),
                buildReadOnlyField('ชื่อประเภท', typeNameController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
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

  Widget buildReadOnlyField(
      String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบประเภทนี้'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteStoreType();
              },
              child: Text('ลบ'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteStoreType() async {
    String updatedTypeCode = typeCodeController.text;

    String apiUrl =
        'http://localhost:8080/tourlism/CRUD/crud_storetype.php?case=DELETE';

    try {
      var response = await http.delete(
        Uri.parse(apiUrl),
        body: json.encode({
          'typeCode': updatedTypeCode,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        showSuccessDialog(context, "ลบข้อมูลประเภทร้านค้าเรียบร้อยแล้ว");
      } else {
        showSuccessDialog(
            context, "ลบข้อมูลประเภทร้านค้าไม่สำเร็จ. ${response.body}");
      }
    } catch (error) {
      showSuccessDialog(context, 'Error connecting to the server: $error');
    }
  }

  @override
  void dispose() {
    typeCodeController.dispose();
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
