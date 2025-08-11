import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TaskService {
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;
  TaskService._internal();

  Future<int> getTaskCount(String categoryName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? tasksJson = prefs.getString('tasks_$categoryName');

      if (tasksJson != null) {
        final List<dynamic> tasksList = json.decode(tasksJson);
        return tasksList.length;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  Future<List<String>> getAllCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> allCategories = [
      'Things to do',
      'Notes',
      'Grocery List',
      'Work',
      'Books To Read',
      'Movies To Watch',
      'Personal',
      'Places to visit',
    ];

    // Load custom categories
    try {
      final String? customCategoriesJson = prefs.getString('custom_categories');
      if (customCategoriesJson != null) {
        final List<dynamic> customCategories =
            json.decode(customCategoriesJson);
        for (var cat in customCategories) {
          allCategories.add(cat['name'] as String);
        }
      }
    } catch (e) {
      print('Error loading custom categories: $e');
    }

    return allCategories;
  }

  Future<Map<String, int>> getAllTaskCounts() async {
    final categories = await getAllCategories();
    final Map<String, int> counts = {};

    for (String category in categories) {
      counts[category] = await getTaskCount(category);
    }

    return counts;
  }
}
