// import 'package:flutter/material.dart';

// import '../../controllers/screens/detail_confirm.dart';
// import '../../controllers/widgets/confirm_stru.dart';
// import '../models/in_controllers.dart';

// class BuildConfirmInController extends StatefulWidget {
//   const BuildConfirmInController({super.key});

//   @override
//   State<BuildConfirmInController> createState() => _BuildConfirmInControllerState();
// }

// class _BuildConfirmInControllerState extends State<BuildConfirmInController> {
//   List<ProController> proController = [
//     ProController('POID83729', 'Confirm', '26/12/2022', 'name', '85513245679', 'City Center Boulevard Phnom Penh', false),
//     ProController('POID83729', 'Confirm', '26/12/2022', 'name', '85513245679', 'City Center Boulevard Phnom Penh', false),
//   ];
//   List<ProController> selectedInservice = [];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: List.generate(proController.length, (index) {
//         return _buildShowList(proController[index].poId, proController[index].typepro, proController[index].dateTime, proController[index].contact, proController[index].phone,
//             proController[index].delivery, proController[index].selected, index);
//       }),
//     );
//   }

//   Widget _buildShowList(String poId, String typepro, String dateTime, String contact, String phone, String delivery, bool selected, int index) {
//     return ConfirmInController(
//         id: poId,
//         edition: typepro,
//         selected: selected,
//         dateTime: dateTime,
//         name: contact,
//         phone: phone,
//         delivery: delivery,
//         details: () {
//           setState(() {
//             proController[index].selected = !proController[index].selected;
//           });
//           Navigator.push(context, MaterialPageRoute(builder: (context) {
//             return DetailInConfirm(
//               id: proController[index].poId,
//               typepro: proController[index].typepro,
//               dateTime: proController[index].dateTime,
//               contact: proController[index].contact,
//               phone: proController[index].phone,
//               delivery: proController[index].delivery,
//             );
//           }));
//         });
//   }
// }
