import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class General extends StatefulWidget {
  const General(String id, String edition, String price, String dateTime,
      String name, String phone, String delivery,
      {super.key});

  @override
  State<General> createState() => _GeneralState();
}

class _GeneralState extends State<General> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.h),
      width: MediaQuery.of(context).size.width,
      height: 90.h,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(85, 75, 186, 0.14),
              offset: Offset(
                5.0,
                5.0,
              ),
              blurRadius: 5.0,
              spreadRadius: 2.0,
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
            padding: EdgeInsets.only(left: 1.7.h, top: 1.7.h),
            child: const Text(
              'Purchase Order Detail',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h),
            child: Row(
              children: const [
                Text(
                  'ID',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color.fromRGBO(114, 114, 114, 1)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
