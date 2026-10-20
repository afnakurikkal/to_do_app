import 'package:flutter/material.dart';

void main() => runApp(to_do_app());

class to_do_app extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TodoPage());
  }
}

class Todo {
  String title;
  bool isDone;

  Todo({required this.title, this.isDone = false});
}

class TodoPage extends StatefulWidget {
  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final List<Todo> _todo = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTodo() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _todo.add(Todo(title: text));
    });

    _controller.clear();
    Navigator.pop(context);
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add new task'),
          content: TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter task'),
            onSubmitted: (_) => _addTodo(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _controller.clear();
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(onPressed: _addTodo, child: const Text('Add')),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.menu, color: Colors.black),
            Container(
              margin: EdgeInsetsGeometry.fromLTRB(100.0, 0, 0, 0),
              child: Text(
                'To Do List',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.purpleAccent,
      ),
      body: _todo.isEmpty
          ? const Center(child: Text('No tasks yet. Tap + to add one.'))
          : ListView.builder(
              itemCount: _todo.length,
              itemBuilder: (context, index) {
                final todo = _todo[index];

                return ListTile(
                  tileColor: Colors.grey[300],
                  leading: Checkbox(
                    value: todo.isDone,
                    activeColor: Colors.purpleAccent,
                    onChanged: (value) {
                      setState(() {
                        todo.isDone = value ?? false;
                      });
                    },
                  ),
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: todo.isDone ? Colors.grey : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _todo.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog();
        },
        backgroundColor: Colors.purpleAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
