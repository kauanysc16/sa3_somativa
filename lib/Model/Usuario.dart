class Usuario {
  // Atributos
  late int id; // ID do usuário (atributo marcado como late para inicialização tardia)
  String nome; // Nome do usuário
  String senha; // Senha do usuário

  // Construtor
  Usuario({required this.nome, required this.senha, required id});

  // Método para converter um objeto Usuario em um mapa, útil para armazenamento em banco de dados
  Map<String, dynamic> toMap() {
    return {
      'u_nome': nome, // Chave 'u_nome' contendo o nome do usuário
      'senha': senha, // Chave 'senha' contendo a senha do usuário
    };
  }

  // Factory method (método de fábrica) para criar um objeto Usuario a partir de um mapa, útil para recuperar dados do banco de dados
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'], // Atribui o valor da chave 'id' do mapa ao atributo id do usuário
      nome: map['u_nome'], // Atribui o valor da chave 'u_nome' do mapa ao atributo nome do usuário
      senha: map['senha'], // Atribui o valor da chave 'senha' do mapa ao atributo senha do usuário
    );
  }
}
