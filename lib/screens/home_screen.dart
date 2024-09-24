import 'package:flutter/material.dart';
import 'package:glyph/screens/task_list_screen.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> categories = [
    {'name': 'Things to do', 'count': 99, 'icon': Icons.check_circle_outline},
    {'name': 'Notes', 'count': 0, 'icon': Icons.note},
    {'name': 'Grocery List', 'count': 13, 'icon': Icons.shopping_cart},
    {'name': 'Work', 'count': 0, 'icon': Icons.work},
    {'name': 'Books To Read', 'count': 0, 'icon': Icons.book},
    {'name': 'Movies To Watch', 'count': 1, 'icon': Icons.movie},
    {'name': 'Personal', 'count': 0, 'icon': Icons.person},
    {'name': 'Places to visit', 'count': 1, 'icon': Icons.place},
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

  void _addCategory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String categoryName = '';
        IconData selectedIcon = Icons.check_circle_outline;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Category'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Category Name'),
                    onChanged: (value) {
                      categoryName = value;
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButton<IconData>(
                    value: selectedIcon,
                    items: [
                      DropdownMenuItem(
                          child: Icon(Icons.check_circle_outline),
                          value: Icons.check_circle_outline),
                      DropdownMenuItem(
                          child: Icon(Icons.note), value: Icons.note),
                      DropdownMenuItem(
                          child: Icon(Icons.shopping_cart),
                          value: Icons.shopping_cart),
                      DropdownMenuItem(
                          child: Icon(Icons.work), value: Icons.work),
                      DropdownMenuItem(
                          child: Icon(Icons.book), value: Icons.book),
                      DropdownMenuItem(
                          child: Icon(Icons.movie), value: Icons.movie),
                      DropdownMenuItem(
                          child: Icon(Icons.person), value: Icons.person),
                      DropdownMenuItem(
                          child: Icon(Icons.place), value: Icons.place),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedIcon = value!;
                      });
                    },
                    hint: Text('Select Icon'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text('Add'),
                  onPressed: () {
                    setState(() {
                      categories.add({
                        'name': categoryName,
                        'count': 0,
                        'icon': selectedIcon
                      });
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeTransition(
              opacity: _animation,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for tasks, events, etc...',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            SlideTransition(
              position: Tween<Offset>(
                begin: Offset(-0.5, 0),
                end: Offset.zero,
              ).animate(_animation),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Categories',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: AnimationLimiter(
                child: GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: categories.length + 1,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      columnCount: 2,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: index == categories.length
                              ? _buildAddCategoryButton()
                              : _buildCategoryItem(context, categories[index]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(
      BuildContext context, Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskListScreen(listName: category['name']),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[800]!, width: 2),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(category['icon'], color: Colors.white, size: 30),
                  SizedBox(height: 8),
                  Text(
                    category['name'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (category['count'] > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${category['count']}',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCategoryButton() {
    return GestureDetector(
      onTap: _addCategory,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue, width: 2),
        ),
        child: Center(
          child: Icon(Icons.add, color: Colors.blue, size: 40),
        ),
      ),
    );
  }
}
