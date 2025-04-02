import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _resetarSenha() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, insira um e-mail válido!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("✅ E-mail de redefinição de senha enviado!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'E-mail de redefinição de senha enviado! Verifique sua caixa de entrada.')),
      );
      _emailController.clear();
    } catch (error) {
      print("❌ Erro ao enviar e-mail: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar e-mail: $error')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resetar Senha')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _resetarSenha,
                    child: Text('Enviar E-mail de Redefinição'),
                  ),
          ],
        ),
      ),
    );
  }
}
