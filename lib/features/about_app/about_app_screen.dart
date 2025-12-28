import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  // Example methods to launch social links
  void _launchWebsite() async {
    final Uri url = Uri.parse('https://trackspend.com');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _launchTwitter() async {
    final Uri url = Uri.parse('https://twitter.com/trackspend');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@trackspend.com',
      query: 'subject=Track Spend Support',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Widget buildInfoCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple.withOpacity(0.15),
          child: Icon(icon, color: Colors.deepPurple),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("About App"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Logo
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.account_balance_wallet,
                    size: 60,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              SizedBox(height: 16),
              // App Name
              Text(
                "Track Spend",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 4),
              // Version
              Text(
                "Version 1.0.0",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
              SizedBox(height: 24),
              // App Description
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Track Spend is your ultimate expense tracker that helps you manage your daily expenses, set budgets, and monitor your financial health with ease. Stay on top of your spending habits and save smarter!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Developer Info
              Text(
                "Developer",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 12),
              buildInfoCard(
                context: context,
                icon: Icons.person,
                title: "Tanim Mahmud",
                subtitle: "Flutter Developer",
              ),
              buildInfoCard(
                context: context,
                icon: Icons.email,
                title: "Email",
                subtitle: "support@trackspend.com",
                onTap: _launchEmail,
              ),
              buildInfoCard(
                context: context,
                icon: Icons.web,
                title: "Website",
                subtitle: "https://trackspend.com",
                onTap: _launchWebsite,
              ),
              buildInfoCard(
                context: context,
                icon: Icons.chat,
                title: "Twitter",
                subtitle: "@trackspend",
                onTap: _launchTwitter,
              ),
              SizedBox(height: 24),
              // Thank you / Footer
              Text(
                "Thank you for using Track Spend!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
