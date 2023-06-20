// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';

// import '../../mains/constants/colors.dart';
// import '../models/in_controllers.dart';
// import '../widgets/confirm_stru.dart';
// import 'detail_confirm.dart';

// class BuildCardConfirmController extends StatefulWidget {
//   const BuildCardConfirmController({super.key});

//   @override
//   State<BuildCardConfirmController> createState() =>
//       _BuildCardConfirmControllerState();
// }

// class _BuildCardConfirmControllerState
//     extends State<BuildCardConfirmController> {
//   List<ProController> proControllerCard = [
//     ProController('POID83729', 'Confirm', '26/12/2022', 'name', '85513245679',
//         'City Center Boulevard Phnom Penh', false),
//     ProController('POID83729', 'Confirm', '26/12/2022', 'name', '85513245679',
//         'City Center Boulevard Phnom Penh', false),
//   ];
//   List<ProController> selectedInservice = [];
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       // height: 29.8.h,
//       decoration: BoxDecoration(
//           color: const Color(0XFFF6F6F6),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(width: 1, color: const Color(0XFFB1BFE1))),
//       child: Column(
//         children: [
//           Container(
//             alignment: Alignment.centerLeft,
//             padding: EdgeInsets.symmetric(horizontal: 0.5.h, vertical: 1.5.h),
//             child: const Text(
//               'City Center Boulevard Phnom Penh',
//               style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.textColor),
//             ),
//           ),
//           _buildItemsCard(),
//         ],
//       ),
//     );
//   }

//   Widget _buildItemsCard() {
//     return Column(
//       children: List.generate(proControllerCard.length, (index) {
//         return _buildCardLists(
//             proControllerCard[index].poId,
//             proControllerCard[index].typepro,
//             proControllerCard[index].dateTime,
//             proControllerCard[index].contact,
//             proControllerCard[index].phone,
//             proControllerCard[index].delivery,
//             proControllerCard[index].selected,
//             index);
//       }),
//     );
//   }

//   Widget _buildCardLists(String poId, String typepro, String dateTime,
//       String contact, String phone, String delivery, bool selected, int index) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 0.5.h),
//       child: ConfirmInController(
//           id: poId,
//           edition: typepro,
//           selected: selected,
//           dateTime: dateTime,
//           name: contact,
//           phone: phone,
//           delivery: delivery,
//           details: () {
//             setState(() {
//               proControllerCard[index].selected =
//                   !proControllerCard[index].selected;
//             });
//             Navigator.push(context, MaterialPageRoute(builder: (context) {
//               return DetailInConfirm(
//                 id: proControllerCard[index].poId,
//                 typepro: proControllerCard[index].typepro,
//                 dateTime: proControllerCard[index].dateTime,
//                 contact: proControllerCard[index].contact,
//                 phone: proControllerCard[index].phone,
//                 delivery: proControllerCard[index].delivery,
//               );
//             }));
//           }),
//     );
//   }
// }
