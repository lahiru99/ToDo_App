import 'package:flutter/material.dart';
import 'package:glyph/screens/task_list_screen.dart';
import 'package:glyph/services/task_service.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> categories = [
    {'name': 'Things to do', 'count': 0, 'icon': Icons.check_circle_outline},
    {'name': 'Notes', 'count': 0, 'icon': Icons.note},
    {'name': 'Grocery List', 'count': 0, 'icon': Icons.shopping_cart},
    {'name': 'Work', 'count': 0, 'icon': Icons.work},
    {'name': 'Books To Read', 'count': 0, 'icon': Icons.book},
    {'name': 'Movies To Watch', 'count': 0, 'icon': Icons.movie},
    {'name': 'Personal', 'count': 0, 'icon': Icons.person},
    {'name': 'Places to visit', 'count': 0, 'icon': Icons.place},
  ];

  late AnimationController _controller;
  late Animation<double> _animation;
  final TaskService _taskService = TaskService();

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
    _loadTaskCounts();
    _loadCustomCategories();
  }

  Future<void> _loadTaskCounts() async {
    final counts = await _taskService.getAllTaskCounts();
    setState(() {
      for (int i = 0; i < categories.length; i++) {
        categories[i]['count'] = counts[categories[i]['name']] ?? 0;
      }
    });
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
                  onPressed: () async {
                    if (categoryName.trim().isNotEmpty) {
                      // Add to local list
                      setState(() {
                        categories.add({
                          'name': categoryName.trim(),
                          'count': 0,
                          'icon': selectedIcon
                        });
                      });

                      // Save to storage
                      await _saveCategories();

                      // Refresh task counts
                      _loadTaskCounts();

                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _saveCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> categoriesToSave = categories
          .map((cat) => {
                'name': cat['name'],
                'icon': cat['icon'].codePoint, // Save icon as code point
              })
          .toList();

      await prefs.setString('custom_categories', json.encode(categoriesToSave));
    } catch (e) {
      print('Error saving categories: $e');
    }
  }

  Future<void> _loadCustomCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? categoriesJson = prefs.getString('custom_categories');

      if (categoriesJson != null) {
        final List<dynamic> savedCategories = json.decode(categoriesJson);
        final List<Map<String, dynamic>> customCategories =
            savedCategories.map((cat) {
          return {
            'name': cat['name'],
            'count': 0,
            'icon': IconData(cat['icon'], fontFamily: 'MaterialIcons'),
          };
        }).toList();

        setState(() {
          // Keep default categories and add custom ones
          categories.clear();
          categories.addAll(_getDefaultCategories());
          categories.addAll(customCategories);
        });
      }
    } catch (e) {
      print('Error loading custom categories: $e');
    }
  }

  List<Map<String, dynamic>> _getDefaultCategories() {
    return [
      {'name': 'Things to do', 'count': 0, 'icon': Icons.check_circle_outline},
      {'name': 'Notes', 'count': 0, 'icon': Icons.note},
      {'name': 'Grocery List', 'count': 0, 'icon': Icons.shopping_cart},
      {'name': 'Work', 'count': 0, 'icon': Icons.work},
      {'name': 'Books To Read', 'count': 0, 'icon': Icons.book},
      {'name': 'Movies To Watch', 'count': 0, 'icon': Icons.movie},
      {'name': 'Personal', 'count': 0, 'icon': Icons.person},
      {'name': 'Places to visit', 'count': 0, 'icon': Icons.place},
    ];
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
                              : _buildCategoryCard(context, categories[index]),
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

  Widget _buildCategoryCard(
      BuildContext context, Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskListScreen(listName: category['name']),
          ),
        );
        // Refresh counts when returning from task list
        _loadTaskCounts();
      },
      onLongPress: () {
        // Only allow deletion of custom categories (not default ones)
        if (!_isDefaultCategory(category['name'])) {
          _showDeleteCategoryDialog(category);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[800]!, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category['icon'],
              size: 40,
              color: Colors.blue,
            ),
            SizedBox(height: 8),
            Text(
              category['name'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Text(
              '${category['count']} tasks',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isDefaultCategory(String categoryName) {
    final defaultCategories = [
      'Things to do',
      'Notes',
      'Grocery List',
      'Work',
      'Books To Read',
      'Movies To Watch',
      'Personal',
      'Places to visit',
    ];
    return defaultCategories.contains(categoryName);
  }

  void _showDeleteCategoryDialog(Map<String, dynamic> category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            'Delete Category',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete "${category['name']}"? This will also delete all tasks in this category.',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Delete'),
              onPressed: () async {
                await _deleteCategory(category);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCategory(Map<String, dynamic> category) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Remove tasks for this category
      await prefs.remove('tasks_${category['name']}');

      // Remove from local list
      setState(() {
        categories.removeWhere((cat) => cat['name'] == category['name']);
      });

      // Save updated categories list
      await _saveCategories();

      // Refresh task counts
      _loadTaskCounts();
    } catch (e) {
      print('Error deleting category: $e');
    }
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
