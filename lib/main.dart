import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/home_screen.dart';
import 'screens/roadmap_screen.dart';
import 'screens/library_screen.dart';
import 'models/college.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MalikApp());
}

class MalikApp extends StatefulWidget {
  const MalikApp({super.key});

  @override
  State<MalikApp> createState() => _MalikAppState();
}

class _MalikAppState extends State<MalikApp> {
  int _currentIndex = 0;

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
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Malik',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: StreamBuilder<AuthState>(
  stream: Supabase.instance.client.auth.onAuthStateChange,
  builder: (context, snapshot) {
    return FutureBuilder<Widget>(
      future: _determineStartScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return snapshot.data!;
      },
    );
  },
),


  );
}

Future<Widget> _determineStartScreen() async {
  final client = Supabase.instance.client;
  final session = client.auth.currentSession;

  if (session == null) {
    return const LoginScreen();
  }

  final response = await client.auth.getUser();
  if (response.user == null) {
    return const LoginScreen();
  }

  final userId = response.user!.id;

  final profile = await client
      .from('profiles')
      .select()
      .eq('user_id', userId)
      .maybeSingle();

  if (profile == null) {
    return const ProfileScreen();
  }

  final screens = [
    HomeScreen(
      colleges: _colleges,
      onToggleInterest: _toggleInterest,
    ),
    RoadmapScreen(
      degreeYear: profile['degree_year'] ?? 'Unknown',
      targetIntake: profile['target_intake'] ?? 'Unknown',
    ),
    LibraryScreen(
      savedColleges: _colleges.where((c) => c.isInterested).toList(),
      onRemoveInterest: _toggleInterest,
    ),
  ];

  return StatefulBuilder(
    builder: (context, setStateNav) {
      return Scaffold(
        body: screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
          _currentIndex = index;
          setStateNav(() {}); // Updates local widget state
          },

          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Roadmap'),
            BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Library'),
          ],
        ),
      );
    },
  );
}

}
