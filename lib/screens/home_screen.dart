import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/ranking_card.dart';
import '../widgets/challenge_card.dart';
import '../widgets/custom_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<List<Map<String, dynamic>>> _fetchTopUsers(String rankingType) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .orderBy('pontos', descending: true)
          .limit(3)
          .get();

      List<Map<String, dynamic>> topUsers = [];
      int position = 1;

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        topUsers.add({
          'position': position,
          'name': data['nome']?.toString() ?? 'Usuário Desconhecido',
          'points': (data['pontos'] is int) ? data['pontos'] : int.tryParse(data['pontos'].toString()) ?? 0,
        });
        position++;
      }

      print("Top usuários carregados: $topUsers"); // Log para depuração
      return topUsers;
    } catch (e) {
      print("Erro ao buscar usuários: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: const Color.fromRGBO(18, 52, 89, 1),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Rankings",
              style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 320,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                SizedBox(
                  width: 340,
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _fetchTopUsers('desafios_concluidos'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text("Erro ao carregar ranking", style: TextStyle(color: Colors.white)));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("Nenhum dado disponível", style: TextStyle(color: Colors.white)));
                      }

                      return RankingCard(
                        title: "Top 3 - Desafios Concluídos",
                        items: snapshot.data!,
                        buttonText: "Ver ranking completo",
                        onButtonPressed: () {
                          Navigator.pushNamed(context, 'challenges-ranking');
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 280,
                  child: RankingCard(
                    title: "Top 3 - Maiores Fofoqueiros",
                    items: const [
                      {'position': 1, 'name': 'AnaFofoca', 'points': 150},
                      {'position': 2, 'name': 'BetoTagarela', 'points': 120},
                      {'position': 3, 'name': 'ClaraBoca', 'points': 90},
                    ],
                    buttonText: "Ver ranking completo",
                    onButtonPressed: () {
                      Navigator.pushNamed(context, 'gossip-ranking');
                    },
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Desafios",
              style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 255,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                SizedBox(
                  width: 340,
                  child: ChallengeCard(
                    title: "Desafio Diário",
                    description: "50 abdominais? Vamos, você consegue... ou será preguiça?",
                    imagePath: "assets/images/desafio_diario.png",
                  ),
                ),
                SizedBox(width: 12),
                SizedBox(
                  width: 340,
                  child: ChallengeCard(
                    title: "Desafio Semanal",
                    description: "4 treinos? Não fuja, mostre que é forte!",
                    imagePath: "assets/images/desafio_semanal.png",
                  ),
                ),
                SizedBox(width: 12),
                SizedBox(
                  width: 340,
                  child: ChallengeCard(
                    title: "Desafio Mensal",
                    description: "16 treinos? Desafie-se ou fique só na conversa!",
                    imagePath: "assets/images/desafio_mensal.png",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}