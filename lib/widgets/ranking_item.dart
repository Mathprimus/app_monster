import 'package:flutter/material.dart';

class RankingItem extends StatelessWidget {
  final int position;
  final String name;
  final int points;

  const RankingItem({
    super.key,
    required this.position,
    required this.name,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor = Colors.white;

    // Diferenciação visual para o top 3
    if (position == 1) {
      backgroundColor = Colors.yellow.shade700; // Ouro para 1º
    } else if (position == 2) {
      backgroundColor = Colors.grey.shade400; // Prata para 2º
    } else if (position == 3) {
      backgroundColor = Colors.brown.shade400; // Bronze para 3º
    } else {
      backgroundColor = Colors.white10; // Cor padrão para as outras posições
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '#$position',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
          ),
          Text(
            '$points pts',
            style: TextStyle(
              fontSize: 16,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}