import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistent_filing/service/app_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textFieldController = TextEditingController();
  Map<String, bool> todoTasks = {};
  @override
  void initState() {
    getTodosFromFile();
    super.initState();
  }

  void getTodosFromFile() async {
    final dir = await getApplicationDocumentsDirectory();
    try {
      final todos =
          await AppService().getTodoFromFile("${dir.path}/todos.json");
      setState(() {
        todoTasks = todos;
      });
    } catch (e) {
      log("Error while getting Todos from file = $e");
    }
  }

  void saveTodosToFile() async {
    final dir = await getApplicationDocumentsDirectory();
    try {
      await AppService().saveTodoToFile("${dir.path}/todos.json", todoTasks);
    } catch (e) {
      log("Error while Saving Todos to file= $e");
    }
  }

  void _onFloatingPressed() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add a Todo"),
        content: TextField(
          controller: textFieldController,
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (textFieldController.text != "") {
                setState(() {
                  todoTasks[textFieldController.text] = false;
                });
                saveTodosToFile();
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: todoTasks.length,
        itemBuilder: (context, index) => ListTile(
            title: Text(
              todoTasks.keys.toList()[index],
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  todoTasks[todoTasks.keys.toList()[index]] =
                      !todoTasks.values.toList()[index];
                });
                saveTodosToFile();
              },
              icon: todoTasks.values.toList()[index]
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFloatingPressed,
        child: const Icon(Icons.add),
      ),
    );
  }
}
