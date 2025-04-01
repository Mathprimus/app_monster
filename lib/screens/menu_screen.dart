import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedIndex = 0; // Para controlar o BottomNavigationBar

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
      ),
      body: SingleChildScrollView(
        // O ScrollView agora está dentro do body
        child: Center(
          child: Column(
            children: const [
              Text("Teste"),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Define a aba ativa
        onTap: _onItemTapped, // Atualiza a seleção ao clicar
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
