import 'package:flutter/material.dart';

class BottomDashboardScreen extends StatefulWidget {
  final int currentIndex;

  const BottomDashboardScreen({required this.currentIndex});

  @override
  _BottomDashboardScreenState createState() => _BottomDashboardScreenState();
}

class _BottomDashboardScreenState extends State<BottomDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xfff6dccb),
            Colors.black,
          ],
        ),
      ),
      child: BottomNavigationBar(
        selectedItemColor: const Color(0xfff6dccb),
        currentIndex: widget.currentIndex,
        onTap: (index) {
          if (widget.currentIndex != index) {
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/home');
                break;
              case 1:
                Navigator.pushNamed(context, '/active-reservations');
                break;
              case 2:
                Navigator.pushNamed(context, '/settings');
                break;
            }
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Active Reservations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
