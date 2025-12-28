import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({super.key, required this.fill, required this.color});

  final double fill;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: fill),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.linear,
          builder: (context, value, child) {
            return FractionallySizedBox(
              heightFactor: value,
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [color.withOpacity(.85), color.withOpacity(.5)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
