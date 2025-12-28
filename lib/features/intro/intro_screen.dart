import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:track_spend/features/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:track_spend/features/welcome/welcome_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IntroductionScreen(
            key: introKey,
            showSkipButton: false, // hide default skip
            showNextButton: false,
            showDoneButton: false,

            // Pages
            pages: [
              PageViewModel(
                title: "",
                bodyWidget: _buildPageContent(
                  title: "Track Your Balance Instantly",
                  body:
                      "See your total balance, today’s highest expense, and monthly overview at a glance.",
                  imagePath: 'assets/images/new_dashboard.png',
                ),
                decoration: PageDecoration(
                  pageColor: Theme.of(context).scaffoldBackgroundColor,
                  titlePadding: EdgeInsets.zero,
                  bodyPadding: EdgeInsets.zero,
                  imagePadding: EdgeInsets.zero,
                ),
              ),
              PageViewModel(
                title: "",
                bodyWidget: _buildPageContent(
                  title: "Add, Edit & Categorize Expenses",
                  body:
                      "Quickly add new expenses, filter by category, and manage your spending efficiently.",
                  imagePath: 'assets/images/expense.png',
                ),
                decoration: PageDecoration(
                  pageColor: Theme.of(context).scaffoldBackgroundColor,
                  titlePadding: EdgeInsets.zero,
                  bodyPadding: EdgeInsets.zero,
                  imagePadding: EdgeInsets.zero,
                ),
              ),
              PageViewModel(
                title: "",
                bodyWidget: _buildPageContent(
                  title: "Understand Your Spending Patterns",
                  body:
                      "Visualize your top expenses, spending by category, and monthly trends with charts.",
                  imagePath: 'assets/images/analysis.svg',
                ),
                decoration: PageDecoration(
                  pageColor: Theme.of(context).scaffoldBackgroundColor,
                  titlePadding: EdgeInsets.zero,
                  bodyPadding: EdgeInsets.zero,
                  imagePadding: EdgeInsets.zero,
                ),
              ),
            ],

            onChange: (index) {
              setState(() {
                currentPageIndex = index;
              });
            },

            // Dots decorator
            dotsDecorator: DotsDecorator(
              size: const Size(10, 10),
              color: Theme.of(context).colorScheme.onSurface,
              activeSize: const Size(22, 10),
              activeColor: Theme.of(context).colorScheme.primary,
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),

            // Custom Continue/Get Started button above dots
            globalFooter: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (currentPageIndex == 2) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => WelcomeScreen()),
                      );
                    } else {
                      introKey.currentState?.next();
                    }
                  },
                  child: Text(
                    currentPageIndex == 2 ? "Get Started" : "Continue",
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),

          // Top-right skip button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => ModernBottomNavBar()),
                );
              },
              child: Text(
                "Skip",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Custom page content with centered image and text
  Widget _buildPageContent({
    required String title,
    required String body,
    required String imagePath,
  }) {
    bool isSvg = imagePath.toLowerCase().endsWith('.svg');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 55),
        isSvg
            ? SvgPicture.asset(imagePath, width: 240, height: 240)
            : Image.asset(imagePath, width: 240, height: 240),
        const SizedBox(height: 40),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            body,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}
