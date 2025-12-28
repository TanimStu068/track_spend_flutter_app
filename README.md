# TrackSpend – Personal Finance & Expense Tracker

applogo 

TrackSpend is a full-featured Flutter app that helps users manage their personal finances effectively. It provides an intuitive interface to track income, budget, and expenses, along with insightful analytics and visualizations.  

---

## Features

### Splash & Intro Screens
- **Animated Splash Screen** with smooth transitions.
- **3 Intro Screens** highlighting the key features of the app.
- **Welcome Screen** allowing users to choose **Login** or **Sign Up**.

### Authentication
- **Firebase Authentication & Firestore** for secure user management.
- **Email/Password Sign-Up & Login**.
- **Forgot Password** option to reset the account password.
- **Google Sign-In** integration for quick authentication (optional).

### Home Screen
- **Total Balance**: Overview of total funds.
- **Statistics**: Highest Today, Average Daily, Monthly balance.
- **Expense Overview Chart** to visualize spending patterns.
- **Recent Expense List** with the ability to:
  - Add new expenses with **Title, Amount, Date, Category, and Notes**.
  - Delete any expense with **Undo** functionality.
  - Search and filter expenses by category or title.

### Analysis Page
- **Expense Insights**: Highest, Lowest, and Average expenses.
- **Charts & Graphs**:
  - Pie chart for category-wise spending.
  - Monthly spending overview chart.
- **Spending by Category** using `LinearProgressIndicator`.
- **Top 3 Expenses** summary.

### Profile Screen
- Displays **Name, Email, Expenses, Income, and Budget**.
- Users can **update or add income and budget**.
- Provides **Settings** and **Logout** options.

### Settings Page
- Update **Budget & Income**.
- Access **Notifications** screen.
- **Privacy & Policy** information.
- **Dark/Light Mode** toggle for theme customization.
- **Help & Support** section.
- **About App** information.
- **Delete Account** option to remove account and data from Firebase.

---

## Technology Stack
- **Flutter** – Cross-platform mobile framework.
- **Firebase Auth & Firestore** – Backend for authentication and data storage.
- **Hive** – Local storage for offline expense and finance data.
- **Provider** – State management for theme and other dynamic states.
- **Charts & UI** – Custom charts for data visualization, animated UI components.

---
