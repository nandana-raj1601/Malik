import 'package:flutter/material.dart';
import 'roadmap_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Provider;
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _degreeYear;
  String? _branch;
  String? _targetIntake;
  List<String> _preferredCountries = [];

  final List<String> degreeYears = ['1st Year', '2nd Year', '3rd Year', '4th Year'];
  final List<String> branches = ['Computer Science', 'Mechanical', 'Electrical', 'Civil', 'Other'];
  final List<String> intakes = ['Spring 2026', 'Fall 2026', 'Spring 2027', 'Fall 2027'];
  final List<String> countries = ['USA', 'UK', 'Canada', 'Australia', 'Germany', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Degree Year'),
                items: degreeYears
                    .map((year) => DropdownMenuItem(value: year, child: Text(year)))
                    .toList(),
                value: _degreeYear,
                onChanged: (val) => setState(() => _degreeYear = val),
                validator: (val) => val == null ? 'Please select degree year' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Branch'),
                items: branches
                    .map((branch) => DropdownMenuItem(value: branch, child: Text(branch)))
                    .toList(),
                value: _branch,
                onChanged: (val) => setState(() => _branch = val),
                validator: (val) => val == null ? 'Please select branch' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Target Intake'),
                items: intakes
                    .map((intake) => DropdownMenuItem(value: intake, child: Text(intake)))
                    .toList(),
                value: _targetIntake,
                onChanged: (val) => setState(() => _targetIntake = val),
                validator: (val) => val == null ? 'Please select intake' : null,
              ),
              const SizedBox(height: 16),
              InputDecorator(
                decoration: const InputDecoration(labelText: 'Preferred Countries'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: countries.map((country) {
                    return CheckboxListTile(
                      title: Text(country),
                      value: _preferredCountries.contains(country),
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            _preferredCountries.add(country);
                          } else {
                            _preferredCountries.remove(country);
                          }
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
  onPressed: () async {
    print('Button pressed');
    if (_formKey.currentState!.validate() && _preferredCountries.isNotEmpty) {
      print('Form validated');
      // Save to Supabase
      final userProfile = {
        'degree_year': _degreeYear,
        'branch': _branch,
        'target_intake': _targetIntake,
        'preferred_countries': _preferredCountries.join(','),
        'user_id': Supabase.instance.client.auth.currentUser?.id,
      };
      print('Sending to Supabase: $userProfile');
      final response = await Supabase.instance.client
          .from('profiles')
          .insert([userProfile]);
      print('Supabase response: ${response.data}, error: ${response.error}');
      if (response.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoadmapScreen(
              degreeYear: _degreeYear!,
              targetIntake: _targetIntake!,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.error!.message}')),
        );
      }
    } else if (_preferredCountries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one country')),
      );
    }
  },
  child: const Text('Save'),
),
ElevatedButton(
  onPressed: () async {
    await Supabase.instance.client.auth.signOut();
    setState(() {}); // This will trigger a rebuild and go back to LoginScreen
  },
  child: const Text("Logout"),
)

            ],
          ),
        ),
      ),
    );
  }
}