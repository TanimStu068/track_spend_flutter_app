import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:track_spend/constants/category_icons.dart';
import 'package:track_spend/features/widgets/chart/chart_bar.dart';
import 'package:track_spend/model/expense_model.dart';

class Chart extends StatelessWidget {
  Chart({super.key, required this.expenses});

  final List<ExpenseModel> expenses;

  List<ExpenseBucket> get buckets {
    return [
      ExpenseBucket.forCategory(expenses, Category.food),
      ExpenseBucket.forCategory(expenses, Category.transport),
      ExpenseBucket.forCategory(expenses, Category.shopping),
      ExpenseBucket.forCategory(expenses, Category.bills),
      ExpenseBucket.forCategory(expenses, Category.entertainment),
      ExpenseBucket.forCategory(expenses, Category.educations),
      ExpenseBucket.forCategory(expenses, Category.other),
    ];
  }

  final Map<Category, Color> categoryColors = {
    Category.food: Colors.orange,
    Category.transport: Colors.blue,
    Category.shopping: Colors.pink,
    Category.bills: Colors.green,
    Category.entertainment: Colors.purpleAccent,
    Category.educations: Colors.teal,
    Category.other: Colors.grey,
  };

  double get maxTotalExpense {
    double max = 0;
    for (final bucket in buckets) {
      if (bucket.totalExpenses > max) max = bucket.totalExpenses;
    }
    return max;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          height: 220,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: buckets.map((bucket) {
                    return ChartBar(
                      fill: bucket.totalExpenses == 0
                          ? 0
                          : bucket.totalExpenses / maxTotalExpense,
                      color: categoryColors[bucket.category]!,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: buckets.map((bucket) {
                  return Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          categoryIcons[bucket.category],
                          size: 20,
                          //color: Colors.white,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(.8),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
