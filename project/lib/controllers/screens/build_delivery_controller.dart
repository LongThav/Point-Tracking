// import 'package:flutter/material.dart';

// import '../models/in_controllers.dart';
// import '../widgets/delivery_stru.dart';
// import 'detail_confirm.dart';

// class BuildDeliveryController extends StatefulWidget {
//   const BuildDeliveryController({super.key});

//   @override
//   State<BuildDeliveryController> createState() =>
//       _BuildDeliveryControllerState();
// }

// class _BuildDeliveryControllerState extends State<BuildDeliveryController> {
//   List<ProController> deliveryController = [
//     ProController('POID83729', 'Delivery', '26/12/2022', 'name', '85513245679',
//         'City Center Boulevard Phnom Penh', false),
//     ProController('POID83729', 'Delivery', '26/12/2022', 'name', '85513245679',
//         'City Center Boulevard Phnom Penh', false),
//   ];
//   List<ProController> selectedInservice = [];
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: List.generate(deliveryController.length, (index) {
//         return DeliveryController(
//             id: deliveryController[index].poId,
//             edition: deliveryController[index].typepro,
//             dateTime: deliveryController[index].dateTime,
//             name: deliveryController[index].contact,
//             phone: deliveryController[index].phone,
//             delivery: deliveryController[index].delivery,
//             details: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) {
//                 return DetailInConfirm(
//                   id: deliveryController[index].poId,
//                   typepro: deliveryController[index].typepro,
//                   dateTime: deliveryController[index].dateTime,
//                   contact: deliveryController[index].contact,
//                   phone: deliveryController[index].phone,
//                   delivery: deliveryController[index].delivery,
//                 );
//               }));
//             });
//       }
//     ),
//     );
//   }
// }
