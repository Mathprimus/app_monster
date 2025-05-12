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
  bool temLetraMaiuscula = false;
  bool temNumero = false;
  bool temCaractereEspecial = false;
  bool tamanhoMinimo = false;

  void _validarSenhaAoDigitar(String senha) {
    setState(() {
      temLetraMaiuscula = senha.contains(RegExp(r'[A-Z]'));
      temNumero = senha.contains(RegExp(r'[0-9]'));
      temCaractereEspecial = senha.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
      tamanhoMinimo = senha.length >= 8;
    });
  }

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
  var cpfFormatter = MaskTextInputFormatter(mask: "###.###.###-##");
  var telefoneFormatter = MaskTextInputFormatter(mask: "(##) #####-####");

  final _formKey = GlobalKey<FormState>();
  final _formKeyNomeEmail = GlobalKey<FormState>();
  final _formKeyEndereco = GlobalKey<FormState>();
  final _formKeySenha = GlobalKey<FormState>();

  void _cadastrarUsuario() async {
    if (senhaController.text != confirmarSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("As senhas não coincidem!"), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore db = FirebaseFirestore.instance;

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: senhaController.text,
      );

      String uid = userCredential.user!.uid;

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
        const SnackBar(content: Text("Cadastrado com sucesso!"), backgroundColor: Colors.green),
      );
      Navigator.pushReplacementNamed(context, 'login');
    } catch (erro) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao cadastrar: ${erro.toString()}"), backgroundColor: Colors.red),
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
          _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        }
        break;
      case 1:
        if (_formKeyEndereco.currentState!.validate()) {
          _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
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
    String cep = cepController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cep.length != 8) return;

    try {
      final response = await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json/"));
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
          colors: [
            Color.fromRGBO(54, 125, 201, 1), // #367DC9
            Color.fromRGBO(11, 37, 72, 1),
            Color.fromRGBO(9, 33, 55, 1),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: const BoxDecoration(color: Colors.transparent),
            child: AppBar(
              title: const Text(
                "Cadastro",
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  children: [
                    _buildNomeEmailPage(),
                    _buildEnderecoPage(),
                    _buildSenhaPage(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index ? Colors.white : Colors.white54,
                    ),
                  )),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKeyNomeEmail,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Informações Pessoais",
              style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: nomeController,
              label: "Nome",
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) return "Nome obrigatório";
                if (!_validarNome(value)) return "Nome inválido (somente letras e até 150 caracteres)";
                return null;
              },
              maxLength: 150,
            ),
            _buildTextField(
              controller: emailController,
              label: "E-mail",
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) return "E-mail obrigatório";
                if (!EmailValidator.validate(value)) return "E-mail inválido";
                return null;
              },
            ),
            _buildTextField(
              controller: cpfController,
              label: "CPF",
              icon: Icons.credit_card,
              inputFormatters: [cpfFormatter],
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return "CPF obrigatório";
                if (!_validarCPF(value)) return "CPF inválido";
                return null;
              },
            ),
            _buildTextField(
              controller: telefoneController,
              label: "Telefone",
              icon: Icons.phone,
              inputFormatters: [telefoneFormatter],
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) return "Telefone obrigatório";
                if (value.length < 14) return "Telefone inválido";
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnderecoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKeyEndereco,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Endereço",
              style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: cepController,
              label: "CEP",
              icon: Icons.location_on,
              inputFormatters: [cepFormatter],
              keyboardType: TextInputType.number,
              maxLength: 9,
              validator: (value) {
                if (value == null || value.isEmpty) return "CEP obrigatório";
                if (value.length != 9) return "CEP inválido";
                return null;
              },
              onChanged: (value) => value.length == 9 ? _buscarCEP() : null,
            ),
            _buildTextField(
              controller: enderecoController,
              label: "Endereço",
              icon: Icons.home,
              maxLength: 100,
              validator: (value) => value!.isEmpty ? "Endereço obrigatório" : null,
            ),
            _buildTextField(
              controller: numeroController,
              label: "Número",
              icon: Icons.format_list_numbered,
              keyboardType: TextInputType.number,
              maxLength: 6,
              validator: (value) => value!.isEmpty ? "Número obrigatório" : null,
            ),
            _buildTextField(
              controller: bairroController,
              label: "Bairro",
              icon: Icons.location_city,
              maxLength: 50,
              validator: (value) => value!.isEmpty ? "Bairro obrigatório" : null,
            ),
            _buildTextField(
              controller: cidadeController,
              label: "Cidade",
              icon: Icons.location_city,
              maxLength: 50,
              validator: (value) => value!.isEmpty ? "Cidade obrigatória" : null,
            ),
            _buildTextField(
              controller: ufController,
              label: "UF",
              icon: Icons.map,
              maxLength: 2,
              validator: (value) {
                if (value == null || value.isEmpty) return "UF obrigatória";
                if (!RegExp(r"^[A-Z]{2}$").hasMatch(value)) return "UF inválida";
                return null;
              },
            ),
            _buildTextField(
              controller: complementoController,
              label: "Complemento",
              icon: Icons.note,
              maxLength: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSenhaPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKeySenha,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Segurança",
              style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: senhaController,
              label: "Senha",
              icon: Icons.lock,
              obscureText: !_senhaVisivel,
              suffixIcon: IconButton(
                icon: Icon(_senhaVisivel ? Icons.visibility : Icons.visibility_off, color: Colors.white),
                onPressed: () => setState(() => _senhaVisivel = !_senhaVisivel),
              ),
              onChanged: _validarSenhaAoDigitar,
              validator: _validarSenha,
            ),
            const SizedBox(height: 10),
            _buildVerificadoresDeSenha(),
            const SizedBox(height: 20),
            _buildTextField(
              controller: confirmarSenhaController,
              label: "Confirmar Senha",
              icon: Icons.lock_outline,
              obscureText: !_confirmarSenhaVisivel,
              suffixIcon: IconButton(
                icon: Icon(_confirmarSenhaVisivel ? Icons.visibility : Icons.visibility_off, color: Colors.white),
                onPressed: () => setState(() => _confirmarSenhaVisivel = !_confirmarSenhaVisivel),
              ),
              validator: _validarConfirmacaoSenha,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    bool obscureText = false,
    Widget? suffixIcon,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    int? maxLength,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        obscureText: obscureText,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        maxLength: maxLength,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: const Color.fromRGBO(255, 255, 255, 0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF367DC9), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildVerificadoresDeSenha() {
    return Column(
      children: [
        _buildCheckItem("Letra maiúscula", temLetraMaiuscula),
        _buildCheckItem("Número", temNumero),
        _buildCheckItem("Caractere especial", temCaractereEspecial),
        _buildCheckItem("Mínimo 8 caracteres", tamanhoMinimo),
      ],
    );
  }

  Widget _buildCheckItem(String criterio, bool valido) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: valido ? Color(0xFF367DC9) : Colors.white10,
              border: Border.all(color: Colors.white54, width: 1),
            ),
            child: Icon(valido ? Icons.check : null, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Text(criterio, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          if (_currentPage > 0)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white10,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 4,
                shadowColor: Colors.black26,
              ).copyWith(
                backgroundColor: MaterialStateProperty.all(const Color(0xFF1393D7).withOpacity(0.8)),
              ),
              onPressed: () => _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut),
              child: const Text("Voltar"),
            ),
          const Spacer(),
          if (_currentPage < 2)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1393D7),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 4,
                shadowColor: Colors.black26,
              ).copyWith(
                backgroundColor: MaterialStateProperty.all(const Color(0xFF1393D7).withOpacity(0.8)),
              ),
              onPressed: () => _proximoPasso(_currentPage),
              child: const Text("Próximo"),
            ),
          if (_currentPage == 2)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF367DC9),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 4,
                shadowColor: Colors.black26,
              ),
              onPressed: _cadastrarUsuario,
              child: const Text("Finalizar Cadastro"),
            ),
        ],
      ),
    );
  }
}