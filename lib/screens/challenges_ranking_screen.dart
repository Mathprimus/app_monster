import 'package:app_monster/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/ranking_item.dart';

class ChallengesRankingScreen extends StatelessWidget {
  const ChallengesRankingScreen({super.key});

  // Função para buscar a lista de usuários ordenada por pontos
  Future<List<Map<String, dynamic>>> _fetchAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .orderBy('pontos', descending: true)
          .get();

      List<Map<String, dynamic>> allUsers = [];
      int position = 1;

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        allUsers.add({
          'position': position,
          'name': data['nome']?.toString() ?? 'Usuário Desconhecido',
          'points': (data['pontos'] is int) ? data['pontos'] : int.tryParse(data['pontos'].toString()) ?? 0,
        });
        position++;
      }

      return allUsers;
    } catch (e) {
      print("Erro ao buscar usuários: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verificar se o usuário está logado
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, 'login');
      });
      return const Scaffold(
        backgroundColor: Color(0xFF0B062C),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Scaffold(
          appBar: const CustomAppBar(),
          backgroundColor: const Color(0xFF0B062C),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              // Seção de Nível e Pontos
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E88E5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: userProvider.isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            userProvider.errorMessage != null
                                ? "Erro"
                                : "Nível ${userProvider.userLevel}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            userProvider.errorMessage != null
                                ? "Erro"
                                : "${userProvider.userPoints ?? 0} Pontos",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 16),
              // Lista de Rankings de Desafios
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchAllUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  }
                  if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "Erro ao carregar ranking ou nenhum usuário encontrado",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return Column(
                    children: snapshot.data!.map((user) {
                      return Column(
                        children: [
                          RankingItem(
                            position: user['position'],
                            name: user['name'],
                            points: user['points'],
                          ),
                          const SizedBox(height: 12),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}