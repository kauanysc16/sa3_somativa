import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sa3_somativa/View/CadastroPageView.dart'; // Importa a página de cadastro
import 'package:sa3_somativa/View/ListaPageView.dart'; // Importa a página da lista

import '../Controller/BancoDados.dart'; // Importa o controlador do banco de dados
import '../Model/Usuario.dart'; // Importa o modelo de usuário

// Classe para a página de login
class PaginaLogin extends StatefulWidget {
  const PaginaLogin({Key? key}) : super(key: key);

  @override
  State<PaginaLogin> createState() => _PaginaLoginState();
}

// Estado da página de login
class _PaginaLoginState extends State<PaginaLogin> {
  final _formKey = GlobalKey<FormState>(); // Chave global para o formulário
  TextEditingController _nomeController = TextEditingController(); // Controller para o campo de nome
  TextEditingController _senhaController = TextEditingController(); // Controller para o campo de senha
  bool _loading = false; // Variável para controlar o estado de carregamento

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela de Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // Associa a chave global ao formulário
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Título da página
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20), // Espaçamento
                // Campo de entrada para o nome do usuário com ícone de usuário
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    prefixIcon: Icon(Icons.person), // Ícone de usuário
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, insira seu nome';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20), // Espaçamento
                // Campo de entrada para a senha do usuário com ícone de cadeado
                TextFormField(
                  controller: _senhaController,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.lock), // Ícone de cadeado
                  ),
                  obscureText: true, // Oculta o texto digitado
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Por favor, insira sua senha';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20), // Espaçamento
                // Exibe um indicador de carregamento enquanto o login está em andamento
                _loading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _login, // Chama o método para fazer login
                        child: Text('Acessar'),
                      ),
                SizedBox(height: 20), // Espaçamento
                // Botão para navegar até a página de cadastro
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaginaCadastro()), // Navega até a página de cadastro
                    );
                  },
                  child: Text('Não tem uma conta? Cadastre-se'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Método para fazer login
  void _login() async {
    if (_formKey.currentState!.validate()) { // Valida os campos do formulário
      String nome = _nomeController.text; // Obtém o nome do campo de texto
      String senha = _senhaController.text; // Obtém a senha do campo de texto

      setState(() {
        _loading = true; // Define o estado de carregamento como verdadeiro
      });

      BancoDadosCrud bancoDados = BancoDadosCrud(); // Instancia o controlador do banco de dados
      try {
        Usuario? usuario = await bancoDados.getUsuario(nome, senha); // Obtém o usuário do banco de dados
        if (usuario != null) {
          if (usuario.nome == nome) { // Verifica se o nome do usuário coincide
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaginaLista(), // Navega até a página da lista após o login bem-sucedido
              ),
              
            );
          } else {
            // Exibe uma mensagem de erro se o nome ou a senha estiverem incorretos
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Nome ou senha incorretos'),
            ));
          }
        }
      } catch (e) {
        print('Erro durante o login: $e');
        // Exibe uma mensagem de erro se ocorrer um problema durante o login
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erro durante o login. Tente novamente mais tarde.'),
        ));
      } finally {
        setState(() {
          _loading = false; // Define o estado de carregamento como falso
        });
      }
    }
  }
}
