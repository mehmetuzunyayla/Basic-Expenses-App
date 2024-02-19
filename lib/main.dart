import 'package:expenses_app/data/expense_data.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/home_page.dart';

final expenseDataProvider = ChangeNotifierProvider((ref) => ExpenseData());

Future<void> main() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Open a Hive box
  await Hive.openBox('expense_database');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
