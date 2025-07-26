import 'package:flutter/material.dart';
import '../models/college.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<College> colleges;
  final Function(College) onToggleInterest;

  const HomeScreen({
    super.key,
    required this.colleges,
    required this.onToggleInterest,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Malik'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        },
    ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search colleges, countries, scholarships...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Recommended Colleges & Courses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                itemCount: colleges.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final college = colleges[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[100 * ((index % 4) + 1)],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          college.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${college.course}\n${college.country}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: () {
                            onToggleInterest(college);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  college.isInterested
                                      ? '"${college.name}" added to Library'
                                      : '"${college.name}" removed from Library',
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            college.isInterested ? Icons.check : Icons.add,
                            size: 16,
                          ),
                          label: Text(college.isInterested ? "Added" : "Interested"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: college.isInterested ? Colors.green : null,
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
