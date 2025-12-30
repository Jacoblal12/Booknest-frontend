import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../books/books_screen.dart';
import '../auth/profile_screen.dart';

class NavRoot extends StatefulWidget {
  const NavRoot({super.key});

  @override
  _NavRootState createState() => _NavRootState();
}

class _NavRootState extends State<NavRoot> {
  int _currentIndex = 0;

  final List<Widget> _screens = [HomeScreen(), BooksScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Books"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
