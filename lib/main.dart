import 'package:flutter/material.dart';

enum TaskStatus { pending, completed }

class Task {
  String title;
  TaskStatus status;

  Task(this.title, [this.status = TaskStatus.pending]);

  void complete() {
    status = TaskStatus.completed;
  }
}

extension TaskStatusExtension on TaskStatus {
  String get statusLabel {
    switch (this) {
      case TaskStatus.pending:
        return 'Выполняется';
      case TaskStatus.completed:
        return 'Выполнена';
      default:
        return '';
    }
  }
}

class TaskManager<T extends Task> {
  List<T> tasks = [];

  void addTask(T task) {
    tasks.add(task);
  }

  void removeTask(int index) {
    if (index >= 0 && index < tasks.length) {
      tasks.removeAt(index);
    }
  }

  List<T> getPendingTasks() {
    return tasks.where((task) => task.status == TaskStatus.pending).toList();
  }
}

class MyApp extends StatelessWidget {
  final TaskManager<Task> taskManager = TaskManager<Task>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
      home: TaskScreen(taskManager: taskManager),
    );
  }
}

class TaskScreen extends StatefulWidget {
  final TaskManager<Task> taskManager;

  const TaskScreen({Key? key, required this.taskManager}) : super(key: key);

  @override
  _MyTaskScreenState createState() => _MyTaskScreenState();
}

class _MyTaskScreenState extends State<TaskScreen> {
  final TextEditingController taskController = TextEditingController();

  void _addTask() {
    setState(() {
      final task = Task(taskController.text);
      widget.taskManager.addTask(task);
      taskController.clear();
    });
  }

  void _removeTask(int index) {
    setState(() {
      widget.taskManager.removeTask(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Волков Никита Андреевич\nПИбд-33'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'TO-DO список',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.taskManager.tasks.length,
              itemBuilder: (context, index) {
                final task = widget.taskManager.tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.status.statusLabel),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (task.status == TaskStatus.pending)
                        IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () {
                            setState(() {
                              task.complete();
                            });
                          },
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _removeTask(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Новая задача'),
                content: TextField(
                  controller: taskController,
                  decoration: const InputDecoration(hintText: 'Введите название задачи'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      _addTask();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Добавить'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.emoji_nature),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
