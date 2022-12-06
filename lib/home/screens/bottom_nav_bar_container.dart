
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sriwallet/home/screens/homepage.dart';

class BottomNavContainer extends StatefulWidget {
  const BottomNavContainer({super.key});

  @override
  State<BottomNavContainer> createState() => _BottomNavContainerState();
}

class _BottomNavContainerState extends State<BottomNavContainer> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
  HomePage(),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 3: Settings',
      style: optionStyle,
    ),    Text(
      'Index 4: Settings',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
              elevation: 10,
        iconSize: 32,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
           
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Cards',
           
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'QR',
           
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sync_outlined),
            label: 'Transfers',
           
          ),
                  BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
           
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
       // backgroundColor: Colors.black,
      ),
    );
  }
}
