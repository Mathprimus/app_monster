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
    const backgroundColor = Color.fromRGBO(31, 62, 95, 1); // Fundo para todos os itens
    const textColor = Colors.white;

    // Configuração do stroke interno com degradê para o top 3
    final isTop3 = position <= 3;
    final borderDecoration = isTop3
        ? BoxDecoration(
            border: Border.all(
              width: 1, // Largura do stroke interno
              color: Colors.transparent, // Necessário para o Container interno criar o efeito
            ),
            borderRadius: BorderRadius.circular(9),
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(54, 125, 201, 1), // #367DC9
                Colors.white,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          )
        : BoxDecoration(
            borderRadius: BorderRadius.circular(9),
          );

    return Container(
      decoration: borderDecoration,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(9), // Ajustado para o stroke interno de 3px
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '#$position',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                color: textColor,
              ),
            ),
            Text(
              '$points pts',
              style: const TextStyle(
                fontSize: 16,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}