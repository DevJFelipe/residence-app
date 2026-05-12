import 'package:flutter/material.dart';
import 'amenities/amenities_screen.dart';
import 'amenities/my_reservations_screen.dart';
import 'package:residence_app/ui/organisms/user_liquid_tab_bar.dart';
import 'package:residence_app/ui/screens/user/home/user_home_screen.dart';
import 'package:residence_app/ui/screens/user/profile/user_profile_screen.dart';
import 'package:residence_app/ui/screens/user/visitors/user_visitors_screen.dart';

class UserShell extends StatefulWidget {
  const UserShell({super.key});

  @override
  State<UserShell> createState() => _UserShellState();
}

class _UserShellState extends State<UserShell> {
  int _currentIndex = 0;

  void _switchTab(int index) {
    if (index >= 0 && index < 5) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          UserHomeScreen(onSwitchTab: _switchTab),
          const AmenitiesScreen(embedded: true),
          const MyReservationsScreen(embedded: true),
          const UserVisitorsScreen(),
          const UserProfileScreen(),
        ],
      ),
      bottomNavigationBar: UserLiquidTabBar(
        currentIndex: _currentIndex,
        onTap: _switchTab,
      ),
    );
  }
}
