import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: const Color(0xFF0B062C),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: const [
          ChallengeScreenCard(
            title: "Desafio Diário",
            description: "Faça 50 abdominais hoje",
            points: 50,
          ),
          SizedBox(height: 12),
          ChallengeScreenCard(
            title: "Desafio Semanal",
            description: "Treine 4x na semana",
            points: 100,
          ),
          SizedBox(height: 12),
          ChallengeScreenCard(
            title: "Desafio Mensal",
            description: "Complete 16 treinos este mês",
            points: 300,
          ),
        ],
      ),
    );
  }
}

class ChallengeScreenCard extends StatefulWidget {
  final String title;
  final String description;
  final int points;

  const ChallengeScreenCard({
    super.key,
    required this.title,
    required this.description,
    required this.points,
  });

  @override
  State<ChallengeScreenCard> createState() => _ChallengeScreenCardState();
}

class _ChallengeScreenCardState extends State<ChallengeScreenCard> {
  bool _isCompleted = false;

  void _handleComplete() {
    if (_isCompleted) return;
    setState(() {
      _isCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _isCompleted ? 0.5 : 1.0, // Escurece o card quando concluído
      child: Card(
        color: Colors.white10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Área de 20% para a imagem (substituída por cor temporária)
            Container(
              height: 72,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),
            // Conteúdo
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.points} pts",
                        style: const TextStyle(color: Colors.amber, fontSize: 16),
                      ),
                      ElevatedButton(
                        onPressed: _isCompleted ? null : _handleComplete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isCompleted ? Colors.grey : const Color(0xFF1393D7),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        child: Text(_isCompleted ? "Concluído ✔" : "Concluir Desafio"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}