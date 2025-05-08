import 'package:app_monster/screens/challenge_screen.dart';
import 'package:app_monster/screens/ranking_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_monster/screens/perfil_screen.dart';
import 'package:app_monster/screens/home_screen.dart';


class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    ChallengeScreen(),
    RankingScreen(),
    TelaPerfil(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              )
            : null,
        padding: const EdgeInsets.all(12),
        child: Icon(
          icon,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B062C),

      body: _pages[_selectedIndex],

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        decoration: const BoxDecoration(
          color: Color(0xFF2C65B9),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(Icons.home_outlined, 0),
            _buildNavItem(Icons.emoji_events_outlined, 1),
            _buildNavItem(Icons.bar_chart_outlined, 2),
            _buildNavItem(Icons.person_outline, 3),
          ],
        ),
      ),
    );
  }
}
