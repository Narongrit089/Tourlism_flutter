import 'package:flutter/material.dart';
import 'package:tourlism_root_641463014/Login&Regis/Login.dart';

import 'package:tourlism_root_641463014/Menu/Location/list_location.dart';
import 'package:tourlism_root_641463014/Menu/StoreType/list_storetype.dart';
import 'package:tourlism_root_641463014/Menu/StoreName/list_storename.dart';
import 'package:tourlism_root_641463014/Menu/BusTable/list_bustable.dart';

class MenuPage extends StatelessWidget {
  final List<MenuButtonModel> menuItems = [
    MenuButtonModel('สถานที่ท่องเที่ยว', 'images/loca.png'),
    MenuButtonModel('ประเภทร้านค้า', 'images/laptop.png'),
    MenuButtonModel('ชื่อร้านค้า', 'images/store.png'),
    MenuButtonModel('ตารางการเดินรถ', 'images/bus-schedule.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('ท่องเที่ยวเชียงราย'),
          backgroundColor: Color.fromARGB(255, 24, 131, 252),
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          itemCount: menuItems.length,
          padding: EdgeInsets.all(16.0),
          itemBuilder: (BuildContext context, int index) {
            return CustomMenuButton(
              label: menuItems[index].label,
              imagePath: menuItems[index].imagePath,
              onPressed: () {
                navigateToPage(context, menuItems[index].label);
              },
            );
          },
        ),
      ),
    );
  }

  void navigateToPage(BuildContext context, String label) {
    switch (label) {
      case 'สถานที่ท่องเที่ยว':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LocationListPage()),
        );
        break;
      // Add cases for other menu items if needed
      case 'ประเภทร้านค้า':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StoreTypeListPage()),
        );
        break;
      case 'ชื่อร้านค้า':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StoreNameListPage()),
        );
        break;
      case 'ตารางการเดินรถ':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BusTableListPage()),
        );
        break;
      default:
        print('Invalid menu label: $label');
    }
  }
}

class MenuButtonModel {
  final String label;
  final String imagePath;

  MenuButtonModel(this.label, this.imagePath);
}

class CustomMenuButton extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onPressed;

  const CustomMenuButton({
    required this.label,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 24, 131, 252).withOpacity(0.9),
              Color.fromARGB(255, 24, 131, 252).withOpacity(0.5),
            ],
          ),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
