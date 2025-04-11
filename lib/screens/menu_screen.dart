import 'package:flutter/material.dart';
import 'package:app_monster/screens/perfil_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedIndex = 0; // Para controlar o BottomNavigationBar

   final List<Widget> _pages = const [
    Center(child: Text("Início", style: TextStyle(fontSize: 20, color: Colors.white))),
    TelaPerfil(), // tela de perfil 
    Center(child: Text("Configurações", style: TextStyle(fontSize: 20, color: Colors.white))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B062C), // Fundo escuro 

      appBar: AppBar(
        title: const Text("Menu"),
        backgroundColor: const Color(0xFF2C65B9), // Deixa o appBar com a mesma cor da barra inferior
      ),

      body: _pages[_selectedIndex], // Mostra a tela conforme o índice

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        backgroundColor: const Color(0xFF2C65B9),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Início",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Configurações",
          ),
        ],
      ),
    );
  }
}
