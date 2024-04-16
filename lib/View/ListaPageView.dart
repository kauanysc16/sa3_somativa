import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sa3_somativa/Model/Tarefas.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Classe que representa a página principal da lista de tarefas
class PaginaLista extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskListScreen(), // Inicializa a tela da lista de tarefas
    );
  }
}

// Classe que representa a tela da lista de tarefas (Stateful)
class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

// Classe que representa o estado da tela da lista de tarefas
class _TaskListScreenState extends State<TaskListScreen> {
  late SharedPreferences _prefs;
  List<Task> _tasks = []; // Lista de tarefas
  TextEditingController _taskController =
      TextEditingController(); // Controlador para o campo de texto
  bool _showCompletadas =
      true; // Flag para mostrar ou ocultar tarefas completadas

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Carrega as tarefas salvas ao inicializar a tela
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed:
                _showAddDialog, // Abre o diálogo para adicionar uma nova tarefa
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadTasks, // Recarrega a lista de tarefas
          ),
        ],
      ),
      body: Column(
        children: [
          CheckboxListTile(
            title: Text('Mostrar Tarefas Completadas'),
            value: _showCompletadas,
            onChanged: (value) {
              setState(() {
                _showCompletadas = value!;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                if (!_showCompletadas && task.completadas) {
                  return SizedBox
                      .shrink(); // Oculta tarefas completadas, se necessário
                }
                return ListTile(
                  title: Text(task.descricao),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editTask(task,
                              index); // Abre o diálogo para editar a tarefa
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteTask(index); // Exclui a tarefa
                        },
                      ),
                      Checkbox(
                        value: task.completadas,
                        onChanged: (value) {
                          setState(() {
                            task.completadas = value!;
                            _saveTasks(); // Salva as alterações
                            _showFeedbackMessage('Tarefa marcada como ' +
                                (value
                                    ? 'completada'
                                    : 'incompleta')); // Feedback para o usuário
                          });
                        },
                      ),
                    ],
                  ),
                  onLongPress: () {
                    setState(() {
                      _tasks.removeAt(
                          index); // Remove a tarefa ao pressionar por um longo tempo
                      _saveTasks(); // Salva as alterações
                      _showFeedbackMessage(
                          'Tarefa removida'); // Feedback para o usuário
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Função para exibir um SnackBar com o feedback para o usuário
  void _showFeedbackMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // Função para exibir o diálogo para adicionar uma nova tarefa
  Future<void> _showAddDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        String newTask = '';
        return AlertDialog(
          title: Text('Adicionar Tarefa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newTask = value;
                },
                controller: _taskController,
                decoration: InputDecoration(
                  hintText: 'Digite a nova tarefa',
                ),
              ),
              if (_taskController.text.isEmpty)
                Text(
                  'Por favor, insira uma descrição para a tarefa.',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (newTask.isNotEmpty) {
                    _tasks.add(Task(descricao: newTask));
                    _taskController.clear();
                    _saveTasks(); // Salva as alterações
                    _showFeedbackMessage(
                        'Tarefa adicionada com sucesso!'); // Feedback para o usuário
                    Navigator.pop(context);
                  }
                });
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  // Função para exibir o diálogo para editar uma tarefa
  Future<void> _editTask(Task task, int index) async {
    showDialog(
      context: context,
      builder: (context) {
        String editedTask = task.descricao;
        return AlertDialog(
          title: Text('Editar Tarefa'),
          content: TextField(
            onChanged: (value) {
              editedTask = value;
            },
            controller: TextEditingController(text: task.descricao),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  task.descricao = editedTask;
                  _saveTasks(); // Salva as alterações
                  _showFeedbackMessage(
                      'Tarefa editada com sucesso!'); // Feedback para o usuário
                  Navigator.pop(context);
                });
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  // Função para exibir o diálogo para excluir uma tarefa
  Future<void> _deleteTask(int index) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Excluir Tarefa'),
          content: Text('Tem certeza de que deseja excluir esta tarefa?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _tasks.removeAt(index);
                  _saveTasks(); // Salva as alterações
                  _showFeedbackMessage(
                      'Tarefa excluída com sucesso!'); // Feedback para o usuário
                  Navigator.pop(context);
                });
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  // Função para salvar as tarefas no armazenamento local
  Future<void> _saveTasks() async {
    await _prefs.setStringList(
        'tasks', _tasks.map((task) => task.descricao).toList());
  }

  // Função para carregar as tarefas do armazenamento local
  Future<void> _loadTasks() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _tasks = (_prefs.getStringList('tasks') ?? [])
          .map((task) => Task(descricao: task))
          .toList();
    });
  }
}
