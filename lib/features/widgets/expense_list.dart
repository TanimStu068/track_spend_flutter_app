import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:track_spend/features/widgets/expense_item.dart';
import 'package:track_spend/model/expense_model.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.onRemoveExpense,
    required this.expenses,
  });

  final void Function(ExpenseModel expense) onRemoveExpense;
  final List<ExpenseModel> expenses;

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<ExpenseModel>('expensesBox');

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box<ExpenseModel> box, _) {
        // final expenses = box.values.toList();

        if (expenses.isEmpty) return Center(child: Text("No expenses"));

        return ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            final expense = expenses[index];

            return Dismissible(
              // key: ValueKey(expense.id),
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.delete, color: Colors.white),
              ),

              confirmDismiss: (_) async {
                // Remove the item immediately from Hive
                onRemoveExpense(expense);
                // Return true to allow dismiss animation
                return true;
              },
              // onDismissed: (_) {
              //   // Permanently remove after dismiss animation
              //   onRemoveExpense(expense);
              // },
              child: ExpensesItem(expense),
            );
          },
        );
      },
    );
  }
}
