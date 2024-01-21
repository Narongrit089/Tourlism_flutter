import 'package:flutter/material.dart';

class LocationDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  LocationDetailPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลสถานที่เพิ่มเติม'),
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
                buildDetailField('รหัส', data['codeLo']),
                buildDetailField('ชื่อสถานที่ท่องเที่ยว', data['nameLo']),
                buildDetailField('รายละเอียด', data['details']),
                buildDetailField('ละติจูด', data['latitude']),
                buildDetailField('ลองจิจูด', data['longitude']),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDetailField(String labelText, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        '$labelText: $value',
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}
