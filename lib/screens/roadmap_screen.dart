import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoadmapScreen extends StatefulWidget {
  final String degreeYear; // e.g., "2nd Year"
  final String targetIntake; // e.g., "Fall 2026"

  const RoadmapScreen({
    super.key,
    required this.degreeYear,
    required this.targetIntake,
  });

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  late List<String> checklist;
  late List<bool> checked;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    checklist = getChecklist(widget.degreeYear);
    checked = List.filled(checklist.length, false);
    _loadChecklist();
  }

  Future<void> _loadChecklist() async {
  final prefs = await SharedPreferences.getInstance();
  final key = _prefsKey();
  final saved = prefs.getStringList(key);
  if (saved != null && saved.length == checklist.length) {
    checked = saved.map((e) => e == '1').toList();
  } else {
    checked = List.filled(checklist.length, false);
  }
  setState(() {
    loading = false;
  });
}

  Future<void> _saveChecklist() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _prefsKey();
    await prefs.setStringList(
      key,
      checked.map((e) => e ? '1' : '0').toList(),
    );
  }

  String _prefsKey() =>
      'roadmap_${widget.degreeYear}_${widget.targetIntake}';

  List<String> getChecklist(String degreeYear) {
    if (degreeYear == "1st Year") {
      return [
        "Focus on academics and build a strong GPA",
        "Explore extracurricular activities",
        "Start researching countries and courses",
        "Build relationships with professors",
      ];
    } else if (degreeYear == "2nd Year") {
      return [
        "Shortlist target countries and universities",
        "Participate in relevant projects/internships",
        "Prepare for standardized tests (TOEFL/IELTS, SAT, etc.)",
        "Start working on your resume",
      ];
    } else if (degreeYear == "3rd Year") {
      return [
        "Take standardized tests if not done",
        "Draft Statement of Purpose (SOP) and essays",
        "Request letters of recommendation",
        "Research scholarships and funding options",
        "Prepare application documents",
      ];
    } else if (degreeYear == "4th Year") {
      return [
        "Submit college applications",
        "Track application status and respond to emails",
        "Prepare for interviews (if any)",
        "Apply for student visa",
        "Plan travel and accommodation",
      ];
    }
    return ["No checklist available for your year."];
  }

  String getRoadmapSummary() {
    return "To be ready for ${widget.targetIntake}, follow the checklist below and stay proactive. "
        "Start early, keep deadlines in mind, and seek guidance when needed.";
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Your Roadmap')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Roadmap for ${widget.degreeYear} students targeting ${widget.targetIntake}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(getRoadmapSummary(), style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 24),
            const Text(
              "Checklist:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...List.generate(checklist.length, (i) {
              return CheckboxListTile(
                value: checked[i],
                onChanged: (val) {
                  setState(() {
                    checked[i] = val ?? false;
                  });
                  _saveChecklist();
                },
                title: Text(checklist[i]),
                controlAffinity: ListTileControlAffinity.leading,
              );
            }),
          ],
        ),
      ),
    );
  }
}