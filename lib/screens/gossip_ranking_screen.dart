import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/ranking_item.dart';

class GossipRankingScreen extends StatelessWidget {
  const GossipRankingScreen({super.key});

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
          // Lista de Rankings de Fofoqueiros
          Column(
            children: const [
              RankingItem(position: 1, name: "AnaFofoca", points: 150),
              SizedBox(height: 12),
              RankingItem(position: 2, name: "BetoTagarela", points: 120),
              SizedBox(height: 12),
              RankingItem(position: 3, name: "ClaraBoca", points: 90),
              SizedBox(height: 12),
              RankingItem(position: 4, name: "DudaFala", points: 80),
              SizedBox(height: 12),
              RankingItem(position: 5, name: "EduBafafa", points: 70),
              SizedBox(height: 12),
              RankingItem(position: 6, name: "FernandaBuzz", points: 60),
              SizedBox(height: 12),
              RankingItem(position: 7, name: "GabiFofo", points: 50),
              SizedBox(height: 12),
              RankingItem(position: 8, name: "HugoNews", points: 40),
              SizedBox(height: 12),
              RankingItem(position: 9, name: "IgorChat", points: 30),
              SizedBox(height: 12),
              RankingItem(position: 10, name: "JuliaGossip", points: 20),
            ],
          ),
        ],
      ),
    );
  }
}