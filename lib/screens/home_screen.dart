import 'package:flutter/material.dart';
import '../widgets/ranking_card.dart';
import '../widgets/desafio_card.dart';
import '../widgets/custom_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: const Color(0xFF0B062C), // Fundo escuro como no mockup
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Rankings",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          SizedBox(
            height: 270,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                SizedBox(
                  width: 280,
                  child: RankingCard(),
                ),
                SizedBox(width: 12),
                SizedBox(
                  width: 280,
                  child: RankingCard(),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Desafios",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          SizedBox(
            height: 270,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                SizedBox(
                  width: 340,
                  child: ChallengeCard(
                    title: "Desafio Diário",
                    description: "Faça 50 abdominais",
                    points: 50,
                  ),
                ),
                SizedBox(width: 12),
                SizedBox(
                  width: 340,
                  child: ChallengeCard(
                    title: "Desafio Semanal",
                    description: "Treine 4x na semana",
                    points: 100,
                  ),
                ),
                SizedBox(width: 12),
                SizedBox(
                  width: 340,
                  child: ChallengeCard(
                    title: "Desafio Mensal",
                    description: "Complete 16 treinos",
                    points: 300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}