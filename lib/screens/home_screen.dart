import 'package:flutter/material.dart';
import '../widgets/ranking_card.dart';
import '../widgets/challenge_card.dart';
import '../widgets/custom_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: const Color.fromRGBO(18, 52, 89, 1),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Rankings",
              style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold), // Adicionado negrito
            ),
          ),
          SizedBox(
            height: 320,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                SizedBox(
                  width: 340,
                  child: RankingCard(
                    title: "Top 3 - Desafios Concluídos",
                    items: const [
                      {'position': 1, 'name': "JoãoBiceps", 'points': 320},
                      {'position': 2, 'name': "CarlaFit", 'points': 280},
                      {'position': 3, 'name': "LucasXP", 'points': 250},
                    ],
                    buttonText: "Ver ranking completo",
                    onButtonPressed: () {
                      Navigator.pushNamed(context, 'ranking');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 340,
                  child: RankingCard(
                    title: "Top 3 - Maiores Fofoqueiros",
                    items: const [
                      {'position': 1, 'name': "AnaFofoca", 'points': 150},
                      {'position': 2, 'name': "BetoTagarela", 'points': 120},
                      {'position': 3, 'name': "ClaraBoca", 'points': 90},
                    ],
                    buttonText: "Ver ranking completo",
                    onButtonPressed: () {
                      Navigator.pushNamed(context, 'ranking');
                    },
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Desafios",
              style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold), // Adicionado negrito
            ),
          ),
          SizedBox(
            height: 255,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                SizedBox(
                  width: 340,
                  child: ChallengeCard(
                    title: "Desafio Diário",
                    description: "50 abdominais? Vamos, você consegue... ou será preguiça?",
                    imagePath: "assets/images/desafio_diario.png",
                  ),
                ),
                SizedBox(width: 12),
                SizedBox(
                  width: 340,
                  child: ChallengeCard(
                    title: "Desafio Semanal",
                    description: "4 treinos? Não fuja, mostre que é forte!",
                    imagePath: "assets/images/desafio_semanal.png",
                  ),
                ),
                SizedBox(width: 12),
                SizedBox(
                  width: 340,
                  child: ChallengeCard(
                    title: "Desafio Mensal",
                    description: "16 treinos? Desafie-se ou fique só na conversa!",
                    imagePath: "assets/images/desafio_mensal.png",
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