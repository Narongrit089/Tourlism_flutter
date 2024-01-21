import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:tourlism_root_641463014/Menu/BusTable/list_bustable.dart';

class InsertBusTablePage extends StatefulWidget {
  @override
  _InsertBusTablePageState createState() => _InsertBusTablePageState();
}

class _InsertBusTablePageState extends State<InsertBusTablePage> {
  late TextEditingController timeController;
  late TextEditingController codeLoController;

  @override
  void initState() {
    super.initState();
    timeController = TextEditingController();
    codeLoController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มตารางการเดินรถ'),
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
                    'images/bus-schedule.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                buildTextFieldTime('เวลา', timeController),
                buildTextField('รหัสสถานที่', codeLoController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String time = timeController.text;
                    String codeLo = codeLoController.text;

                    String apiUrl =
                        'http://localhost:8080/tourlism/CRUD/crud_bustable.php?case=POST';

                    try {
                      var response = await http.post(
                        Uri.parse(apiUrl),
                        body: json.encode({
                          'time': time,
                          'codeLo': codeLo,
                        }),
                        headers: {'Content-Type': 'application/json'},
                      );

                      if (response.statusCode == 200) {
                        showSuccessDialog(
                          context,
                          "บันทึกข้อมูลตารางการเดินรถเรียบร้อยแล้ว.",
                        );
                      } else {
                        showSuccessDialog(
                          context,
                          "ไม่สามารถบันทึกข้อมูลตารางการเดินรถได้. ${response.body}",
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

  Widget buildTextFieldTime(
      String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            );
          },
        );

        if (pickedTime != null) {
          // แปลงเวลาที่ได้มาในรูปแบบ 24 ชั่วโมง
          DateTime dateTime =
              DateTime(2022, 1, 1, pickedTime.hour, pickedTime.minute);
          controller.text =
              DateFormat.Hm().format(dateTime); // ใช้รูปแบบเวลา 24 ชั่วโมง
        }
      },
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: Icon(Icons.access_time),
      ),
    );
  }

  @override
  void dispose() {
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
                // รีเฟรชหน้า List
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BusTableListPage(),
                  ),
                );
              },
              child: Text('ปิด'),
            ),
          ],
        );
      },
    );
  }
}
