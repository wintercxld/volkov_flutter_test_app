import 'package:flutter/material.dart';

enum TaskStatus { pending, completed }

class Task {
  String title;
  TaskStatus status;
  String imagePath;

  Task(this.title, this.imagePath, [this.status = TaskStatus.pending]);

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

  MyApp({super.key}) {
    taskManager
        .addTask(Task('Задача 1', 'images/face-with-raised-eyebrow.png'));
    taskManager
        .addTask(Task('Задача 2', 'images/face-with-raised-eyebrow.png'));
    taskManager
        .addTask(Task('Задача 3', 'images/face-with-raised-eyebrow.png'));
    taskManager
        .addTask(Task('Задача 4', 'images/face-with-raised-eyebrow.png'));
    taskManager
        .addTask(Task('Задача 5', 'images/face-with-raised-eyebrow.png'));
    taskManager
        .addTask(Task('Задача 6', 'images/face-with-raised-eyebrow.png'));
    taskManager
        .addTask(Task('Задача 7', 'images/face-with-raised-eyebrow.png'));
    taskManager
        .addTask(Task('Задача 8', 'images/face-with-raised-eyebrow.png'));
    taskManager
        .addTask(Task('Задача 9', 'images/face-with-raised-eyebrow.png'));
  }

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

  const TaskScreen({super.key, required this.taskManager});

  @override
  _MyTaskScreenState createState() => _MyTaskScreenState();
}

class _MyTaskScreenState extends State<TaskScreen> {
  final TextEditingController taskTitleController = TextEditingController();

  void _addTask() {
    setState(() {
      final task = Task(
        taskTitleController.text,
        'images/face-with-raised-eyebrow.png',
      );
      widget.taskManager.addTask(task);
      taskTitleController.clear();
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
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 10.0),
                  child: Container(
                    height: 100,
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8.0),
                      leading: SizedBox(
                        width: 50.0,
                        child: Image.asset(task.imagePath),
                      ),
                      title: Text(task.title),
                      subtitle: Text(task.status.statusLabel),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
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
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Новая задача'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: taskTitleController,
                            decoration: const InputDecoration(
                                hintText: 'Введите название задачи'),
                          ),
                        ],
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
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
