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
    return Card(
      color: Colors.white10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}