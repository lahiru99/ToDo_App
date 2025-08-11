import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TaskListScreen extends StatefulWidget {
  final String listName;

  TaskListScreen({required this.listName});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late List<TaskItem> todoItems;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('tasks_${widget.listName}');

    if (tasksJson != null) {
      final List<dynamic> tasksList = json.decode(tasksJson);
      setState(() {
        todoItems = tasksList.map((task) => TaskItem.fromJson(task)).toList();
      });
    } else {
      // Load default tasks if no saved tasks exist
      setState(() {
        todoItems = _getDefaultTasksForCategory(widget.listName);
      });
      _saveTasks(); // Save the default tasks
    }
  }

  Future<void> _saveTasks() async {
    final String tasksJson =
        json.encode(todoItems.map((task) => task.toJson()).toList());
    await prefs.setString('tasks_${widget.listName}', tasksJson);
  }

  List<TaskItem> _getDefaultTasksForCategory(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'things to do':
        return [
          TaskItem('Call mom', false),
          TaskItem('Get Groceries', false),
          TaskItem('Go to the Gym', false),
          TaskItem('Read a Book', false),
          TaskItem('Meditate', false),
          TaskItem('Plan my next trip', false),
        ];
      case 'notes':
        return [
          TaskItem('Meeting notes from yesterday', false),
          TaskItem('Ideas for weekend project', false),
          TaskItem('Shopping list ideas', false),
        ];
      case 'grocery list':
        return [
          TaskItem('Milk', false),
          TaskItem('Bread', false),
          TaskItem('Eggs', false),
          TaskItem('Bananas', false),
          TaskItem('Chicken breast', false),
          TaskItem('Rice', false),
          TaskItem('Tomatoes', false),
          TaskItem('Onions', false),
          TaskItem('Cheese', false),
          TaskItem('Yogurt', false),
          TaskItem('Cereal', false),
          TaskItem('Orange juice', false),
          TaskItem('Coffee beans', false),
        ];
      case 'work':
        return [
          TaskItem('Review project proposal', false),
          TaskItem('Schedule team meeting', false),
          TaskItem('Update project timeline', false),
          TaskItem('Prepare presentation slides', false),
          TaskItem('Follow up with client', false),
        ];
      case 'books to read':
        return [
          TaskItem('The Pragmatic Programmer', false),
          TaskItem('Clean Code', false),
          TaskItem('Design Patterns', false),
          TaskItem('Flutter in Action', false),
        ];
      case 'movies to watch':
        return [
          TaskItem('Inception', false),
          TaskItem('The Matrix', false),
          TaskItem('Interstellar', false),
          TaskItem('Blade Runner 2049', false),
        ];
      case 'personal':
        return [
          TaskItem('Call dentist for appointment', false),
          TaskItem('Plan birthday party', false),
          TaskItem('Organize photos', false),
          TaskItem('Update resume', false),
        ];
      case 'places to visit':
        return [
          TaskItem('Paris, France', false),
          TaskItem('Tokyo, Japan', false),
          TaskItem('New York, USA', false),
          TaskItem('London, UK', false),
        ];
      default:
        return [
          TaskItem('Add your first task', false),
        ];
    }
  }

  void _toggleTask(int index) {
    setState(() {
      todoItems[index].isCompleted = !todoItems[index].isCompleted;
    });
    _saveTasks(); // Save after toggling
  }

  void _addNewTask() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newTaskText = '';
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text('Add New Task', style: TextStyle(color: Colors.white)),
          content: TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter task name',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            onChanged: (value) {
              newTaskText = value;
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                if (newTaskText.trim().isNotEmpty) {
                  setState(() {
                    todoItems.add(TaskItem(newTaskText.trim(), false));
                  });
                  _saveTasks(); // Save after adding
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(int index) {
    setState(() {
      todoItems.removeAt(index);
    });
    _saveTasks(); // Save after deleting
  }

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Share list',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'List members',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.purple,
                  child: Text('JD', style: TextStyle(color: Colors.white)),
                ),
                title: Text('John Doe', style: TextStyle(color: Colors.white)),
                trailing: Text('Owner', style: TextStyle(color: Colors.grey)),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('INVITE VIA...'),
                  ],
                ),
                onPressed: () {
                  // TODO: Implement invite functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Text(
                  'Anyone with this link and a Microsoft account can\njoin and edit this list.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: TextButton(
                  child: Text('MANAGE ACCESS',
                      style: TextStyle(color: Colors.blue)),
                  onPressed: () {
                    // TODO: Implement manage access functionality
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.listName, style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add, color: Colors.white),
            onPressed: () => _showShareOptions(context),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // TODO: Implement more options functionality
            },
          ),
        ],
      ),
      body: todoItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 64, color: Colors.grey[600]),
                  SizedBox(height: 16),
                  Text(
                    'No tasks yet',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first task',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: todoItems.length,
              itemBuilder: (context, index) {
                final task = todoItems[index];
                return Dismissible(
                  key: Key(task.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => _deleteTask(index),
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(
                        task.isCompleted
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: task.isCompleted ? Colors.green : Colors.white,
                        size: 24,
                      ),
                      onPressed: () => _toggleTask(index),
                    ),
                    title: Text(
                      task.text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: Colors.grey,
                      ),
                    ),
                    onTap: () => _toggleTask(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class TaskItem {
  final String id;
  final String text;
  bool isCompleted;

  TaskItem(this.text, this.isCompleted)
      : id = DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isCompleted': isCompleted,
    };
  }

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      json['text'] as String,
      json['isCompleted'] as bool,
    );
  }
}
