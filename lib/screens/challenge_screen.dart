import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: const Color.fromRGBO(18, 52, 89, 1),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: const [
          ChallengeScreenCard(
            title: "Desafio Diário",
            description: "Faça 50 abdominais hoje",
            points: 50,
            imagePath: "assets/images/desafio_diario.png", // Insira a rota da imagem
          ),
          SizedBox(height: 12),
          ChallengeScreenCard(
            title: "Desafio Semanal",
            description: "Treine 4x na semana",
            points: 100,
            imagePath: "assets/images/desafio_semanal.png", // Insira a rota da imagem
          ),
          SizedBox(height: 12),
          ChallengeScreenCard(
            title: "Desafio Mensal",
            description: "Complete 16 treinos este mês",
            points: 300,
            imagePath: "assets/images/desafio_mensal.png", // Insira a rota da imagem
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
  final String imagePath; // Novo parâmetro para a rota da imagem

  const ChallengeScreenCard({
    super.key,
    required this.title,
    required this.description,
    required this.points,
    required this.imagePath,
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
        color: const Color.fromARGB(255, 15, 44, 75),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Área de 20% para a imagem
            Container(
              height: 72,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
                image: DecorationImage(
                  image: AssetImage(widget.imagePath), // Usa a rota passada como parâmetro
                  fit: BoxFit.cover,
                ),
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
                        style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: _isCompleted ? null : _handleComplete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isCompleted ? Colors.grey : const Color(0xFF1393D7),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
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