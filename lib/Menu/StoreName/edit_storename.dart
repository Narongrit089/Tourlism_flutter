import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tourlism_root_641463014/Menu/StoreName/list_storename.dart';

class EditStoreNamePage extends StatefulWidget {
  final Map<String, dynamic> data;

  EditStoreNamePage({required this.data});

  @override
  _EditStoreNamePageState createState() => _EditStoreNamePageState();
}

class _EditStoreNamePageState extends State<EditStoreNamePage> {
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
        title: Text('แก้ไขข้อมูลร้านค้า'),
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
                      'images/store.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  buildReadOnlyField('รหัสร้านค้า', storeCodeController),
                  TextFormField(
                    controller: storeNameController,
                    decoration: InputDecoration(
                      labelText: 'ชื่อร้านค้า',
                    ),
                  ),
                  TextFormField(
                    controller: typeCodeController,
                    decoration: InputDecoration(
                      labelText: 'รหัสประเภทร้านค้า',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      String updatedStoreCode = storeCodeController.text;
                      String updatedStoreName = storeNameController.text;
                      String updatedTypeCode = typeCodeController.text;

                      String apiUrl =
                          'http://localhost:8080/tourlism/CRUD/crud_storename.php?case=PUT';

                      try {
                        var response = await http.put(
                          Uri.parse(apiUrl),
                          body: json.encode({
                            'storeCode': updatedStoreCode,
                            'storeName': updatedStoreName,
                            'typeCode': updatedTypeCode,
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
