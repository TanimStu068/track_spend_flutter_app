import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:track_spend/features/widgets/chart/chart.dart';
import 'package:track_spend/features/widgets/expense_item.dart';
import 'package:track_spend/model/expense_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double totalBalance = 10000.0; // Hardcoded example
  double totalExpenses = 4000.0; // Hardcoded example
  double get netBalance => totalBalance - totalExpenses;

  List<double> monthlySpending = [1404, 1544, 2917, 2484, 2364, 0];

  double getHighestExpenseToday(List<ExpenseModel> expenses) {
    final today = DateTime.now();
    final todayExpenses = expenses.where(
      (e) =>
          e.date.year == today.year &&
          e.date.month == today.month &&
          e.date.day == today.day,
    );
    if (todayExpenses.isEmpty) return 0;
    return todayExpenses.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
  }

  double getAverageDailySpending(List<ExpenseModel> expenses) {
    if (expenses.isEmpty) return 0;
    final Map<DateTime, double> dailyTotals = {};
    for (var e in expenses) {
      final day = DateTime(e.date.year, e.date.month, e.date.day);
      dailyTotals[day] = (dailyTotals[day] ?? 0) + e.amount;
    }
    final totalDays = dailyTotals.length;
    final totalAmount = dailyTotals.values.fold(0.0, (a, b) => a + b);
    return totalAmount / totalDays;
  }

  int getNumberOfExpensesThisMonth(List<ExpenseModel> expenses) {
    final now = DateTime.now();
    return expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<ExpenseModel>('expensesBox');
    final List<ExpenseModel> expensesList = box.values.toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Home'),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Total Balance Card
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.purpleAccent],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Balance',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '\$${totalBalance.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.credit_card, color: Colors.white, size: 40),
                  ],
                ),
              ),
              SizedBox(height: 6),

              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatCard(
                      'Highest Today',
                      '\$${getHighestExpenseToday(expensesList).toStringAsFixed(2)}',
                      Colors.orange,
                    ),
                    _buildStatCard(
                      'Avg Daily',
                      '\$${getAverageDailySpending(expensesList).toStringAsFixed(2)}',
                      Colors.blue,
                    ),
                    _buildStatCard(
                      'This Month',
                      getNumberOfExpensesThisMonth(expensesList).toString(),
                      Colors.green,
                    ),
                  ],
                ),
              ),

              // SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text(
                    'Expense Overview', // or "Monthly Expenses"
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface, // slightly muted for modern look
                    ),
                  ),
                ),
              ),

              //chart
              SizedBox(height: 220, child: Chart(expenses: expensesList)),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text(
                    'Recent Expenses',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface, // slightly muted for modern look
                    ),
                  ),
                ),
              ),
              expensesList.isEmpty
                  ? Center(
                      child: Text(
                        'No expenses found. Add a new expense to get started!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      physics:
                          NeverScrollableScrollPhysics(), // disables its own scrolling
                      shrinkWrap: true, // sizes the list based on content
                      itemCount: expensesList.length,
                      itemBuilder: (context, index) {
                        final expense = expensesList[index];
                        return ExpensesItem(expense);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.85),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
