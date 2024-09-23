import 'package:flutter/material.dart';

class TaskListScreen extends StatelessWidget {
  final String listName;

  TaskListScreen({required this.listName});

  final List<String> todoItems = [
    'Call',
    'Get Groceries',
    'Go to the Gym',
    'Read a Book',
    'Meditate',
    'Plan my next trip',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(listName, style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: todoItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.circle_outlined, color: Colors.white, size: 20),
            title: Text(
              todoItems[index],
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onTap: () {
              // TODO: Implement task completion
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add new task functionality
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
