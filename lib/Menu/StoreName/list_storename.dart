import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tourlism_root_641463014/Menu/StoreName/edit_storename.dart';
import 'package:tourlism_root_641463014/Menu/StoreName/insert_storename.dart';
import 'package:tourlism_root_641463014/Menu/StoreName/delete_storename.dart';
import 'package:tourlism_root_641463014/Menu/StoreName/detail_storename.dart';

class StoreNameListPage extends StatefulWidget {
  @override
  _StoreNameListPageState createState() => _StoreNameListPageState();
}

class _StoreNameListPageState extends State<StoreNameListPage> {
  bool isHovered = false;
  late Future<List<Map<String, dynamic>>> _storeNameData;

  Future<List<Map<String, dynamic>>> _fetchStoreNameData() async {
    final response = await http.get(Uri.parse(
        'http://localhost:8080/tourlism/CRUD/crud_storename.php?case=GET'));

    if (response.statusCode == 200) {
      final dynamic parsed = json.decode(response.body);

      if (parsed is Map<String, dynamic>) {
        if (parsed.containsKey("data") && parsed["data"] is List<dynamic>) {
          return parsed["data"].cast<Map<String, dynamic>>();
        } else {
          throw Exception('Invalid format for store name data');
        }
      } else if (parsed is List<dynamic>) {
        return parsed.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Invalid format for store name data');
      }
    } else {
      throw Exception('Failed to fetch store name data');
    }
  }

  @override
  void initState() {
    super.initState();
    _storeNameData = _fetchStoreNameData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ชื่อร้านค้า'),
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
            future: _storeNameData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No store name data available');
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
                      DataColumn(label: Text('ชื่อร้านค้า')),
                      DataColumn(label: Text('เพิ่มเติม')),
                      DataColumn(label: Text('แก้ไข')),
                      DataColumn(label: Text('ลบ')),
                    ],
                    rows: snapshot.data!.map((data) {
                      return DataRow(
                        cells: <DataCell>[
                          DataCell(
                            Text(
                              data['storeName']?.toString() ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
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
                                        StoreNameDetailPage(data: data),
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
                                        EditStoreNamePage(data: data),
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
                                        DeleteStoreNamePage(data: data),
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
      // Add FloatingActionButton for adding new store names
      floatingActionButton: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: FloatingActionButton(
          onPressed: () {
            // Add your logic to navigate to the page for adding new store names
            // For example:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InsertStoreNamePage(),
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
    home: StoreNameListPage(),
  ));
}
