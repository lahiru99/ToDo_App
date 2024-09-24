import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ShareScreen extends StatefulWidget {
  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> sharedLists = [
    {
      'listName': 'Work Projects',
      'sharedWith': [
        {'name': 'Alice Johnson', 'email': 'alice@example.com'},
        {'name': 'Bob Smith', 'email': 'bob@example.com'},
      ],
    },
    {
      'listName': 'Grocery List',
      'sharedWith': [
        {'name': 'Carol Davis', 'email': 'carol@example.com'},
      ],
    },
    {
      'listName': 'Vacation Plans',
      'sharedWith': [
        {'name': 'David Brown', 'email': 'david@example.com'},
        {'name': 'Eve Wilson', 'email': 'eve@example.com'},
      ],
    },
  ];

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Shared Lists', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: AnimationLimiter(
        child: ListView.builder(
          itemCount: sharedLists.length,
          itemBuilder: (context, index) {
            final sharedList = sharedLists[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: ExpansionTile(
                    title: Text(sharedList['listName'],
                        style: TextStyle(color: Colors.white)),
                    children: [
                      ...sharedList['sharedWith'].map<Widget>((person) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(person['name'][0],
                                style: TextStyle(color: Colors.white)),
                          ),
                          title: Text(person['name'],
                              style: TextStyle(color: Colors.white)),
                          subtitle: Text(person['email'],
                              style: TextStyle(color: Colors.grey)),
                          trailing: IconButton(
                            icon: Icon(Icons.more_vert, color: Colors.white),
                            onPressed: () {
                              // TODO: Implement options for managing this share
                            },
                          ),
                        );
                      }).toList(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: Text('Invite More'),
                          onPressed: () {
                            // TODO: Implement invite functionality
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _animation,
        child: FloatingActionButton(
          onPressed: () {
            // TODO: Implement functionality to share a new list
          },
          child: Icon(Icons.share),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}
