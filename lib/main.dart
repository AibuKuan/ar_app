import 'package:flutter/material.dart';

import 'screens/scanner_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NavigatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({super.key});
  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text('Home Screen')),
    // ARViewScreen(),
    ScannerScreen(),
    Center(child: Text('Library Screen')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AR Capstone')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.view_headline),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_headline),
            label: 'Scanner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_headline),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}