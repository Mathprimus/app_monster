import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/ranking_item.dart';

class ChallengesRankingScreen extends StatelessWidget {
  const ChallengesRankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: const Color(0xFF0B062C),
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
          // Lista de Rankings de Desafios
          Column(
            children: const [
              RankingItem(position: 1, name: "JoãoBiceps", points: 320),
              SizedBox(height: 12),
              RankingItem(position: 2, name: "CarlaFit", points: 280),
              SizedBox(height: 12),
              RankingItem(position: 3, name: "LucasXP", points: 250),
              SizedBox(height: 12),
              RankingItem(position: 4, name: "AnaPower", points: 230),
              SizedBox(height: 12),
              RankingItem(position: 5, name: "PedroLift", points: 210),
              SizedBox(height: 12),
              RankingItem(position: 6, name: "MarianaRun", points: 190),
              SizedBox(height: 12),
              RankingItem(position: 7, name: "FelipeGym", points: 170),
              SizedBox(height: 12),
              RankingItem(position: 8, name: "SofiaFit", points: 150),
              SizedBox(height: 12),
              RankingItem(position: 9, name: "RafaelCore", points: 130),
              SizedBox(height: 12),
              RankingItem(position: 10, name: "JuliaFlex", points: 110),
            ],
          ),
        ],
      ),
    );
  }
}