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
        color: const Color.fromARGB(255, 15, 44, 75),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
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
              Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: onButtonPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1393D7),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // minimumSize: const Size(double.infinity, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: Text(buttonText),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}