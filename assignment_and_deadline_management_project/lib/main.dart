import 'package:fe_admin_web/presentation/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fe_admin_web/data/providers/auth_provider.dart';
import 'package:fe_admin_web/data/providers/user_provider.dart';
import 'package:fe_admin_web/data/providers/subject_provider.dart';
import 'package:fe_admin_web/data/providers/post_provider.dart';
import 'package:fe_admin_web/data/providers/user_logs_provider.dart';
import 'package:fe_admin_web/data/providers/statistics_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => SubjectProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => UserLogsProvider()),
        ChangeNotifierProvider(create: (_) => StatisticsProvider()),
      ],
      child: const AdminWebApp(),
    ),
  );
}

class AdminWebApp extends StatelessWidget {
  const AdminWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Admin Web',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: const Color(0xFF4A7DFF),
      ),
      home: const AuthScreen(),
    );
  }
}