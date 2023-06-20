import 'package:flutter/material.dart';

import '../../mains/constants/colors.dart';
import 'card_profile_driver_page.dart';

class ProfileDriverPage extends StatefulWidget {
  const ProfileDriverPage({super.key});

  @override
  State<ProfileDriverPage> createState() => _ProfileDriverPageState();
}

class _ProfileDriverPageState extends State<ProfileDriverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody,
    );
  }

  get _buildBody {
    return SafeArea(
      child: Column(
        children: [
          _buildProfile(),
          const CardDriverProfile(),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        Container(
          margin: const EdgeInsets.only(right: 5),
          child: const Text(
            'Profile',
            style: TextStyle(
                color: AppColors.textColor,
                fontWeight: FontWeight.w600,
                fontSize: 22),
          ),
        )
      ],
    );
  }
}
