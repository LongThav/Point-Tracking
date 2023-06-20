import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../mains/constants/colors.dart';

class ProgressSale extends StatelessWidget {
  final String poStatus;
  final String poDateTime;
  final String poHandleBY;
  const ProgressSale({super.key, required this.poStatus, required this.poDateTime, required this.poHandleBY});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 0.2.h,
            horizontal: 1.h,
          ),
          width: double.infinity,
          height: 22.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(85, 75, 186, 0.14),
                  offset: Offset(
                    5.0,
                    5.0,
                  ),
                  blurRadius: 6.0,
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
                padding: EdgeInsets.only(
                    left: 1.7.h, right: 1.7.h, top: 2.h, bottom: 0.6.h),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Status History',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 1.7.h),
                width: double.infinity,
                height: 7.8.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(85, 75, 186, 0.14),
                        offset: Offset(
                          0.5,
                          3.0,
                        ),
                        blurRadius: 6.0,
                        spreadRadius: 2.0,
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      ),
                    ]),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.7.h, vertical: 1.h),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          Text(
                            poStatus,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: AppColors.textColor),
                          ),
                          Text(
                            poDateTime,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color.fromRGBO(52, 52, 52, 1)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 0.3.h,
                      ),
                      Expanded(
                        child: Row(
                          children:  [
                           const Text(
                              'Handled by ',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0XFF979797),
                              ),
                            ),
                            Text(
                              poHandleBY,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: AppColors.textColor),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
             
            ],
          ),
        ),
      ],
    );
  }
}
