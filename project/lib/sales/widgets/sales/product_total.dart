import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../mains/constants/colors.dart';
import '../../../mains/constants/index_colors.dart';

class POCARTTotal extends StatelessWidget {
  final String bag;
  final String weight;
  final int pricebag;
  final int count;
  final VoidCallback increment;
  final VoidCallback decrement;
  final bool isSelected;
  const POCARTTotal({
    super.key,
    required this.bag,
    required this.pricebag,
    required this.weight,
    required this.increment,
    required this.isSelected,
    required this.count,
    required this.decrement,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: 1.h,
          ),
          Container(
            padding: EdgeInsets.only(left: 1.h, right: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isSelected
                    ? Container(
                        width: 19.93,
                        height: 20,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2, color: const Color(0XFF979797)),
                            shape: BoxShape.circle,
                            color: AppColors.textColor),
                      )
                    : Container(
                        width: 19.93,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2, color: const Color(0XFF979797)),
                          shape: BoxShape.circle,
                        ),
                      ),
                Container(
                  padding: EdgeInsets.only(right: 3.h),
                  child: Text(
                    bag,
                    style: const TextStyle(
                        color: IndexColors.boldName,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 0.3.h),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 1.5.h, vertical: 0.2.h),
                        decoration: const BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(164, 156, 197, 0.25),
                            offset: Offset(
                              3.0,
                              3.0,
                            ),
                            blurRadius: 5.0,
                            spreadRadius: 0.0,
                          ),
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ),
                        ]),
                        child: GestureDetector(
                          onTap: decrement,
                          child: const Text(
                            '-',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 24),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 0.7.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.5.h, vertical: 0.6.h),
                        decoration: const BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(164, 156, 197, 0.25),
                            offset: Offset(
                              3.0,
                              3.0,
                            ),
                            blurRadius: 5.0,
                            spreadRadius: 0.0,
                          ),
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ),
                        ]),
                        child: Text(
                          count.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 1.5.h, vertical: 0.2.h),
                        decoration: const BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(164, 156, 197, 0.25),
                            offset: Offset(
                              3.0,
                              3.0,
                            ),
                            blurRadius: 5.0,
                            spreadRadius: 0.0,
                          ),
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ),
                        ]),
                        child: GestureDetector(
                          onTap: increment,
                          child: const Text(
                            '+',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 1.h),
              child: const Text(
                'Price',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
              )),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 1.h, top: 0.4.h),
              child: Text(
                '\$ $pricebag',
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color.fromRGBO(0, 0, 0, 0.87),
                ),
              )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 1.h, vertical: 0.5.h),
            padding: EdgeInsets.only(left: 1.h, right: 1.h),
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: const Color.fromRGBO(0, 0, 0, 0.87),
          ),
        ],
      ),
    );
  }
}
