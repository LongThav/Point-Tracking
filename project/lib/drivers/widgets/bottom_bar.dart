import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:po_project/mains/constants/colors.dart';

class DriverButtomBar extends StatelessWidget {
  const DriverButtomBar({super.key, required this.activeTab});
  final int activeTab;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
      color: AppColors.white,
      child: Center(
        child: GNav(
          onTabChange: (v) {},
          tabBorderRadius: 20,
          color: AppColors.appBarColor,
          activeColor: Colors.white,
          tabBackgroundColor: AppColors.appBarColor,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          tabs: const [
            GButton(
              icon: Icons.home,
              iconSize: 90,
            ),
            GButton(
              icon: Icons.calendar_month,
              iconSize: 90,
            ),
            GButton(
              icon: Icons.settings_outlined,
              iconSize: 90,
            )
          ],
          selectedIndex: activeTab,
        ),
      ),
    );
  }
}
