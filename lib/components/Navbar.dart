import 'package:flutter/material.dart';
import '../screen/Landing.dart';
import '../screen/Genre.dart';
import '../screen/Info.dart';

class Navbar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const Navbar({required this.selectedIndex, required this.onItemTapped});

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.selectedIndex,
      onTap: widget.onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Genre',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'Tentang',
        ),
      ],
      selectedItemColor: Colors.indigo,
      unselectedItemColor: Colors.grey,
    );
  }
}

