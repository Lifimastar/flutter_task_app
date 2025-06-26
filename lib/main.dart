import 'package:flutter/material.dart';
import 'helpers/database_helper.dart';
import 'models/task.dart';

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
  late Future<List<Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    // Carga las tareas cuando el widget se inicializa por primera vez.
    _loadTasks();
  }

  // Metodo para cargar o recargar las tareas desde la base de datos.
  void _loadTasks() {
    setState(() {
      _tasksFuture = DatabaseHelper.instance.getTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: FutureBuilder<List<Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          // mientras cargan los datos muestra sniper
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // si hay un error, muestralo.
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // si no hay datos, muestra un mensaje.
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay tareas todavia. ¡Añade una!'),
            );
          }

          // si todo bien muestra la lista
          final tasks = snapshot.data!;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                leading: Checkbox(
                  value: task.isDone,
                  onChanged: (bool? value) async {
                    // crea una nueva tarea con el estado actualizado.
                    final updatedTask = Task(
                      id: task.id,
                      title: task.title,
                      isDone: value ?? false,
                    );
                    // llama al metodo de la base de datos.
                    await DatabaseHelper.instance.updateTask(updatedTask);
                    // recarga lista
                    _loadTasks();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementar la logica para anadir una nueva tarea.
        },
        tooltip: 'Añadir Tarea',
        child: const Icon(Icons.add),
      ),
    );
  }
}
