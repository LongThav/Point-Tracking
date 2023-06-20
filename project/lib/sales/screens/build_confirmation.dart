import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../sales/screens/common/view_paten_file.dart';
import '../../sales/service/customer_service.dart';
import '../../sales/widgets/common_header.dart';

class BuildConfirmation extends StatefulWidget {
  const BuildConfirmation({
    super.key,
    required this.customerName,
    required this.customerPhoneNumber,
    required this.customerEmail,
    required this.deliveryPhoneNumber,
    required this.deliveryName,
    required this.deliveryEmail,
    required this.paymentMethod,
    required this.location,
    required this.poNumber,
    required this.patenBase64Str,
  });
  final String customerName;
  final String customerPhoneNumber;
  final String customerEmail;
  final String deliveryPhoneNumber;
  final String deliveryName;
  final String deliveryEmail;
  final String paymentMethod;
  final String location;
  final String poNumber;
  final String patenBase64Str;

  @override
  State<BuildConfirmation> createState() => _BuildConfirmationState();
}

class _BuildConfirmationState extends State<BuildConfirmation> {
  late final TextEditingController _noteCtr;

  /// note text field controller

  @override
  void initState() {
    super.initState();
    _noteCtr = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _noteCtr.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildNote(),
        SizedBox(height: 3.h),
        const CommonHeader(title: 'Customer'),
        SizedBox(height: 1.5.h),
        _buildCustomerName(),
        SizedBox(height: 1.h),
        _buildPhoneNumber(),
        SizedBox(height: 1.h),
        _buildEmail(widget.customerEmail),
        SizedBox(height: 3.h),
        const CommonHeader(title: 'Order Information'),
        SizedBox(height: 1.5.h),
        _buildOp(),
        SizedBox(height: 1.h),
        _buildPayment(),
        SizedBox(height: 1.h),
        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            'OP Reference',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color.fromRGBO(114, 114, 114, 1),
            ),
          ),
        ),
        SizedBox(height: 1.h),
        ViewPatenFile(
          title: 'View PO Reference',
          isAsset: true,
          patenName: context.read<CustomerService>().patenName,
          patenBytes: context.read<CustomerService>().patenBytes,
        ),
        SizedBox(height: 3.h),
        const CommonHeader(title: 'Delivery Information'),
        SizedBox(height: 1.5.h),
        _buildContact(),
        SizedBox(height: 1.h),
        _buildPhone(),
        SizedBox(height: 1.h),
        _buildEmail(widget.deliveryEmail),
        SizedBox(height: 1.h),
        _buildNoted(),
        SizedBox(height: 1.h),
        _buildLocation(),
        SizedBox(height: 1.h),
        _buildShowPinLocation(),
      ],
    );
  }

  Widget _buildNote() {
    return TextFormField(
      controller: _noteCtr,
      onFieldSubmitted: (newValue) {
        FocusScope.of(context).unfocus();
        _noteCtr.text = newValue;
      },
      // onTapOutside: (event) {
      //   FocusScope.of(context).unfocus();
      //   context.read<CustomerService>().setCustomerNote(_noteCtr.text);
      // },
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        label: Text('Note'),
        labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      ),
    );
  }

  Widget _buildCustomerName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Customer Name',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color.fromRGBO(114, 114, 114, 1),
          ),
        ),
        Text(
          widget.customerName.isNotEmpty ? widget.customerName.substring(0, widget.customerName.indexOf('|')) : '',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color.fromRGBO(70, 70, 70, 1),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumber() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Phone Number',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color.fromRGBO(114, 114, 114, 1),
          ),
        ),
        Text(
          widget.customerPhoneNumber.isNotEmpty ? widget.customerPhoneNumber.substring(0, widget.customerPhoneNumber.indexOf('|')) : '',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color.fromRGBO(70, 70, 70, 1),
          ),
        ),
      ],
    );
  }

  Widget _buildEmail(String email) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Email',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color.fromRGBO(114, 114, 114, 1),
          ),
        ),
        Text(
          email,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color.fromRGBO(70, 70, 70, 1),
          ),
        ),
      ],
    );
  }

  Widget _buildOp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'OP Number',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color.fromRGBO(114, 114, 114, 1),
          ),
        ),
        Text(
          widget.poNumber,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color.fromRGBO(70, 70, 70, 1),
          ),
        ),
      ],
    );
  }

  Widget _buildPayment() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color.fromRGBO(114, 114, 114, 1),
          ),
        ),
        Text(
          widget.paymentMethod.isNotEmpty ? widget.paymentMethod.substring(0, widget.paymentMethod.indexOf('|')) : '',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color.fromRGBO(70, 70, 70, 1),
          ),
        ),
      ],
    );
  }

  // Widget _buildViewPO() {
  //   return Container(
  //     width: double.infinity,
  //     height: 37,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(6),
  //       color: const Color.fromRGBO(166, 191, 255, 1),
  //     ),
  //     child: const Center(
  //       child: Text(
  //         'View PO Reference',
  //         style: TextStyle(
  //           fontWeight: FontWeight.w500,
  //           fontSize: 15,
  //           color: Color.fromRGBO(255, 255, 255, 1),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildContact() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Contact',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color.fromRGBO(114, 114, 114, 1),
          ),
        ),
        Text(
          widget.deliveryName,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color.fromRGBO(70, 70, 70, 1),
          ),
        ),
      ],
    );
  }

  Widget _buildPhone() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Phone',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color.fromRGBO(114, 114, 114, 1),
          ),
        ),
        Text(
          widget.deliveryPhoneNumber.isNotEmpty ? widget.deliveryPhoneNumber.substring(0, widget.deliveryPhoneNumber.indexOf('|')) : '',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color.fromRGBO(70, 70, 70, 1),
          ),
        ),
      ],
    );
  }

  Widget _buildNoted() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Note',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color.fromRGBO(114, 114, 114, 1),
          ),
        ),
        Text(
          _noteCtr.text,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color.fromRGBO(70, 70, 70, 1),
          ),
        ),
      ],
    );
  }

  Widget _buildLocation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Location',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color.fromRGBO(114, 114, 114, 1),
          ),
        ),
        Text(
          widget.location.isNotEmpty ? widget.location.substring(0, widget.location.indexOf('|')) : '',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color.fromRGBO(70, 70, 70, 1),
          ),
        ),
      ],
    );
  }

  Widget _buildShowPinLocation() {
    return Container(
      width: double.infinity,
      height: 37,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: const Color.fromRGBO(89, 133, 245, 1),
      ),
      child: const Center(
        child: Text(
          'Show Pinned Location',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
      ),
    );
  }
}
