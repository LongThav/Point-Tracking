import 'package:flutter/material.dart';

import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:ionicons/ionicons.dart';

import '../../auths/models/view_user_model.dart';
import '../../mains/services/network/api_status.dart';
import '../../mains/utils/logger.dart';
import '../../auths/services/auth_service.dart';
import '../../auths/services/user_local_service.dart';
import '../../mains/constants/colors.dart';
import '../utils/route/route_name.dart';
import 'profile_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  UserModel? _userModel;

  void _init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<UserLocalService>().setLoading();
      var results = await context.read<UserLocalService>().getUser();
      _userModel = results[0];
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _getBody,
    );
  }

  Widget get _getBody {
    var loadingStatus = context.watch<UserLocalService>().loadingStatus;
    if (loadingStatus == Loadingstatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SafeArea(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(1.7.h),
            child: const Text(
              'Setting',
              style: TextStyle(
                color: AppColors.appBarColor,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildBoxUserName(),
          _buildSettingList(),
          _buildAboutUsList(),
          _buildLogoutList(),
        ],
      ),
    );
  }

  Widget _buildBoxUserName() {
    var user = _userModel?.data.user;
    if (user == null) {
      return const Text('There was an error');
    }
    var avatarUrl = user.avatarUrl;
    return GestureDetector(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(right: 1.7.h, left: 1.7.h, top: 8.h),
            width: MediaQuery.of(context).size.width,
            height: 144,
            decoration: const BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.all(Radius.circular(16)), boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(54, 41, 183, 0.18),
                offset: Offset(
                  1.0,
                  5.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              )
            ]),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    user.name ?? '',
                    style: const TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500, fontSize: 24, fontFamily: 'Poppins_Bold_lite'),
                  ),
                  Text(
                    user.email ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 0.h,
            child: Container(
              width: 89.65,
              height: 89.65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
                image: avatarUrl != null ? DecorationImage(image: NetworkImage(avatarUrl)) : null,
              ),
              child: user.avatarUrl == null
                  ? Center(
                      child: Icon(
                        Icons.person_outline,
                        size: 30,
                        color: Colors.grey[600],
                      ),
                    )
                  : null,
            ),
          ),
          Positioned(
            right: 1.9.h,
            top: 15.h,
            child: const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textColor,
            ),
          ),
        ],
      ),
      onTap: () async {
        await Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 200),
            reverseTransitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) {
              return ProfilePage(userModel: _userModel!);
            },
          ),
        );
        if (!mounted) return;
        var results = await context.read<UserLocalService>().getUser();
        _userModel = results[0];
      },
    );
  }

  Widget _buildSettingList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1.7.h, vertical: 3.h),
      child: Row(
        children: [
          const Icon(
            Icons.settings_outlined,
            size: 28,
            color: AppColors.textColor,
          ),
          SizedBox(
            width: 1.7.h,
          ),
          const Text(
            'Settings',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textColor),
          )
        ],
      ),
    );
  }

  Widget _buildAboutUsList() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 1.7.h,
      ),
      child: Row(
        children: [
          const Icon(
            LineIcons.questionCircle,
            size: 28,
            color: AppColors.textColor,
          ),
          SizedBox(
            width: 1.7.h,
          ),
          const Text(
            'About Us',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textColor),
          )
        ],
      ),
    );
  }

  Widget _buildLogoutList() {
    final Loadingstatus loadingstatus = context.watch<AuthService>().loadingstatus;
    if (loadingstatus == Loadingstatus.loading) {
      return const CircularProgressIndicator();
    }

    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.2.h, vertical: 2.9.h),
        child: Row(
          children: [
            const Icon(
              Ionicons.log_out_outline,
              size: 28,
              color: AppColors.textColor,
            ),
            SizedBox(
              width: 1.7.h,
            ),
            const Text(
              'Logout',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textColor),
            )
          ],
        ),
      ),
      onTap: () async {
        'LOGOUT start...'.log();
        context.read<AuthService>().loadingStatus();
        await Future.delayed(const Duration(milliseconds: 500), () {});
        if (!mounted) return;
        final bool result = await Provider.of<AuthService>(context, listen: false).logOut(context);
        if (!mounted) return;
        if (result) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Success logout'),
            ),
          );
          await Navigator.of(context).pushNamedAndRemoveUntil(RouteName.signin, (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('logout fail'),
            ),
          );
        }
      },
    );
  }
}
