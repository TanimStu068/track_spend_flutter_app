import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:track_spend/constants/theme/color_theme.dart';
import 'package:track_spend/constants/theme/theme_provider.dart';
import 'package:track_spend/features/splash/splash_screen.dart';
import 'package:track_spend/model/expense_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:track_spend/service/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await Hive.initFlutter();

  Hive.registerAdapter(ExpenseModelAdapter());
  Hive.registerAdapter(CategoryAdapter());

  await Hive.openBox<ExpenseModel>('expensesBox');
  await Hive.openBox('financeBox');

  await NotificationService.init(); // initialize notifications

  // Schedule daily notification at 8:00 AM
  NotificationService.scheduleDailyNotification(
    id: 0,
    title: "Expense Tracker Reminder",
    body: "Add new expense and track them!",
    hour: 8,
    minute: 0,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Track Spend',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const SplashScreen(),
    );
  }
}
