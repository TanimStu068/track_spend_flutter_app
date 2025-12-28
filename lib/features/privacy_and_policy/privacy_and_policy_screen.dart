import 'package:flutter/material.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool isDataSharingEnabled = false;
  bool isPasswordProtectionEnabled = true;
  bool isAnalyticsEnabled = true;

  Widget buildPrivacyOption({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
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
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: (val) => onChanged(val),
          activeColor: Colors.deepPurple,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Privacy"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Privacy Settings",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 16),
              buildPrivacyOption(
                title: "Data Sharing",
                subtitle: "Allow app to share anonymous usage data",
                value: isDataSharingEnabled,
                onChanged: (val) {
                  setState(() {
                    isDataSharingEnabled = val;
                  });
                },
              ),
              buildPrivacyOption(
                title: "Password Protection",
                subtitle: "Require password when opening the app",
                value: isPasswordProtectionEnabled,
                onChanged: (val) {
                  setState(() {
                    isPasswordProtectionEnabled = val;
                  });
                },
              ),
              buildPrivacyOption(
                title: "Analytics",
                subtitle: "Send usage statistics to improve the app",
                value: isAnalyticsEnabled,
                onChanged: (val) {
                  setState(() {
                    isAnalyticsEnabled = val;
                  });
                },
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Save privacy settings logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Privacy settings saved"),
                        backgroundColor: Colors.deepPurple,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    "Save Settings",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
