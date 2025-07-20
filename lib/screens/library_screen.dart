import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  final List<String> savedColleges;

  const LibraryScreen({super.key, required this.savedColleges});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Library')),
      body: savedColleges.isEmpty
          ? const Center(child: Text("No colleges saved yet."))
          : ListView.builder(
              itemCount: savedColleges.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.school),
                  title: Text(savedColleges[index]),
                );
              },
            ),
    );
  }
}
