import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import '../../../mains/constants/colors.dart';
import 'create_customer_profile.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // _tabController.animateTo(2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      body: _buildBody,
    );
  }

  get _buildAppBar {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 30,
          color: AppColors.textColor,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text(
        "Create Customer",
        style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w600, fontSize: 22),
      ),
      titleSpacing: 0,
      bottom: _buildTabBar,
    );
  }

  get _buildTabBar {
    return TabBar(
        splashBorderRadius: BorderRadius.circular(12),
        splashFactory: NoSplash.splashFactory,
        overlayColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          // Use the default focused overlay color
          return states.contains(MaterialState.focused) ? null : Colors.transparent;
        }),
        mouseCursor: null,
        indicator: null,
        // overlayColor: null,
        unselectedLabelColor: null,
        indicatorColor: AppColors.textColor,
        indicatorWeight: 2.0,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 15),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.textColor,
        labelPadding: EdgeInsets.only(bottom: 1.7.h),
        automaticIndicatorColorAdjustment: false,
        controller: _tabController,
        onTap: (index) {
          setState(() {
            _tabController.index = 0;
          });
        },
        tabs: const [
          Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          Text(
            'Contact',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          Text(
            'Location',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          )
        ]);
  }

  get _buildBody {
    return TabBarView(
      controller: _tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        CreateCustomerProfile(),
        Center(
          child: Text('2'),
        ),
        Center(
          child: Text('3'),
        ),
      ],
    );
  }
}
