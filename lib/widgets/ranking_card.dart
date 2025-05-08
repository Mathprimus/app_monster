import 'package:flutter/material.dart';

class RankingCard extends StatelessWidget {
  const RankingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Conteúdo com espaço entre os itens
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espalha os itens
                children: [
                  Text(
                    "Top 3 da Semana",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    children: const [
                      _RankingItem(position: 1, name: "JoãoBiceps", points: 320),
                      _RankingItem(position: 2, name: "CarlaFit", points: 280),
                      _RankingItem(position: 3, name: "LucasXP", points: 250),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 36),
                    ),
                    onPressed: () {},
                    child: const Text("Ver ranking completo"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RankingItem extends StatelessWidget {
  final int position;
  final String name;
  final int points;

  const _RankingItem({
    required this.position,
    required this.name,
    required this.points,
  });

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$positionº",
            style: const TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Text(
            "$points pts",
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}