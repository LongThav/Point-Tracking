import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../mains/constants/colors.dart';

class ProgressController extends StatefulWidget {
  const ProgressController({super.key});

  @override
  State<ProgressController> createState() => _ProgressControllertate();
}

class _ProgressControllertate extends State<ProgressController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 1.5.h),
          margin: EdgeInsets.symmetric(
            vertical: 0.2.h,
            horizontal: 1.h,
          ),
          width: double.infinity,
          // height: 29.5.h,
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
                // height: 6.8.h,
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
                        children: const [
                          Text(
                            'New',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: AppColors.textColor),
                          ),
                          Text(
                            '26/12/2022 10:10',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color.fromRGBO(52, 52, 52, 1)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 0.3.h,
                      ),
                      Row(
                        children: const [
                          Text(
                            'Handled by ',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Color(0XFF979797),
                            ),
                          ),
                          Text(
                            'Staff_ID_1',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColors.textColor),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 1.7.h),
                width: double.infinity,
                // height: 6.8.h,
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
                        children: const [
                          Text(
                            'New',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: AppColors.textColor),
                          ),
                          Text(
                            '26/12/2022 10:10',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color.fromRGBO(52, 52, 52, 1)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 0.3.h,
                      ),
                      Row(
                        children: const [
                          Text(
                            'Handled by ',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Color(0XFF979797),
                            ),
                          ),
                          Text(
                            'Staff_ID_1',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColors.textColor),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 1.7.h),
                width: double.infinity,
                // height: 6.8.h,
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
                        children: const [
                          Text(
                            'New',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: AppColors.textColor),
                          ),
                          Text(
                            '26/12/2022 10:10',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color.fromRGBO(52, 52, 52, 1)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 0.3.h,
                      ),
                      Row(
                        children: const [
                          Text(
                            'Handled by ',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Color(0XFF979797),
                            ),
                          ),
                          Text(
                            'Staff_ID_1',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColors.textColor),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
