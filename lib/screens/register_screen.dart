import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  // Controladores para capturar os dados
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController enderecoController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController confirmarSenhaController = TextEditingController();

  void _cadastrarUsuario() async {
    if (senhaController.text != confirmarSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("As senhas não coincidem!"),
            backgroundColor: Colors.red),
      );
      return;
    }

    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore db = FirebaseFirestore.instance;

      // Criar usuário no Firebase Auth
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: senhaController.text,
      );

      String uid = userCredential.user!.uid;

      // Salvar no Firestore
      await db.collection("usuarios").doc(uid).set({
        "nome": nomeController.text,
        "email": emailController.text,
        "cpf": cpfController.text,
        "endereco": enderecoController.text,
        "dataCadastro": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Cadastrado com sucesso!"),
            backgroundColor: Colors.green),
      );
      // Navegar para a tela de login
      Navigator.pushNamed(context, 'login'); // Substitua pela sua tela de login
    } catch (erro) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Erro ao cadastrar: ${erro.toString()}"),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro")),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics:
                  NeverScrollableScrollPhysics(), // Impede arrastar manualmente
              onPageChanged: (index) => setState(() => _currentPage = index),
              children: [
                _buildNomeEmailPage(),
                _buildCpfEnderecoPage(),
                _buildSenhaPage(),
              ],
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildNomeEmailPage() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: "Nome")),
          TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "E-mail")),
        ],
      ),
    );
  }

  Widget _buildCpfEnderecoPage() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
              controller: cpfController,
              decoration: InputDecoration(labelText: "CPF")),
          TextField(
              controller: enderecoController,
              decoration: InputDecoration(labelText: "Endereço")),
        ],
      ),
    );
  }

  Widget _buildSenhaPage() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
              controller: senhaController,
              decoration: InputDecoration(labelText: "Senha"),
              obscureText: true),
          TextField(
              controller: confirmarSenhaController,
              decoration: InputDecoration(labelText: "Confirmar Senha"),
              obscureText: true),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            ElevatedButton(
              onPressed: () => _pageController.previousPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              child: Text("Voltar"),
            ),
          if (_currentPage < 2)
            ElevatedButton(
              onPressed: () => _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              child: Text("Próximo"),
            ),
          if (_currentPage == 2)
            ElevatedButton(
              onPressed: _cadastrarUsuario,
              child: Text("Finalizar Cadastro"),
            ),
        ],
      ),
    );
  }
}
