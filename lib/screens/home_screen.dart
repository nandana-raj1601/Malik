import 'package:flutter/material.dart';
import 'library_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final List<String> savedColleges = [];
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
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
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

            // Recommended Section Title
            const Text(
              'Recommended Colleges & Courses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Grid of Cards (2 per row)
            Expanded(
              child: GridView.builder(
                itemCount: 6, // Adjust as needed
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
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
                          'College ${index + 1}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'MSc in Computer Science\nGermany',
                          style: TextStyle(fontSize: 12),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                            onPressed: () {
                        final collegeName = 'College ${index + 1}';
                        if (!savedColleges.contains(collegeName)) {
                            setState(() {
                            savedColleges.add(collegeName);
                            });
                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added $collegeName to Library')),
                        );
                        } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$collegeName is already in your Library')),
                            );
                        }
                        },

                          icon: const Icon(Icons.add, size: 16),
                          label: const Text("Interested"),
                          style: ElevatedButton.styleFrom(
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
