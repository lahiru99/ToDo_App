import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:glyph/screens/main_screen.dart';
import 'package:glyph/services/auth_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDoz',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.black,
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.blue,
          surface: Color(0xFF1E1E1E),
          background: Colors.black,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: Color(0xFF1E1E1E),
        ),
        textTheme: TextTheme(
          headlineSmall: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
      home: MainScreen(),
    );
  }
}

// Remove the MyHomePage and _MyHomePageState classes
