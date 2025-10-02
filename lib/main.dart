import 'package:flutter/material.dart';
import 'package:running_tracker/db/database_instance.dart';

import 'package:running_tracker/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = DatabaseInstance();
  db.database;
  runApp(const RunningTrackerApp());
}

class RunningTrackerApp extends StatelessWidget {
  const RunningTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Running Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}
