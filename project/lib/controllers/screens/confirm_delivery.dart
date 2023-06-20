import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../mains/services/network/api_status.dart';
import '../../controllers/widgets/button_alert.dart';
import '../../mains/constants/colors.dart';
import '../service/po_controller_service.dart';
import '../widgets/alert_dialog.dart';

class ConfirmDelivery extends StatefulWidget {
  final int con_id;
  final String poName;
  final String status;
  final String createBy;
  final String contact;
  final String delivery;
  final String phone;

  const ConfirmDelivery({
    super.key,
    required this.poName,
    required this.status,
    required this.createBy,
    required this.contact,
    required this.delivery,
    required this.phone,
    required this.con_id,
  });

  @override
  State<ConfirmDelivery> createState() => _ConfirmDeliveryState();
}

class _ConfirmDeliveryState extends State<ConfirmDelivery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: -13,
        title: const Text(
          'Delivery Confirm Box',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textColor),
        ),
      ),
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        insetPadding: const EdgeInsets.all(18),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 1.7.h, vertical: 1.h),
          width: MediaQuery.of(context).size.width,
          height: 286.94,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0XFFFFFFFF),
          ),
          child: _buildShowDialogSingle(),
        ),
      ),
    );
  }

  Widget _buildShowDialogSingle() {
    var loadingStatus = context.watch<PoControllerService>().loadingstatus;
    var loading = loadingStatus == Loadingstatus.loading;
    return Column(
      children: [
        SizedBox(height: 1.5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: const Text(
                'Are you sure to confirm ?',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textColor),
              ),
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.clear, color: Color.fromRGBO(70, 70, 70, 1)),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        _buildAlertPro(),
        SizedBox(height: 3.h),
        ButtonAlert(
            loading: loading,
            title: 'Confirm Delivery',
            onPress: () async {
              context.read<PoControllerService>().setLoading();
              await Future.delayed(const Duration(milliseconds: 500), () {});
              if (!mounted) return;
              var status = await context.read<PoControllerService>().confirmDelivery(widget.con_id, context);
              if (status) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Success'),
                  ),
                );
                Navigator.of(context).pop('success 1');
              } else {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed'),
                  ),
                );
              }
            }),
      ],
    );
  }

  Widget _buildAlertPro() {
    return AlertPro(
      id: widget.poName,
      edition: widget.status,
      dateTime: widget.createBy,
      name: widget.contact,
      phone: widget.phone,
      delivery: widget.delivery,
    );
  }
}
