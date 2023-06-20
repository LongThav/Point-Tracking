// import 'package:flutter/material.dart';
// import 'package:line_icons/line_icons.dart';
// import 'package:po_project/sales/screens/profile_sale_page.dart';
// import 'package:po_project/mains/utils/route/route_name.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';
// import 'package:ionicons/ionicons.dart';
// import '../../auths/services/auth_service.dart';
// import '../../auths/services/user_local_service.dart';
// import '../../mains/constants/colors.dart';

// class SettingsSalePage extends StatefulWidget {
//   const SettingsSalePage({super.key});

//   @override
//   State<SettingsSalePage> createState() => _SettingsSalePageState();
// }

// class _SettingsSalePageState extends State<SettingsSalePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: _buildBody,
//     );
//   }

//   get _buildBody {
//     return SafeArea(
//         child: Column(
//       children: [
//         Container(
//           alignment: Alignment.centerLeft,
//           padding: EdgeInsets.all(1.7.h),
//           child: const Text(
//             'Setting',
//             style: TextStyle(
//               color: AppColors.appBarColor,
//               fontSize: 22,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//         _buildBoxUserName(),
//         _buildSettingList(),
//         _buildAboutUsList(),
//         _buildLogoutList(),
//       ],
//     ));
//   }

//   Widget _buildBoxUserName() {
//     return GestureDetector(
//       child: Stack(
//         children: [
//           Container(
//             margin: EdgeInsets.only(right: 1.7.h, left: 1.7.h, top: 8.h),
//             width: MediaQuery.of(context).size.width,
//             height: 144,
//             decoration: const BoxDecoration(
//                 color: AppColors.background,
//                 borderRadius: BorderRadius.all(Radius.circular(16)),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Color.fromRGBO(54, 41, 183, 0.18),
//                     offset: Offset(
//                       1.0,
//                       5.0,
//                     ),
//                     blurRadius: 10.0,
//                     spreadRadius: 2.0,
//                   )
//                 ]),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: const [
//                   Text(
//                     'UserName',
//                     style: TextStyle(
//                         color: AppColors.textColor,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 24,
//                         fontFamily: 'Poppins_Bold_lite'),
//                   ),
//                   Text(
//                     'example@email.com',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 16,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//               left: 18.h,
//               top: 1.8.h,
//               child: Container(
//                 width: 89.65,
//                 height: 89.65,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.grey[300],
//                 ),
//                 child: Center(
//                   child: Icon(
//                     Icons.person_outline,
//                     size: 30,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               )),
//           Positioned(
//               right: 1.9.h,
//               top: 15.h,
//               child: const Icon(
//                 Icons.arrow_forward_ios,
//                 color: AppColors.textColor,
//               )),
//         ],
//       ),
//       onTap: () {
//         Navigator.of(context).push(PageRouteBuilder(
//             transitionDuration: const Duration(milliseconds: 200),
//             reverseTransitionDuration: const Duration(milliseconds: 300),
//             pageBuilder: (context, animation, secondaryAnimation) {
//               return const ProfileSalePage();
//             }));
//       },
//     );
//   }

//   Widget _buildSettingList() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 1.7.h, vertical: 3.h),
//       child: Row(
//         children: [
//           const Icon(
//             Icons.settings_outlined,
//             size: 28,
//             color: AppColors.textColor,
//           ),
//           SizedBox(
//             width: 1.7.h,
//           ),
//           const Text(
//             'Settings',
//             style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: AppColors.textColor),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildAboutUsList() {
//     return Container(
//       margin: EdgeInsets.symmetric(
//         horizontal: 1.7.h,
//       ),
//       child: Row(
//         children: [
//           const Icon(
//             LineIcons.questionCircle,
//             size: 28,
//             color: AppColors.textColor,
//           ),
//           SizedBox(
//             width: 1.7.h,
//           ),
//           const Text(
//             'About Us',
//             style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: AppColors.textColor),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildLogoutList() {
//     // final userPrefernece = Provider.of<UserLocalService>(context);
//     return GestureDetector(
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 2.2.h, vertical: 2.9.h),
//         child: Row(
//           children: [
//             const Icon(
//               Ionicons.log_out_outline,
//               size: 28,
//               color: AppColors.textColor,
//             ),
//             SizedBox(
//               width: 1.7.h,
//             ),
//             const Text(
//               'Logout',
//               style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: AppColors.textColor),
//             )
//           ],
//         ),
//       ),
//       onTap: () {
//         // Provider.of<AuthService>(context, listen: false).logout(context);
//         // userPrefernece.removeUser().then((value) {
//         //   Navigator.pushNamed(context, RouteName.signin);
//         // });
//         print('LOGOUT...');
//         Provider.of<AuthService>(context, listen: false).logOut(context);
//         // print(Provider.of<AuthService>(context, listen: false).logOut(context));
//       },
//     );
//   }
// }
