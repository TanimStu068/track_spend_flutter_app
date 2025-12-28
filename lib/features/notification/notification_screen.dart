import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationModel {
  final String title;
  final String message;
  final DateTime dateTime;
  bool isRead;

  NotificationModel({
    required this.title,
    required this.message,
    required this.dateTime,
    this.isRead = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Replace with Hive or API data
  final List<NotificationModel> notifications = [
    NotificationModel(
      title: "Budget Reminder",
      message: "You are nearing your monthly budget limit.",
      dateTime: DateTime.now().subtract(Duration(minutes: 30)),
    ),
    NotificationModel(
      title: "Expense Added",
      message: "New expense of \$25 added in Food category.",
      dateTime: DateTime.now().subtract(Duration(hours: 2)),
    ),
    NotificationModel(
      title: "Income Updated",
      message: "Your income has been updated successfully.",
      dateTime: DateTime.now().subtract(Duration(days: 1)),
    ),
  ];

  void markAsRead(int index) {
    setState(() {
      notifications[index].isRead = true;
    });
  }

  void deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 2,
        centerTitle: true,
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: 80,
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withOpacity(0.4),
                    // color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "No Notifications",
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(
                        context,
                      ).colorScheme.surface.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Dismissible(
                  key: Key(
                    notification.title + notification.dateTime.toString(),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => deleteNotification(index),
                  background: Container(
                    padding: EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: GestureDetector(
                    onTap: () => markAsRead(index),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: notification.isRead
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.surface.withOpacity(0.3)
                                    : Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.8),
                              ),
                              padding: EdgeInsets.all(12),
                              child: Icon(
                                Icons.notifications,
                                color: notification.isRead
                                    ? Colors.grey
                                    : Colors.white,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    notification.message,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              DateFormat(
                                'hh:mm a',
                              ).format(notification.dateTime),
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(
                                  context,
                                ).colorScheme.surface.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
