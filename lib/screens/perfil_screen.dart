import 'package:flutter/material.dart';

class TelaPerfil extends StatelessWidget {
  const TelaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B062C),

      body: Column(
        children: [
          Stack(
            clipBehavior:
                Clip.none, 
            children: [
              Container(
                height: 120, 
                width: double.infinity,
                color: const Color(0xFF2C65B9),
              ),

              Positioned(
                top: 50,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C65B9), 
                      shape: BoxShape.circle, 
                    ),
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Color(0xFF2C65B9),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 70), 

          const Text(
            'Sabrina Ribeiro',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Meu sonho é ficar moromba',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
