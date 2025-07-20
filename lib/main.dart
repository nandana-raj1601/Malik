import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/roadmap_screen.dart';
import 'screens/library_screen.dart';


void main() {
  runApp(const MalikApp());
}

class MalikApp extends StatefulWidget {
  const MalikApp({super.key});

  @override
  State<MalikApp> createState() => _MalikAppState();
}

class _MalikAppState extends State<MalikApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    RoadmapScreen(),
    LibraryScreen(savedColleges: []),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Malik',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Roadmap'),
            BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Library'),
          ],
        ),
      ),
    );
  }
}
