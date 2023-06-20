import 'package:flutter/material.dart';

import '../../mains/constants/colors.dart';
import 'card_controller_page.dart';

class ProfileControllerPage extends StatefulWidget {
  const ProfileControllerPage({super.key});

  @override
  State<ProfileControllerPage> createState() => _ProfileControllerPageState();
}

class _ProfileControllerPageState extends State<ProfileControllerPage> {
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
          const CardControllerProfile(),
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
