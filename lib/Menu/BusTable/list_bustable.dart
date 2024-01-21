import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tourlism_root_641463014/Menu/BusTable/edit_bustable.dart';
import 'package:tourlism_root_641463014/Menu/BusTable/insert_bustable.dart';
import 'package:tourlism_root_641463014/Menu/BusTable/delete_bustable.dart';
import 'package:tourlism_root_641463014/Menu/BusTable/detail_bustable.dart';

class BusTableListPage extends StatefulWidget {
  @override
  _BusTableListPageState createState() => _BusTableListPageState();
}

class _BusTableListPageState extends State<BusTableListPage> {
  bool isHovered = false;
  late Future<List<Map<String, dynamic>>> _busTableData;

  Future<List<Map<String, dynamic>>> _fetchBusTableData() async {
    final response = await http.get(Uri.parse(
        'http://localhost:8080/tourlism/CRUD/crud_bustable.php?case=GET'));

    if (response.statusCode == 200) {
      final dynamic parsed = json.decode(response.body);

      if (parsed is Map<String, dynamic>) {
        if (parsed.containsKey("data") && parsed["data"] is List<dynamic>) {
          return parsed["data"].cast<Map<String, dynamic>>();
        } else {
          throw Exception('Invalid format for bus table data');
        }
      } else if (parsed is List<dynamic>) {
        return parsed.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Invalid format for bus table data');
      }
    } else {
      throw Exception('Failed to fetch bus table data');
    }
  }

  @override
  void initState() {
    super.initState();
    _busTableData = _fetchBusTableData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตารางการเดินรถ'),
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
            future: _busTableData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No bus table data available');
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
                      DataColumn(label: Text('ลำดับ')),
                      DataColumn(label: Text('เวลา')),
                      DataColumn(label: Text('เพิ่มเติม')),
                      DataColumn(label: Text('แก้ไข')),
                      DataColumn(label: Text('ลบ')),
                    ],
                    rows: snapshot.data!.map((data) {
                      return DataRow(
                        cells: <DataCell>[
                          DataCell(
                            Text(
                              data['no']?.toString() ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataCell(Text(data['time']?.toString() ?? '')),

                          // Add DataCell with GestureDetector and appropriate icon for Edit operation
                          DataCell(
                            GestureDetector(
                              onTap: () {
                                // Add your logic for editing
                                // For example:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BusTableDetailPage(data: data),
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
                                // Add your logic for editing
                                // For example:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditBusTablePage(data: data),
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
                          // Add DataCell with GestureDetector and appropriate icon for Delete operation
                          DataCell(
                            GestureDetector(
                              onTap: () {
                                // Add your logic for deleting
                                // For example:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DeleteBusTablePage(data: data),
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
      // Add FloatingActionButton for adding new bus schedules
      floatingActionButton: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: FloatingActionButton(
          onPressed: () {
            // Add your logic to navigate to the page for adding new bus schedules
            // For example:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InsertBusTablePage(),
              ),
            );
          },
          child: isHovered
              ? Text(
                  'เพิ่ม',
                  style: TextStyle(),
                )
              : Icon(Icons.add),
          hoverColor: Colors.blue,
          foregroundColor: Colors.white,
          backgroundColor: isHovered ? Colors.blue[800] : Colors.blue,
          elevation: isHovered ? 8 : 4,
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BusTableListPage(),
  ));
}
