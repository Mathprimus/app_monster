import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  TextEditingController telefoneController = TextEditingController();
  TextEditingController enderecoController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  TextEditingController ufController = TextEditingController();
  TextEditingController complementoController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController confirmarSenhaController = TextEditingController();

  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;

  String? _validarSenha(String? senha) {
    if (senha == null || senha.isEmpty) return "Senha obrigatória";
    if (senha.length < 8 || senha.length > 30)
      return "A senha deve ter entre 8 e 30 caracteres";
    if (!RegExp(r'[A-Z]').hasMatch(senha))
      return "A senha deve ter pelo menos uma letra maiúscula";
    if (!RegExp(r'[a-z]').hasMatch(senha))
      return "A senha deve ter pelo menos uma letra minúscula";
    if (!RegExp(r'[0-9]').hasMatch(senha))
      return "A senha deve ter pelo menos um número";
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(senha))
      return "A senha deve ter pelo menos um caractere especial";
    return null;
  }

  String? _validarConfirmacaoSenha(String? valor) {
    if (valor == null || valor.isEmpty)
      return "Confirmação de senha obrigatória";
    if (valor != senhaController.text) return "As senhas não coincidem";
    return null;
  }

  var cepFormatter = MaskTextInputFormatter(mask: "#####-###");

  final _formKey = GlobalKey<FormState>();
  final _formKeyNomeEmail = GlobalKey<FormState>();
  final _formKeyEndereco = GlobalKey<FormState>();
  final _formKeySenha = GlobalKey<FormState>();

  var cpfFormatter = MaskTextInputFormatter(mask: "###.###.###-##");
  var telefoneFormatter = MaskTextInputFormatter(mask: "(##) #####-####");

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
        "telefone": telefoneController.text,
        "endereco": enderecoController.text,
        "numero": numeroController.text,
        "bairro": bairroController.text,
        "cidade": cidadeController.text,
        "cep": cepController.text,
        "uf": ufController.text,
        "complemento": complementoController.text,
        "dataCadastro": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Cadastrado com sucesso!"),
            backgroundColor: Colors.green),
      );
      // Navegar para a tela de login
      Navigator.pushReplacementNamed(
          context, 'login'); // Substitua pela sua tela de login
    } catch (erro) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Erro ao cadastrar: ${erro.toString()}"),
            backgroundColor: Colors.red),
      );
    }
  }

  bool _validarNome(String nome) {
    final regex = RegExp(r"^[a-zA-ZÀ-ÿ\s]{1,150}$");
    return regex.hasMatch(nome);
  }

  bool _validarCPF(String cpf) {
    return UtilBrasilFields.isCPFValido(cpf);
  }

  void _proximoPasso(int page) {
    switch (page) {
      case 0:
        if (_formKeyNomeEmail.currentState!.validate()) {
          _pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        break;
      case 1:
        if (_formKeyEndereco.currentState!.validate()) {
          _pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        break;
      case 2:
        if (_formKeySenha.currentState!.validate()) {
          _cadastrarUsuario();
        }
        break;
    }
  }

  Future<void> _buscarCEP() async {
    String cep = cepController.text
        .replaceAll(RegExp(r'[^0-9]'), ''); // Remove caracteres não numéricos
    if (cep.length != 8) return;

    try {
      final response =
          await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json/"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["erro"] == true) {
          _mostrarSnackBar("CEP não encontrado!");
          return;
        }

        setState(() {
          enderecoController.text = data["logradouro"] ?? "";
          bairroController.text = data["bairro"] ?? "";
          cidadeController.text = data["localidade"] ?? "";
          ufController.text = data["uf"] ?? "";
        });
      } else {
        _mostrarSnackBar("Erro ao buscar CEP!");
      }
    } catch (e) {
      _mostrarSnackBar("Falha ao conectar com o servidor!");
    }
  }

  void _mostrarSnackBar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    nomeController.dispose();
    emailController.dispose();
    cpfController.dispose();
    telefoneController.dispose();
    enderecoController.dispose();
    numeroController.dispose();
    bairroController.dispose();
    cidadeController.dispose();
    cepController.dispose();
    ufController.dispose();
    complementoController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1393D7), Color(0xFF0C0E10)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: const BoxDecoration(color: Colors.transparent),
            child: AppBar(
              title: Text(
                "Cadastro",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics:
                      NeverScrollableScrollPhysics(), // Impede arrastar manualmente
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  children: [
                    _buildNomeEmailPage(),
                    _buildEnderecoPage(),
                    _buildSenhaPage(),
                  ],
                ),
              ),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNomeEmailPage() {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKeyNomeEmail,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: nomeController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Nome",
                    labelStyle: TextStyle(color: Colors.white),
                    floatingLabelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .white), // Cor da borda quando não está focado
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Colors.white), // Cor da borda quando está focado
                    ),
                  ),
                  maxLength: 150,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nome obrigatório";
                    }
                    if (!_validarNome(value)) {
                      return "Nome inválido (somente letras e até 150 caracteres)";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "E-mail",
                    labelStyle: TextStyle(color: Colors.white),
                    floatingLabelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .white), // Cor da borda quando não está focado
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Colors.white), // Cor da borda quando está focado
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "E-mail obrigatório";
                    }
                    if (!EmailValidator.validate(value)) {
                      return "E-mail inválido";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: cpfController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "CPF",
                    labelStyle: TextStyle(color: Colors.white),
                    floatingLabelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .white), // Cor da borda quando não está focado
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Colors.white), // Cor da borda quando está focado
                    ),
                  ),
                  inputFormatters: [cpfFormatter],
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "CPF obrigatório";
                    }
                    if (!_validarCPF(value)) {
                      return "CPF inválido";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: telefoneController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Telefone",
                    labelStyle: TextStyle(color: Colors.white),
                    floatingLabelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .white), // Cor da borda quando não está focado
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Colors.white), // Cor da borda quando está focado
                    ),
                  ),
                  inputFormatters: [telefoneFormatter],
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Telefone obrigatório";
                    }
                    if (value.length < 14) {
                      return "Telefone inválido";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnderecoPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKeyEndereco,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: cepController,
                decoration: InputDecoration(labelText: "CEP"),
                keyboardType: TextInputType.number,
                inputFormatters: [cepFormatter],
                maxLength: 9,
                validator: (value) {
                  if (value == null || value.isEmpty) return "CEP obrigatório";
                  if (value.length != 9) return "CEP inválido";
                  return null;
                },
                onChanged: (value) {
                  if (value.length == 9) _buscarCEP();
                },
              ),
              TextFormField(
                controller: enderecoController,
                decoration: InputDecoration(labelText: "Endereço"),
                maxLength: 100,
                validator: (value) =>
                    value!.isEmpty ? "Endereço obrigatório" : null,
              ),
              TextFormField(
                controller: numeroController,
                decoration: InputDecoration(labelText: "Número"),
                keyboardType: TextInputType.number,
                maxLength: 6,
                validator: (value) =>
                    value!.isEmpty ? "Número obrigatório" : null,
              ),
              TextFormField(
                controller: bairroController,
                decoration: InputDecoration(labelText: "Bairro"),
                maxLength: 50,
                validator: (value) =>
                    value!.isEmpty ? "Bairro obrigatório" : null,
              ),
              TextFormField(
                controller: cidadeController,
                decoration: InputDecoration(labelText: "Cidade"),
                maxLength: 50,
                validator: (value) =>
                    value!.isEmpty ? "Cidade obrigatória" : null,
              ),
              TextFormField(
                controller: ufController,
                decoration: InputDecoration(labelText: "UF"),
                maxLength: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) return "UF obrigatória";
                  if (!RegExp(r"^[A-Z]{2}$").hasMatch(value))
                    return "UF inválida";
                  return null;
                },
              ),
              TextFormField(
                controller: complementoController,
                decoration: InputDecoration(labelText: "Complemento"),
                maxLength: 100,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print("Endereço validado!");
                  }
                },
                child: Text("Próximo"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSenhaPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKeySenha,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: senhaController,
                decoration: InputDecoration(
                  labelText: "Senha",
                  suffixIcon: IconButton(
                    icon: Icon(_senhaVisivel
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _senhaVisivel = !_senhaVisivel;
                      });
                    },
                  ),
                ),
                obscureText: !_senhaVisivel,
                validator: _validarSenha,
              ),
              TextFormField(
                controller: confirmarSenhaController,
                decoration: InputDecoration(
                  labelText: "Confirmar Senha",
                  suffixIcon: IconButton(
                    icon: Icon(_confirmarSenhaVisivel
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _confirmarSenhaVisivel = !_confirmarSenhaVisivel;
                      });
                    },
                  ),
                ),
                obscureText: !_confirmarSenhaVisivel,
                validator: _validarConfirmacaoSenha,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print("Senha validada com sucesso!");
                  }
                },
                child: Text("Próximo"),
              ),
            ],
          ),
        ),
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
              onPressed: () => _proximoPasso(_currentPage),
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
