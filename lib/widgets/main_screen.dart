import 'package:flutter/material.dart';
import '../screens/spotted/spotted_screen.dart';
import '../screens/events/events_screen.dart';
import '../screens/marketplace/books_screen.dart';
import '../screens/tutoring/tutoring_screen.dart';
import '../services/auth_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final AuthService _authService = AuthService();

  final List<Widget> _screens = [
    const SpottedScreen(),
    const EventsScreen(),
    const BooksScreen(),
    const TutoringScreen(),
  ];

  final List<String> _titles = [
    'Spotted',
    'Eventi',
    'Libri',
    'Ripetizioni',
  ];

  void _logout() async {
    try {
      await _authService.signOut();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_red_eye),
            label: 'Spotted',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Eventi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Libri',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Ripetizioni',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}