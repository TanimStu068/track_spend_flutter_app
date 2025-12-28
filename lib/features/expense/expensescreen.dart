import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:track_spend/features/add_expense/add_expense_screen.dart';
import 'package:track_spend/features/widgets/expense_list.dart';
import 'package:track_spend/model/expense_model.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  DateTime selectedDate = DateTime.now();
  String searchQuery = "";
  Category? selectedCategory;
  final categories = Category.values;

  void _removeExpense(ExpenseModel expense) async {
    final box = Hive.box<ExpenseModel>('expensesBox');

    // Save a copy for Undo
    final deletedExpense = expense;

    // Delete immediately from Hive so UI updates
    await box.delete(expense.id);

    // Show SnackBar for Undo
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            // Restore the deleted expense in Hive
            await box.put(deletedExpense.id, deletedExpense);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<ExpenseModel>('expensesBox');

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Expenses'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box<ExpenseModel> box, _) {
            final expensesList = box.values.where((expense) {
              final matchesSearch =
                  expense.title.toLowerCase().contains(searchQuery) ||
                  expense.amount.toString().contains(searchQuery) ||
                  expense.category.name.toLowerCase().contains(searchQuery);

              final matchesCategory =
                  selectedCategory == null ||
                  expense.category == selectedCategory;

              return matchesSearch && matchesCategory;
            }).toList();

            return Column(
              children: [
                const SizedBox(height: 4),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search expenses...',
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                ),
                const SizedBox(height: 6),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ChoiceChip(
                        label: Text(
                          'All',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        selected: selectedCategory == null,
                        selectedColor: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant, // Color when selected
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        onSelected: (_) {
                          setState(() {
                            selectedCategory = null;
                          });
                        },
                      ),
                      SizedBox(width: 8),
                      // Dynamic chips from enum
                      ...categories.map((cat) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(
                              cat.name,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ), // Converts enum to string
                            selected: selectedCategory == cat,
                            selectedColor: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,

                            onSelected: (selected) {
                              setState(() {
                                selectedCategory = selected ? cat : null;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder(
                  valueListenable: Hive.box<ExpenseModel>(
                    'expensesBox',
                  ).listenable(),
                  builder: (context, Box<ExpenseModel> expenseBox, _) {
                    final financeBox = Hive.box('financeBox');

                    // 1️⃣ Calculate total expenses
                    double totalExpenses = 0;
                    for (var expense in expenseBox.values) {
                      totalExpenses += expense.amount;
                    }

                    // 2️⃣ Get income & budget
                    final double income = financeBox.get(
                      'income',
                      defaultValue: 0.0,
                    );
                    final double budget = financeBox.get(
                      'budget',
                      defaultValue: 0.0,
                    );

                    // 3️⃣ Calculate balances
                    final double totalBalance = income + budget;
                    final double newBalance = totalBalance - totalExpenses;

                    return Row(
                      children: [
                        Expanded(
                          child: Card(
                            color: const Color.fromARGB(255, 232, 109, 27),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 16,
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Total Expenses',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '\$${totalExpenses.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Card(
                            color: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 16,
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'New Balance',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '\$${newBalance.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                if (expensesList.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        'No expenses found for this category.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 16),
                Expanded(
                  child: expensesList.isEmpty
                      ? Container() // Empty container since message is already shown
                      : ExpensesList(
                          onRemoveExpense: _removeExpense,
                          expenses: expensesList,
                        ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
