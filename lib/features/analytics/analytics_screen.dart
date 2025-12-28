import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:track_spend/model/expense_model.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<ExpenseModel>('expensesBox');
    final List<ExpenseModel> expensesList = box.values.toList();

    // Group expenses by category
    final Map<Category, double> categoryTotals = {};
    for (var expense in expensesList) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    // Convert to a list for easier mapping
    final List<Map<String, dynamic>> categoryData = categoryTotals.entries.map((
      entry,
    ) {
      Color color;
      switch (entry.key) {
        case Category.food:
          color = Colors.deepPurple;
          break;
        case Category.shopping:
          color = Colors.orange;
          break;
        case Category.transport:
          color = Colors.blue;
          break;
        case Category.bills:
          color = Colors.green;
          break;
        case Category.entertainment:
          color = Colors.pink;
          break;
        case Category.educations:
          color = Colors.teal;
          break;
        case Category.other:
          color = Colors.grey;
          break;
      }
      return {
        'category': entry.key.name.toUpperCase(),
        'amount': entry.value,
        'color': color,
      };
    }).toList();

    double totalAmount = categoryData.fold(
      0,
      (sum, item) => sum + item['amount'],
    );

    // Calculate monthly spending
    final List<double> monthlySpending = List.generate(12, (index) => 0.0);
    for (var expense in expensesList) {
      if (expense.date.month >= 1 && expense.date.month <= 12) {
        monthlySpending[expense.date.month - 1] += expense.amount;
      }
    }
    final List<ExpenseModel> topExpenses = List.from(expensesList);
    topExpenses.sort((a, b) => b.amount.compareTo(a.amount));
    final List<ExpenseModel> top3Expenses = topExpenses.length >= 3
        ? topExpenses.sublist(0, 3)
        : topExpenses;

    // Summary values
    double highest = expensesList.isEmpty
        ? 0
        : expensesList.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
    double lowest = expensesList.isEmpty
        ? 0
        : expensesList.map((e) => e.amount).reduce((a, b) => a < b ? a : b);
    double avg = expensesList.isEmpty
        ? 0
        : expensesList.map((e) => e.amount).reduce((a, b) => a + b) /
              expensesList.length;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Analytics'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: totalAmount == 0
            ? Center(
                child: Text(
                  'No expenses found. Add expenses to see analytics.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatCard(
                          'Highest Expense',
                          '\$${highest.toStringAsFixed(2)}',
                          Colors.redAccent,
                        ),
                        _buildStatCard(
                          'Lowest Expense',
                          '\$${lowest.toStringAsFixed(2)}',
                          Colors.deepPurple,
                        ),
                        _buildStatCard(
                          'Average Expense',
                          '\$${avg.toStringAsFixed(2)}',
                          Colors.teal,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // Pie Chart
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: categoryData.map((data) {
                            return PieChartSectionData(
                              color: data['color'],
                              value: data['amount'].toDouble(),
                              title:
                                  '${((data['amount'] / totalAmount) * 100).toStringAsFixed(0)}%',
                              radius: 60,
                              titleStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList(),
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    ),
                    SizedBox(height: 17),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Monthly Spending Overview',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ),
                    SizedBox(height: 7),

                    // Monthly Spending Bar Chart
                    SizedBox(
                      height: 180,
                      child: BarChart(
                        BarChartData(
                          barGroups: List.generate(
                            monthlySpending.length,
                            (index) => BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: monthlySpending[index],
                                  color: Colors.deepPurpleAccent,
                                  width: 14,
                                ),
                              ],
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final months = [
                                    'Jan',
                                    'Feb',
                                    'Mar',
                                    'Apr',
                                    'May',
                                    'Jun',
                                    'Jul',
                                    'Aug',
                                    'Sep',
                                    'Oct',
                                    'Nov',
                                    'Dec',
                                  ];
                                  return SideTitleWidget(
                                    meta: meta,
                                    child: Text(
                                      months[value.toInt()],
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                                reservedSize: 30,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Spending by Category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ),
                    SizedBox(height: 9),

                    // Category Bars
                    Column(
                      children: categoryData.map((data) {
                        double percent = data['amount'] / totalAmount;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  data['category'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.8),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  height: 14, // make it thicker
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: percent,
                                      valueColor: AlwaysStoppedAnimation(
                                        data['color'],
                                      ),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 8),
                              Text('\$${data['amount'].toStringAsFixed(2)}'),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),

                    // Top 3 Expenses
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Top 3 expenses',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),

                    SizedBox(height: 8),
                    ...top3Expenses.map(
                      (expense) => Card(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getCategoryColor(
                              expense.category,
                            ),
                            child: Text(
                              expense.category.name[0].toUpperCase(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            '\$${expense.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          subtitle: Text(
                            DateFormat('dd MMM yyyy').format(expense.date),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          trailing: Text(
                            expense.category.name.toUpperCase(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Color _getCategoryColor(Category category) {
    switch (category) {
      case Category.food:
        return Colors.deepPurple;
      case Category.shopping:
        return Colors.orange;
      case Category.transport:
        return Colors.blue;
      case Category.bills:
        return Colors.green;
      case Category.entertainment:
        return Colors.pink;
      case Category.educations:
        return Colors.teal;
      case Category.other:
        return Colors.grey;
    }
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
