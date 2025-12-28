import 'package:flutter/material.dart';
import 'package:track_spend/features/add_expense/add_expense_screen.dart';
import 'package:track_spend/features/analytics/analytics_screen.dart';
import 'package:track_spend/features/expense/expensescreen.dart';
import 'package:track_spend/features/home/home_screen.dart';
import 'package:track_spend/features/profile/profile_screen.dart';

class ModernBottomNavBar extends StatefulWidget {
  const ModernBottomNavBar({super.key});

  @override
  State<ModernBottomNavBar> createState() => _ModernBottomNavBarState();
}

class _ModernBottomNavBarState extends State<ModernBottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    ExpensesScreen(),
    Container(),
    AnalyticsScreen(),
    UserProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddExpenseScreen()),
      );
      ;
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 76,
          child: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 8.0,
            elevation: 10,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildNavItem(Icons.home, 0),
                  buildNavItem(Icons.list_alt, 1),
                  SizedBox(width: 40), // space for FAB
                  buildNavItem(Icons.bar_chart, 3),
                  buildNavItem(Icons.person, 4),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onItemTapped(2),
        backgroundColor: Colors.deepPurple,
        elevation: 5,
        child: Icon(Icons.add, size: 30, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildNavItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(50),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.deepPurple : Colors.grey,
              size: isSelected ? 28 : 24,
            ),
            if (isSelected)
              Container(
                margin: EdgeInsets.only(top: 2),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
