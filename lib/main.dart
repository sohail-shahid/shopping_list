import 'package:flutter/material.dart';
import 'package:shopping_list/screens/grocery_list_screen.dart';

final lightColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.white,
);
final darkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Colors.black,
);
final lightTheme = ThemeData.light().copyWith(
  colorScheme: lightColorScheme,
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: lightColorScheme.background,
    foregroundColor: lightColorScheme.onBackground,
  ),
);

final darkTheme = ThemeData.dark().copyWith(
  colorScheme: darkColorScheme,
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: Colors.black26,
    foregroundColor: Colors.white,
  ),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      home: const GroceryListScreen(),
    );
  }
}
