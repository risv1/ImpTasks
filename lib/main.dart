import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imptasks/task.dart';

void main() async {

  runApp(MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: const Color(0xff0D3257)),
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<Task> tasksBox;
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tasksBox = List<Task>.empty(growable: true);
  }

  void onAddTask() {
    if (_textEditingController.text.isNotEmpty) {
      final newTask = Task(_textEditingController.text, false);
      tasksBox.add(newTask);
      Navigator.pop(context);
      _textEditingController.clear();
      return;
    }
  }

  void onUpdateTask(int index, Task task) {
    tasksBox[index] = Task(task.title, !task.completed);
    return;
  }

  void onDeleteTask(int index) {
    tasksBox.removeAt(index);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO'), systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: ValueListenableBuilder(
        valueListenable: tasksBox.length,
        builder: (context, value, child) {
          if (tasksBox.length > 0) {
            return ListView.separated(
              itemBuilder: (context, index) {
                final task = tasksBox.get(index);

                return ListTile(
                  title: Text(task!.title),
                  leading: Checkbox(
                      activeColor: const Color(0x800d3257),
                      value: task.completed,
                      onChanged: (bool? value) => onUpdateTask(index, task!)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => onDeleteTask(index),
                  ),
                );
              },
              itemCount: tasksBox.length,
              separatorBuilder: (context, index) => const Divider(),
            );
          } else {
            return EmptyList();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff0D3257),
        child: const Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Add New Task'),
              content: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(hintText: "Enter task"),
                autofocus: true,
              ),
              actions: [
                TextButton(onPressed: () => onAddTask(), child: const Text('SAVE'))
              ],
            );
          },
        ),
      ),
    );
  }
}

class EmptyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              child: const Icon(Icons.inbox_outlined,
                  size: 80.0, color: Color(0xff0D3257))),
          Container(
            padding: const EdgeInsets.only(top: 4.0),
            child: const Text(
              "Don't have any tasks",
              style: TextStyle(fontSize: 20.0),
            ),
          )
        ],
      ),
    );
  }
}