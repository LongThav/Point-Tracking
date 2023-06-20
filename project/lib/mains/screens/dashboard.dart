import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import '../../mains/constants/colors.dart';

class DaskBoardStructure extends StatelessWidget {
  final String title;
  final String subtitle;
  final String total;

  const DaskBoardStructure({
    super.key,
    required this.title,
    required this.subtitle,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h, top: 1.4.h),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(85, 75, 186, 0.14),
          offset: Offset(
            5.0,
            5.0,
          ),
          blurRadius: 5.0,
          spreadRadius: 5.0,
        ),
        BoxShadow(
          color: Colors.white,
          offset: Offset(0.0, 0.0),
          blurRadius: 0.0,
          spreadRadius: 0.0,
        ),
      ]),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 1.7.h, left: 1.7.h),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Color(0XFF343434),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 1.7.h, top: 0.2.h),
            child: Text(
              subtitle,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Color(0XFF979797),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 1.7.h, top: 0.7.h),
            child: Text(
              total,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 44,
                color: AppColors.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
