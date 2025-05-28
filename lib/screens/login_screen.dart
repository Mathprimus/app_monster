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
  bool _obscurePassword = true; // Estado para controlar a visibilidade da senha
  String? _errorMessage; // Estado para armazenar mensagens de erro

  void efetuaLogin() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      auth
          .signInWithEmailAndPassword(
              email: emailController.text, password: senhaController.text)
          .then((firebaseUser) {
        // SnackBar estilizado
        final SnackBar snackBar = SnackBar(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle, color: Colors.white, size: 24),
              SizedBox(width: 12),
              Text(
                "Logado com sucesso!",
                style: TextStyle(
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
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushNamed(context, 'home');

        emailController.clear();
        senhaController.clear();
        setState(() {
          _errorMessage = null; // Limpa a mensagem de erro ao logar com sucesso
        });
      }).catchError((error) {
        setState(() {
          _errorMessage = error.message ?? "Erro desconhecido ao fazer login";
        });
        print("Deu erro: " + error.toString());
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Erro ao processar o login: $e";
      });
      print("Erro geral: $e");
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(18, 52, 89, 1),
            Color.fromRGBO(11, 37, 72, 1),
            Color.fromRGBO(9, 33, 55, 1),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
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
                  _buildTextField(senhaController, "Senha", Icons.lock, _obscurePassword),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ],
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
                        elevation: 0, // Remove a sombra
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
                          onPressed: () {
                            Navigator.pushNamed(context, 'reset');
                          },
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
            suffixIcon: hint == "Senha"
                ? IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: _togglePasswordVisibility,
                  )
                : null,
            filled: true,
            fillColor: Color(0xFF3E7294).withAlpha((0.2 * 255).toInt()),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: _errorMessage != null ? Colors.red : Colors.transparent,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: _errorMessage != null ? Colors.red : const Color(0xFF3E7294),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}