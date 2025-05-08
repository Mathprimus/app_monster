import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/desafio_card.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // Seção de Nível e Pontos
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E88E5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Nível 4",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "4.570 Pontos",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Lista de Desafios
          Column(
            children: const [
              ChallengeCard(
                title: "Treino pesado",
                description: "30 pontos",
                points: 30,
              ),
              SizedBox(height: 12),
              ChallengeCard(
                title: "Bora interagir",
                description: "50 pontos",
                points: 50,
              ),
            ],
          ),
        ],
      ),
    );
  }
}