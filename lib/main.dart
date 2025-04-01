import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http; // Teste real de conexão
import 'package:app_monster/screens/login_screen.dart';
import 'package:app_monster/screens/menu_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'loading',
      routes: {
        'loading': (context) => LoadingScreen(),
        'login': (context) => LoginScreen(),
        'menu': (context) => MenuScreen(),
        'error': (context) => NoConnectionScreen(),
      },
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<bool> _checkRealInternetConnection() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(Duration(seconds: 3));
      if (response.statusCode == 200) {
        print("✅ Conexão com a internet confirmada!");
        return true;
      } else {
        print("❌ Sem resposta válida da internet!");
        return false;
      }
    } catch (e) {
      print("❌ Erro ao tentar acessar a internet: $e");
      return false;
    }
  }

  void _checkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    bool isConnected = connectivityResult != ConnectivityResult.none;

    print("📡 Status da conexão detectado: $connectivityResult");
    if (isConnected) {
      isConnected =
          await _checkRealInternetConnection(); // Teste real da internet
    }

    Future.delayed(Duration(seconds: 1), () {
      if (isConnected) {
        print("🔄 Navegando para a tela de login...");
        Navigator.pushReplacementNamed(context, 'login');
      } else {
        print("⚠️ Sem conexão! Navegando para a tela de erro.");
        Navigator.pushReplacementNamed(context, 'error');
      }
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width * 1, // Limita o tamanho da imagem
                  height: size.height *
                      0.5, // Evita que a imagem ocupe espaço demais
                  child: Image.asset(
                    "assets/images/MonterRankingThumbs.png",
                    fit: BoxFit.contain,
                  ),
                ),
                CircularProgressIndicator(
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                Text(
                  "Verificando conexão...",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NoConnectionScreen extends StatelessWidget {
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize
                  .min, // Garante que os elementos não sejam empurrados para fora
              children: [
                Text(
                  "Sem conexão com a internet",
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * 0.02),
                SizedBox(
                  width: size.width * 1, // Limita o tamanho da imagem
                  height: size.height *
                      0.5, // Evita que a imagem ocupe espaço demais
                  child: Image.asset(
                    "assets/images/MonsterRankingSemConexao.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, 'loading');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1393D7),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      shadowColor: Colors.black54,
                    ),
                    child: Text(
                      "Tentar novamente",
                      style: TextStyle(
                        fontSize: size.width * 0.045,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
