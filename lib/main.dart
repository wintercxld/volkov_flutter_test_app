import 'package:flutter/material.dart';

enum TaskStatus { pending, completed }

class Task {
  String title;
  String description;
  TaskStatus status;
  String imagePath;
  bool isFavorite;
  int index;

  Task(this.title, this.description, this.imagePath, this.index,
      [this.status = TaskStatus.pending, this.isFavorite = false]);

  void complete() {
    status = TaskStatus.completed;
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
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
    for (int i = index; i < tasks.length; i++) {
      tasks[i].index = i;
    }
  }

  List<T> getPendingTasks() {
    return tasks.where((task) => task.status == TaskStatus.pending).toList();
  }
}

class MyApp extends StatelessWidget {
  final TaskManager<Task> taskManager = TaskManager<Task>();

  MyApp({super.key}) {
    for (int i = 0; i < 9; i++) {
      taskManager.addTask(Task('Задача ${i + 1}', 'Описание задачи ${i + 1}',
          'images/face-with-raised-eyebrow.png', i));
    }
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
      home: ScaffoldMessenger(
        child: TaskScreen(taskManager: taskManager),
      ),
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
  final TextEditingController taskDescriptionController =
      TextEditingController();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void _addTask() {
    setState(() {
      final task = Task(
        taskTitleController.text,
        taskDescriptionController.text,
        'images/face-with-raised-eyebrow.png',
        widget.taskManager.tasks.length,
      );
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

  void _toggleFavorite(Task task, int index) {
    setState(() {
      task.toggleFavorite();
    });
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(task.isFavorite
            ? 'Задача "${task.title}" добавлена в избранное'
            : 'Задача "${task.title}" убрана из избранного'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
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
            Flexible(
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
                          width: 40.0,
                          child: Image.asset(task.imagePath),
                        ),
                        title: Text(task.title),
                        subtitle: Text(task.status.statusLabel),
                        trailing: SizedBox(
                          width: 150,
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
                                icon: const Icon(Icons.favorite),
                                color:
                                    task.isFavorite ? Colors.red : Colors.grey,
                                onPressed: () {
                                  _toggleFavorite(task, index);
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetailScreen(
                                task: task,
                                onComplete: (completedTask) {
                                  setState(() {
                                    completedTask.complete();
                                  });
                                },
                                onToggleFavorite: (favoritedTask) {
                                  _toggleFavorite(favoritedTask, index);
                                },
                                onDelete: () {
                                  _removeTask(index);
                                },
                              ),
                            ),
                          ).then((_) {
                            setState(() {});
                          });
                        },
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
            ),
          ],
        ),
      ),
    );
  }
}

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final Function(Task) onComplete;
  final Function(Task) onToggleFavorite;
  final Function() onDelete;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.onComplete,
    required this.onToggleFavorite,
    required this.onDelete,
  });

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали задачи'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(widget.task.imagePath),
              const SizedBox(height: 20),
              Text(
                widget.task.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                widget.task.description,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Text(
                'Статус: ${widget.task.status.statusLabel}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (widget.task.status == TaskStatus.pending)
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        widget.onComplete(widget.task);
                        setState(() {});
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.favorite),
                    color: widget.task.isFavorite ? Colors.red : Colors.grey,
                    onPressed: () {
                      widget.onToggleFavorite(widget.task);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(widget.task.isFavorite
                              ? 'Задача "${widget.task.title}" добавлена в избранное'
                              : 'Задача "${widget.task.title}" убрана из избранного'),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      widget.onDelete();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
