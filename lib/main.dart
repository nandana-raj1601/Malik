import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/roadmap_screen.dart';
import 'screens/library_screen.dart';
import 'models/college.dart';

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

  // Centralized list
  final List<College> _colleges = [
    College(name: "MIT", course: "MS in CS", country: "USA"),
    College(name: "ETH Zurich", course: "MS in EE", country: "Switzerland"),
    College(name: "TUM", course: "MSc in Informatics", country: "Germany"),
    College(name: "NUS", course: "MComp in CS", country: "Singapore"),
    College(name: "Toronto", course: "MSc in CS", country: "Canada"),
    College(name: "IISc", course: "MTech in Signal Proc", country: "India"),
  ];

  void _toggleInterest(College college) {
    setState(() {
      final index = _colleges.indexWhere((c) => c.name == college.name);
      if (index != -1) {
        _colleges[index].isInterested = !_colleges[index].isInterested;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        colleges: _colleges,
        onToggleInterest: _toggleInterest,
      ),
      RoadmapScreen(
  degreeYear: '4th Year', // or get this from user/profile
  targetIntake: 'Fall 2026', // or get this from user/profile
),
      LibraryScreen(
        savedColleges: _colleges.where((c) => c.isInterested).toList(),
        onRemoveInterest: _toggleInterest,
      ),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Malik',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
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
