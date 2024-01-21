import 'package:flutter/material.dart';

class StoreNameDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  StoreNameDetailPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดชื่อร้าน'),
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
                    'images/store.png', // แทนที่รูปภาพตามที่คุณต้องการ
                    width: 50,
                    height: 50,
                  ),
                ),
                buildDetailField('รหัสร้าน', data['storeCode']),
                buildDetailField('ชื่อร้าน', data['storeName']),
                buildDetailField('รหัสประเภทร้าน', data['typeCode']),
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
