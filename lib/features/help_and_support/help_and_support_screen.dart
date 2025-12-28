import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@trackspend.com',
      query: 'subject=Help & Support',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '01704755672');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Widget buildFAQCard(BuildContext context, String question, String answer) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(question, style: TextStyle(fontWeight: FontWeight.w500)),
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContactCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = Colors.deepPurple,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.15),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Help & Support"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Contact Us",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: 16),
                buildContactCard(
                  icon: Icons.email,
                  title: "Email Support",
                  onTap: _launchEmail,
                ),
                buildContactCard(
                  icon: Icons.phone,
                  title: "Call Support",
                  onTap: _launchPhone,
                ),
                buildContactCard(
                  icon: Icons.chat,
                  title: "Live Chat",
                  onTap: () {
                    // Implement live chat navigation
                  },
                ),
                SizedBox(height: 24),
                Text(
                  "Frequently Asked Questions",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 16),
                buildFAQCard(
                  context,
                  "How do I reset my password?",
                  "Go to Settings > Privacy > Password Protection, and follow the instructions to reset your password.",
                ),
                buildFAQCard(
                  context,
                  "Can I export my expenses?",
                  "Yes, you can export your expenses in CSV format from the Reports section.",
                ),
                buildFAQCard(
                  context,
                  "How do I contact support?",
                  "You can contact support via email, phone, or live chat from this screen.",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
