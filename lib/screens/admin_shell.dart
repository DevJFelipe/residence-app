import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'dashboard/dashboard_screen.dart';
import 'residents/residents_screen.dart';
import 'billing/billing_screen.dart';
import 'dashboard/widgets/bottom_nav_bar.dart';
import 'package:residence_app/ui/screens/admin/pqrs/pqrs_screen.dart';
import 'package:residence_app/ui/screens/admin/more/more_screen.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _currentIndex = 0;

  void _switchTab(int index) {
    if (index >= 0 && index < 5) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardScreen(onSwitchTab: _switchTab),
          const ResidentsScreen(),
          const BillingScreen(),
          const PqrsScreen(),
          const MoreScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

