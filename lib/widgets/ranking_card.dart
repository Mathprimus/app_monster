import 'package:flutter/material.dart';
import './ranking_item.dart';

class RankingCard extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const RankingCard({
    super.key,
    required this.title,
    required this.items,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320, // Altura fixa para consistência
      child: Card(
        color: Colors.white10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Column(
                children: items.map((item) {
                  return Column(
                    children: [
                      RankingItem(
                        position: item['position'],
                        name: item['name'],
                        points: item['points'],
                      ),
                      if (item != items.last) const SizedBox(height: 8),
                    ],
                  );
                }).toList(),
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
                onPressed: onButtonPressed,
                child: Text(buttonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}