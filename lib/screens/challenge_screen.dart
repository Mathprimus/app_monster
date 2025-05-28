import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_app_bar.dart';
import 'challenge_detail_screen.dart';

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
          // Desafios Diários
          SizedBox(height: 12),
          ChallengeScreenCard(
            title: "Recruta Social",
            description: "Converse com pelo menos 2 pessoas novas hoje na academia. Vale até 'oi, tudo bem?'.",
            points: 20,
            imagePath: "assets/images/desafio_diario.png",
            challengeType: "Diário",
          ),
          SizedBox(height: 12),
          ChallengeScreenCard(
            title: "Aquela Repetição a Mais",
            description: "Faça 1 repetição a mais do que o planejado em qualquer exercício. Porque você é brabo.",
            points: 15,
            imagePath: "assets/images/desafio_diario.png",
            challengeType: "Diário",
          ),
          SizedBox(height: 12),
          ChallengeScreenCard(
            title: "Tô só aquecendo",
            description: "Complete pelo menos 3 exercícios diferentes hoje. Pode ser leve, mas tem que suar.",
            points: 25,
            imagePath: "assets/images/desafio_diario.png",
            challengeType: "Diário",
          ),
          SizedBox(height: 12),
          // Desafios Semanais
          SizedBox(height: 12),
          ChallengeScreenCard(
            title: "4 de 7",
            description: "Treine em pelo menos 4 dias diferentes durante esta semana. Sem desculpas criativas!",
            points: 80,
            imagePath: "assets/images/desafio_semanal.png",
            challengeType: "Semanal",
          ),
          SizedBox(height: 12),
          ChallengeScreenCard(
            title: "Desafio do Sério",
            description: "Faça 4 treinos completos, com mínimo de 40 minutos cada. Pode ser série ou funcional.",
            points: 100,
            imagePath: "assets/images/desafio_semanal.png",
            challengeType: "Semanal",
          ),
          SizedBox(height: 12),
          ChallengeScreenCard(
            title: "Monstro em Formação",
            description: "Alcance um total de 10 exercícios concluídos na semana. Diversifica que é sucesso.",
            points: 120,
            imagePath: "assets/images/desafio_semanal.png",
            challengeType: "Semanal",
          ),
          SizedBox(height: 12),
          // Desafios Mensais
          SizedBox(height: 12),
          ChallengeScreenCard(
            title: "Sem Sumir!",
            description: "Falte no máximo 1 dia por semana durante o mês. Se sumir, sem pontos!",
            points: 250,
            imagePath: "assets/images/desafio_mensal.png",
            challengeType: "Mensal",
          ),
          SizedBox(height: 12),
          ChallengeScreenCard(
            title: "Level Up",
            description: "Aumente a carga ou tempo em pelo menos 3 exercícios diferentes neste mês. Evolução conta!",
            points: 300,
            imagePath: "assets/images/desafio_mensal.png",
            challengeType: "Mensal",
          ),
          SizedBox(height: 12),
          ChallengeScreenCard(
            title: "Senhor Frequência",
            description: "Complete pelo menos 16 treinos neste mês. 4 por semana, certinho!",
            points: 350,
            imagePath: "assets/images/desafio_mensal.png",
            challengeType: "Mensal",
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
  final String imagePath;
  final String challengeType;

  const ChallengeScreenCard({
    super.key,
    required this.title,
    required this.description,
    required this.points,
    required this.imagePath,
    required this.challengeType,
  });

  @override
  State<ChallengeScreenCard> createState() => _ChallengeScreenCardState();
}

class _ChallengeScreenCardState extends State<ChallengeScreenCard> {
  bool _isCompleted = false;

  Future<void> _handleComplete() async {
    if (_isCompleted) return;

    // Verificar se há um usuário logado
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 24),
              SizedBox(width: 12),
              Text(
                "Você precisa estar logado para concluir desafios!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          duration: Duration(seconds: 3),
          dismissDirection: DismissDirection.horizontal,
        ),
      );
      Navigator.pushReplacementNamed(context, 'login');
      return;
    }

    String userId = currentUser.uid;

    setState(() {
      _isCompleted = true;
    });

    try {
      // Buscar o documento do usuário no Firestore
      DocumentReference userRef = FirebaseFirestore.instance.collection('usuarios').doc(userId);
      DocumentSnapshot userDoc = await userRef.get();

      if (userDoc.exists) {
        // Obter os pontos atuais (ou 0 se não existir)
        int currentPoints = (userDoc.data() as Map<String, dynamic>)['pontos'] ?? 0;
        int newPoints = currentPoints + widget.points;

        // Atualizar os pontos no Firestore
        await userRef.update({'pontos': newPoints});

        // Exibir SnackBar estilizado
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Text(
                  "Desafio concluído! Você ganhou ${widget.points} pontos!",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF2E7D32), // Verde escuro
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            duration: const Duration(seconds: 3),
            dismissDirection: DismissDirection.horizontal,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Usuário não encontrado no Firestore!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao adicionar pontos: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToDetailScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChallengeDetailScreen(
          title: widget.title,
          description: widget.description,
          points: widget.points,
          imagePath: widget.imagePath,
          challengeType: widget.challengeType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigateToDetailScreen,
      child: Opacity(
        opacity: _isCompleted ? 0.5 : 1.0,
        child: Card(
          color: const Color.fromARGB(255, 15, 44, 75),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    height: 72,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
                      image: DecorationImage(
                        image: AssetImage(widget.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1393D7), // Cor do badge
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.challengeType,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.points} pts",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
      ),
    );
  }
}