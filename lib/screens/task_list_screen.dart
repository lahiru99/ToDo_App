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
        title: Text(listName, style: TextStyle(color: Colors.white)),
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
