import 'package:flutter/material.dart';

enum TaskStatus { pending, completed }

class Task {
  String title;
  String description;
  TaskStatus status;

  Task(this.title, this.description, [this.status = TaskStatus.pending]);

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

  MyApp() {
    // Добавляем несколько задач при инициализации
    taskManager.addTask(Task('Задача 1', 'Описание задачи 1'));
    taskManager.addTask(Task('Задача 2', 'Описание задачи 2'));
    taskManager.addTask(Task('Задача 3', 'Описание задачи 3'));
    taskManager.addTask(Task('Задача 4', 'Описание задачи 4'));
    taskManager.addTask(Task('Задача 5', 'Описание задачи 5'));
    taskManager.addTask(Task('Задача 6', 'Описание задачи 6'));
    taskManager.addTask(Task('Задача 7', 'Описание задачи 7'));
    taskManager.addTask(Task('Задача 8', 'Описание задачи 8'));
    taskManager.addTask(Task('Задача 9', 'Описание задачи 9'));
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

  const TaskScreen({Key? key, required this.taskManager}) : super(key: key);

  @override
  _MyTaskScreenState createState() => _MyTaskScreenState();
}

class _MyTaskScreenState extends State<TaskScreen> {
  final TextEditingController taskTitleController = TextEditingController();
  final TextEditingController taskDescriptionController =
      TextEditingController();

  void _addTask() {
    setState(() {
      final task =
          Task(taskTitleController.text, taskDescriptionController.text);
      widget.taskManager.addTask(task);
      taskTitleController.clear();
      taskDescriptionController.clear();
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
                        height: 50.0,
                        child:
                            Image.asset('images/face-with-raised-eyebrow.png'),
                      ),
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailScreen(task: task),
                          ),
                        );
                      },
                    ),
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
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: taskTitleController,
                      decoration: const InputDecoration(
                          hintText: 'Введите название задачи'),
                    ),
                    TextField(
                      controller: taskDescriptionController,
                      decoration: const InputDecoration(
                          hintText: 'Введите описание задачи'),
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
    );
  }
}

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали задачи'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/face-with-raised-eyebrow.png',
              height: 200,
            ),
            const SizedBox(height: 16),
            Text(
              task.title,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              task.description,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (task.status == TaskStatus.pending)
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Выполнить'),
                  ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Удалить'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
