import 'package:flutter/material.dart';

class ShareScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share', style: Theme.of(context).textTheme.headline6),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.share,
              size: 64,
              color: Theme.of(context).colorScheme.secondary,
            ),
            SizedBox(height: 16),
            Text(
              'Share your todo lists',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 8),
            Text(
              'Coming soon!',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
