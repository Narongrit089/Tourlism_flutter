import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tourlism_root_641463014/Menu/Location/edit_location.dart';
import 'package:tourlism_root_641463014/Menu/Location/delete_location.dart';
import 'package:tourlism_root_641463014/Menu/Location/detail_location.dart';
import 'package:tourlism_root_641463014/Menu/Location/insert_location.dart';

class LocationListPage extends StatefulWidget {
  @override
  _LocationListPageState createState() => _LocationListPageState();
}

class _LocationListPageState extends State<LocationListPage> {
  bool isHovered = false;
  late Future<List<Map<String, dynamic>>> _locationData;

  Future<List<Map<String, dynamic>>> _fetchLocationData() async {
    final response = await http.get(Uri.parse(
        'http://localhost:8080/tourlism/CRUD/crud_location.php?case=GET'));

    if (response.statusCode == 200) {
      final dynamic parsed = json.decode(response.body);

      if (parsed is Map<String, dynamic>) {
        if (parsed.containsKey("data") && parsed["data"] is List<dynamic>) {
          return parsed["data"].cast<Map<String, dynamic>>();
        } else {
          throw Exception('Invalid format for location data');
        }
      } else if (parsed is List<dynamic>) {
        return parsed.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Invalid format for location data');
      }
    } else {
      throw Exception('Failed to fetch location data');
    }
  }

  @override
  void initState() {
    super.initState();
    _locationData = _fetchLocationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สถานที่ท่องเที่ยว'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _locationData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No location data available');
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 20.0,
                    headingTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    dataRowColor: MaterialStateColor.resolveWith((states) {
                      return Colors.blue.withOpacity(0.1);
                    }),
                    columns: <DataColumn>[
                      DataColumn(label: Text('ชื่อสถานที่ท่องเที่ยว')),
                      DataColumn(label: Text('รายละเอียด')),
                      DataColumn(label: Text('เพิ่มเติม')),
                      DataColumn(label: Text('แก้ไข')),
                      DataColumn(label: Text('ลบ')),
                    ],
                    rows: snapshot.data!.map((data) {
                      return DataRow(
                        cells: <DataCell>[
                          DataCell(
                            Text(
                              data['nameLo']?.toString() ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataCell(Text(data['details']?.toString() ?? '')),
                          DataCell(
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        LocationDetailPage(data: data),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'images/ss.png',
                                width: 27,
                                height: 27,
                              ),
                            ),
                          ),
                          DataCell(
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditLocationPage(data: data),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'images/edit.png',
                                width: 27,
                                height: 27,
                              ),
                            ),
                          ),
                          DataCell(
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DeleteLocationPage(data: data),
                                  ),
                                );
                              },
                              child: Image.asset(
                                'images/delete1.png',
                                width: 27,
                                height: 27,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: FloatingActionButton(
          onPressed: () {
            // Add your logic to navigate to the page for adding data
            // For example:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InsertLocationPage(),
              ),
            );
          },
          child: isHovered
              ? Text(
                  'เพิ่ม',
                  style: TextStyle(
                      // สามารถปรับแต่งสไตล์ของ Text ในส่วนนี้ตามที่ต้องการ
                      ),
                )
              : Icon(Icons.add),
          hoverColor: Colors.blue,
          foregroundColor:
              Colors.white, // เพิ่ม foregroundColor เพื่อกำหนดสีของ icon/text
          backgroundColor: isHovered
              ? Colors.blue[800]
              : Colors.blue, // ปรับสีพื้นหลังเมื่อ Hover
          elevation: isHovered ? 8 : 4, // ปรับความสูงของ shadows เมื่อ Hover
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LocationListPage(),
  ));
}
