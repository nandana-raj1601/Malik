import 'package:flutter/material.dart';
import '../models/college.dart';

class LibraryScreen extends StatelessWidget {
  final List<College> savedColleges;
  final Function(College) onRemoveInterest;

  const LibraryScreen({
    super.key,
    required this.savedColleges,
    required this.onRemoveInterest,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Library')),
      body: savedColleges.isEmpty
          ? const Center(child: Text("No colleges saved yet."))
          : ListView.builder(
              itemCount: savedColleges.length,
              itemBuilder: (context, index) {
                final college = savedColleges[index];
                return ListTile(
                  leading: const Icon(Icons.school),
                  title: Text(college.name),
                  subtitle: Text('${college.course} • ${college.country}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      onRemoveInterest(college);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('"${college.name}" removed from Library')),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
