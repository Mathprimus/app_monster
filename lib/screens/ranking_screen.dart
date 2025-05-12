import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/ranking_card.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: const Color.fromRGBO(18, 52, 89, 1),
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
          // Ranking de Desafios Concluídos
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              "Desafios Concluídos",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          RankingCard(
            title: "Top 3 - Desafios Concluídos",
            items: const [
              {'position': 1, 'name': "JoãoBiceps", 'points': 320},
              {'position': 2, 'name': "CarlaFit", 'points': 280},
              {'position': 3, 'name': "LucasXP", 'points': 250},
            ],
            buttonText: "Ver ranking completo",
            onButtonPressed: () {
              Navigator.pushNamed(context, 'challenges-ranking');
            },
          ),
          const SizedBox(height: 16),
          // Ranking de Maiores Fofoqueiros
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              "Maiores Fofoqueiros",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          RankingCard(
            title: "Top 3 - Maiores Fofoqueiros",
            items: const [
              {'position': 1, 'name': "AnaFofoca", 'points': 150},
              {'position': 2, 'name': "BetoTagarela", 'points': 120},
              {'position': 3, 'name': "ClaraBoca", 'points': 90},
            ],
            buttonText: "Ver ranking completo",
            onButtonPressed: () {
              Navigator.pushNamed(context, 'gossip-ranking');
            },
          ),
        ],
      ),
    );
  }
}