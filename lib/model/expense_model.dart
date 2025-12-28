import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'expense_model.g.dart';

final formatter = DateFormat.yMd();
const uuid = Uuid();

@HiveType(typeId: 2)
enum Category {
  @HiveField(0)
  food,
  @HiveField(1)
  transport,
  @HiveField(2)
  shopping,
  @HiveField(3)
  bills,
  @HiveField(4)
  entertainment,
  @HiveField(5)
  educations,
  @HiveField(6)
  other,
}

@HiveType(typeId: 1)
class ExpenseModel {
  ExpenseModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.notes,
  }) : id = uuid.v4();

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final Category category;
  @HiveField(5)
  final String notes;

  String get formattedDate => formatter.format(date);
}

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<ExpenseModel> allExpense, this.category)
    : expenses = allExpense
          .where((expense) => expense.category == category)
          .toList();
  final Category category;
  final List<ExpenseModel> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
