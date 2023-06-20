// import 'package:flutter/material.dart';
// import 'package:po_project/auths/models/view_user_model.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';

// import '../../auths/services/auth_service.dart';
// import '../../mains/constants/colors.dart';
// import '../widgets/save_btn.dart';
// import 'card_sale_profile_page.dart';

// class ProfileSalePage extends StatefulWidget {
//   const ProfileSalePage({super.key, required this.userModel});

//   final UserModel userModel;

//   @override
//   State<ProfileSalePage> createState() => _ProfileSalePageState();
// }

// class _ProfileSalePageState extends State<ProfileSalePage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   late final TextEditingController _nameCtr;
//   late final TextEditingController _emailCtr;
//   late final TextEditingController _phoneCtr;

//   @override
//   void initState() {
//     super.initState();
//     _nameCtr = TextEditingController(text: widget.userModel.data.user?.name);
//     _emailCtr = TextEditingController(text: widget.userModel.data.user?.email);
//     _phoneCtr = TextEditingController(text: widget.userModel.data.user?.phone);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _nameCtr.dispose();
//     _emailCtr.dispose();
//     _phoneCtr.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _buildBody(context),
//     );
//   }

//   Widget _buildBody(BuildContext context) {
//     return SafeArea(
//       child: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               _buildProfile(context),
//               _buildCardSaleProfile(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProfile(BuildContext context) {
//     return Row(
//       children: [
//         IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: const Icon(Icons.arrow_back_ios),
//         ),
//         Container(
//           margin: const EdgeInsets.only(right: 5),
//           child: const Text(
//             'Profile',
//             style: TextStyle(
//                 color: AppColors.textColor,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 22),
//           ),
//         )
//       ],
//     );
//   }

//   Widget _buildCardSaleProfile(BuildContext context) {
//     final avatarUrl = widget.userModel.data.user?.avatarUrl;

//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 1.7.h, vertical: 1.h),
//       width: double.infinity,
//       height: MediaQuery.of(context).size.height * 0.6,
//       decoration: const BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(15)),
//           boxShadow: [
//             BoxShadow(
//               color: Color.fromRGBO(85, 75, 186, 0.14),
//               offset: Offset(
//                 5.0,
//                 5.0,
//               ),
//               blurRadius: 10.0,
//               spreadRadius: 2.0,
//             ),
//             BoxShadow(
//               color: Colors.white,
//               offset: Offset(0.0, 0.0),
//               blurRadius: 0.0,
//               spreadRadius: 0.0,
//             ),
//           ]),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 1.7.h),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 shape: BoxShape.circle,
//                 image: avatarUrl != null
//                     ? DecorationImage(image: NetworkImage(avatarUrl))
//                     : null,
//               ),
//               child: avatarUrl == null
//                   ? Center(
//                       child: Icon(
//                         Icons.person_outline,
//                         size: 30,
//                         color: Colors.grey[600],
//                       ),
//                     )
//                   : null,
//             ),
//             _frmName(),
//             SizedBox(
//               height: 1.5.h,
//             ),
//             _frmEmail(),
//             SizedBox(
//               height: 1.5.h,
//             ),
//             _frmPhoneNumber(),
//             SizedBox(
//               height: 1.5.h,
//             ),
//             _frmSave(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _frmName() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 1.h),
//       child: TextFormField(
//         controller: _nameCtr,
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter name';
//           }
//           return null;
//         },
//         style: TextStyle(
//             color: Colors.grey[600], fontWeight: FontWeight.w400, fontSize: 16),
//         decoration: const InputDecoration(
//           labelText: 'Name',
//           labelStyle: TextStyle(
//             color: Color.fromRGBO(0, 0, 0, 0.87),
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//           ),
//           contentPadding: EdgeInsets.symmetric(vertical: 0),
//         ),
//       ),
//     );
//   }

//   Widget _frmEmail() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 1.h),
//       child: TextFormField(
//         controller: _emailCtr,
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter email';
//           }
//           return null;
//         },
//         style: TextStyle(
//             color: Colors.grey[600], fontWeight: FontWeight.w400, fontSize: 16),
//         decoration: const InputDecoration(
//           labelText: 'Email',
//           labelStyle: TextStyle(
//             color: Color.fromRGBO(0, 0, 0, 0.87),
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//           ),
//           contentPadding: EdgeInsets.symmetric(vertical: 0),
//         ),
//       ),
//     );
//   }

//   Widget _frmPhoneNumber() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 1.h),
//       child: TextFormField(
//         controller: _phoneCtr,
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter phone number';
//           }
//           return null;
//         },
//         style: TextStyle(
//             color: Colors.grey[600], fontWeight: FontWeight.w400, fontSize: 16),
//         decoration: const InputDecoration(
//           labelText: 'Phone Number',
//           labelStyle: TextStyle(
//             color: Color.fromRGBO(0, 0, 0, 0.87),
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//           ),
//           contentPadding: EdgeInsets.symmetric(vertical: 0),
//         ),
//       ),
//     );
//   }

//   Widget _frmSave() {
//     final update = Provider.of<AuthService>(context);
//     return SaveBtn(
//         title: "Save",
//         loading: update.loading,
//         onPress: () {
//           print('Save button pressed...');
//           // if the form is fully validate, then we will process update profile
//           if (_formKey.currentState!.validate()) {
//             // calling api update
//             if (_nameCtr.text.isEmpty) {
//               // Utils.toastMessage('Please enter email', context);
//             } else if (_emailCtr.text.isEmpty) {
//               // Utils.toastMessage('Please enter password', context);
//             } else if (_phoneCtr.text.isEmpty) {
//               // Utils.toastMessage('Please enter 6 digit password', context);
//             } else {
//               Map data = {
//                 'name': _nameCtr.text.toString(),
//                 'email': _emailCtr.text.toString(),
//                 'phone': _phoneCtr.text.toString(),
//               };
//               update.updateProfile(data, context);
//             }
//           }
//         });
//   }
// }
