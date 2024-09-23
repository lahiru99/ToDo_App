import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: Theme.of(context).textTheme.headline6),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SizedBox(height: 24),
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: Icon(Icons.person, size: 50, color: Colors.black),
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              'John Doe',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          SizedBox(height: 24),
          ListTile(
            leading: Icon(Icons.edit,
                color: Theme.of(context).colorScheme.secondary),
            title: Text('Edit Profile'),
            onTap: () {
              // TODO: Implement edit profile functionality
            },
          ),
          ListTile(
            leading: Icon(Icons.settings,
                color: Theme.of(context).colorScheme.secondary),
            title: Text('App Settings'),
            onTap: () {
              // TODO: Implement app settings functionality
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app,
                color: Theme.of(context).colorScheme.secondary),
            title: Text('Logout'),
            onTap: () {
              // TODO: Implement logout functionality
            },
          ),
        ],
      ),
    );
  }
}
