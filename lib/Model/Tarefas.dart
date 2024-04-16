class Task {
  String descricao; // Descrição da tarefa
  bool completadas; // Indica se a tarefa está completada ou não

  // Construtor da classe Task, que exige a descrição da tarefa e possui um parâmetro opcional para indicar se a tarefa está completada
  Task({required this.descricao, this.completadas = false});

  // Construtor nomeado para criar uma instância da classe Task a partir de um mapa JSON
  Task.fromJson(Map<String, dynamic> json)
      : descricao = json['descricao'], // Atribui o valor da chave 'descricao' do JSON para o atributo descricao
        completadas = json['completadas']; // Atribui o valor da chave 'completadas' do JSON para o atributo completadas

  // Método toJson que converte a instância da classe Task para um mapa JSON
  Map<String, dynamic> toJson() => {
        'descricao': descricao, // Chave 'descricao' do JSON contendo a descrição da tarefa
        'completadas': completadas, // Chave 'completadas' do JSON contendo o estado de completude da tarefa
      };
}
