import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  void efetuaLogin() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .signInWithEmailAndPassword(
            email: emailController.text, password: senhaController.text)
        .then((firebaseUser) {
      final SnackBar snackBar = SnackBar(
          content: Text('Logado com sucesso!'), duration: Duration(seconds: 5));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushNamed(context, 'menu');

      emailController.clear();
      senhaController.clear();
    }).catchError((error) {
      print("Deu erro: " + error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0C0E10), Color(0xFF1393D7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Remove o foco dos TextFields
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false, // Impede que a tela suba
          body: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width * 1.2,
                    height: size.height * 0.4,
                    child: Image.asset(
                      "assets/images/MonsterRankingLogo.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(emailController, "E-mail", Icons.mail, false),
                  const SizedBox(height: 20),
                  _buildTextField(senhaController, "Senha", Icons.lock, true),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: efetuaLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1393D7),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                      child: const Text("Login",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'register');
                          },
                          child: const Text(
                            "Criar conta",
                            style: TextStyle(color: Colors.white),
                          )),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Não consegue conectar?",
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      IconData icon, bool obscure) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white),
            prefixIcon: Icon(icon, color: Colors.white),
            filled: true,
            fillColor: Color(0xFF3E7294).withAlpha((0.2 * 255).toInt()),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
