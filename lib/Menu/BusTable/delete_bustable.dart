import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:tourlism_root_641463014/Menu/Bustable/list_bustable.dart';

class DeleteBusTablePage extends StatefulWidget {
  final Map<String, dynamic> data;

  DeleteBusTablePage({required this.data});

  @override
  _DeleteBusTablePageState createState() => _DeleteBusTablePageState();
}

class _DeleteBusTablePageState extends State<DeleteBusTablePage> {
  late TextEditingController noController;
  late TextEditingController timeController;
  late TextEditingController codeLoController;

  @override
  void initState() {
    super.initState();
    noController = TextEditingController(text: widget.data['no'].toString());
    timeController =
        TextEditingController(text: widget.data['time'].toString());
    codeLoController =
        TextEditingController(text: widget.data['codeLo'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ลบข้อมูลตารางการเดินรถ'),
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
                    'images/bus-schedule.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                buildReadOnlyField('ลำดับ', noController),
                buildReadOnlyField('เวลา', timeController),
                buildReadOnlyField('รหัสสถานที่', codeLoController),
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
          content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบตารางการเดินรถนี้'),
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
                await deleteBusTable();
              },
              child: Text('ลบ'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteBusTable() async {
    String updatedNo = noController.text;

    String apiUrl =
        'http://localhost:8080/tourlism/CRUD/crud_bustable.php?case=DELETE';

    try {
      var response = await http.delete(
        Uri.parse(apiUrl),
        body: json.encode({
          'no': updatedNo,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        showSuccessDialog(context, "ลบข้อมูลตารางการเดินรถเรียบร้อยแล้ว");
      } else {
        showSuccessDialog(
            context, "ลบข้อมูลตารางการเดินรถไม่สำเร็จ. ${response.body}");
      }
    } catch (error) {
      showSuccessDialog(context, 'Error connecting to the server: $error');
    }
  }

  @override
  void dispose() {
    noController.dispose();
    timeController.dispose();
    codeLoController.dispose();
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
                    builder: (context) => BusTableListPage(),
                  ),
                );
              },
              child: Text('กลับไปที่รายการตารางการเดินรถ'),
            ),
          ],
        );
      },
    );
  }
}
