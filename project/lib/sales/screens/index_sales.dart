import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:po_project/mains/constants/colors.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';


import '../../mains/utils/index_type_users.dart';

class IndexSales extends StatefulWidget {
  const IndexSales({super.key});

  @override
  State<IndexSales> createState() => _IndexSalesState();
}

class _IndexSalesState extends State<IndexSales> {
  int indexPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: salePages[indexPage],
      bottomNavigationBar: _buildBottom,
    );
  }

  get _buildBottom {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
      color: AppColors.white,
      child: Center(
        child: GNav(
            onTabChange: (v) {
              setState(() {
                indexPage = v;
              });
            },
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
                icon: BootstrapIcons.boxes,
                iconSize: 70,
              ),
              GButton(
                icon: Icons.calendar_month,
                iconSize: 90,
              ),
              GButton(
                icon: Icons.person,
                iconSize: 90,
              ),
              GButton(
                icon: Icons.settings_outlined,
                iconSize: 90,
              )
            ]),
      ),
    );
  }
}
