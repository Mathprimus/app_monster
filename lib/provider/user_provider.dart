import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  String? _userName;
  int? _userPoints;
  bool _isLoading = false;
  String? _errorMessage;

  String? get userName => _userName;
  int? get userPoints => _userPoints;
  int get userLevel => _userPoints != null ? (_userPoints! ~/ 1000) + 1 : 1; // A cada 1000 pontos, aumenta 1 nível
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  UserProvider() {
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _errorMessage = "Usuário não logado";
        _isLoading = false;
        notifyListeners();
        return;
      }

      String userId = currentUser.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        _userName = data['nome']?.toString() ?? 'Usuário Desconhecido';
        _userPoints = (data['pontos'] is int) ? data['pontos'] : int.tryParse(data['pontos'].toString()) ?? 0;
      } else {
        _errorMessage = "Usuário não encontrado no Firestore";
      }
    } catch (e) {
      _errorMessage = "Erro ao carregar dados do usuário: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshUserData() async {
    await _fetchUserData();
  }

  void clearUserData() {
    _userName = null;
    _userPoints = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}