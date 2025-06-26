import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const TaskListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  // Lista de tareas
  final List<Map<String, dynamic>> _tasks = [
    {'title': 'Comprar leche', 'isDone:': false},
    {'title': 'Terminar el informe para el viernes', 'isDone': false},
    {'title': 'Llamar al dentista', 'isDone': true},
    {'title': 'Ir al gimnasio', 'isDone': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            title: Text(
              task['title'],
              style: TextStyle(
                decoration: task['isDone']
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            leading: Checkbox(
              value: task['isDone'],
              onChanged: (bool? value) {
                setState(() {
                  _tasks[index]['isDone'] = value!;
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementar la logica para anadir una nueva tarea.
        },
        tooltip: 'Anadir Tarea',
        child: const Icon(Icons.add),
      ),
    );
  }
}
