import 'package:flutter/material.dart';

import '../../../mains/constants/colors.dart';

class BuildFeatured extends StatefulWidget {
  const BuildFeatured({super.key});

  @override
  State<BuildFeatured> createState() => _BuildFeaturedState();
}

class _BuildFeaturedState extends State<BuildFeatured> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // _tabController.animateTo(2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return AppColors.textColor;
              }
              return null;
            },
          ),
          controller: _tabController,
          tabs: const [Text('New'), Text('In Service')],
        ),
        TabBarView(
          controller: _tabController,
          children: const [
            Center(
              child: Text('1'),
            ),
            Center(
              child: Text('2'),
            )
          ],
        ),
      ],
    );
  }
}
