import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:tourlism_root_641463014/Menu/StoreName/list_storename.dart';

class DeleteStoreNamePage extends StatefulWidget {
  final Map<String, dynamic> data;

  DeleteStoreNamePage({required this.data});

  @override
  _DeleteStoreNamePageState createState() => _DeleteStoreNamePageState();
}

class _DeleteStoreNamePageState extends State<DeleteStoreNamePage> {
  late TextEditingController storeCodeController;
  late TextEditingController storeNameController;
  late TextEditingController typeCodeController;

  @override
  void initState() {
    super.initState();
    storeCodeController =
        TextEditingController(text: widget.data['storeCode'].toString());
    storeNameController =
        TextEditingController(text: widget.data['storeName'].toString());
    typeCodeController =
        TextEditingController(text: widget.data['typeCode'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ลบข้อมูลชื่อร้านค้า'),
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
                  // You can replace the image asset path with your own.
                  child: Image.asset(
                    'images/store.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                buildReadOnlyField('รหัสร้านค้า', storeCodeController),
                buildReadOnlyField('ชื่อร้านค้า', storeNameController),
                buildReadOnlyField('รหัสประเภท', typeCodeController),
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
          content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบร้านค้านี้'),
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
                await deleteStoreName();
              },
              child: Text('ลบ'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteStoreName() async {
    String updatedStoreCode = storeCodeController.text;

    String apiUrl =
        'http://localhost:8080/tourlism/CRUD/crud_storename.php?case=DELETE';

    try {
      var response = await http.delete(
        Uri.parse(apiUrl),
        body: json.encode({
          'storeCode': updatedStoreCode,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        showSuccessDialog(context, "ลบข้อมูลร้านค้าเรียบร้อยแล้ว");
      } else {
        showSuccessDialog(
            context, "ลบข้อมูลร้านค้าไม่สำเร็จ. ${response.body}");
      }
    } catch (error) {
      showSuccessDialog(context, 'Error connecting to the server: $error');
    }
  }

  @override
  void dispose() {
    storeCodeController.dispose();
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
