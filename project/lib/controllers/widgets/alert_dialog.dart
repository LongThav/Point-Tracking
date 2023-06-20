import 'package:flutter/material.dart';
import 'package:po_project/mains/constants/colors.dart';
import 'package:sizer/sizer.dart';

class AlertPro extends StatelessWidget {
  final String id;
  final String edition;
  final String dateTime;
  final String name;
  final String phone;
  final String delivery;
  final VoidCallback? details;

  const AlertPro(
      {super.key,
      required this.id,
      required this.edition,
      required this.dateTime,
      required this.name,
      required this.phone,
      required this.delivery,
       this.details});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: details,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: const EdgeInsets.only(bottom: 14),
        width: MediaQuery.of(context).size.width,
        // height: 93,
        // height: 10.5.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(85, 75, 186, 0.14),
                offset: Offset(
                  0.0,
                  0.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 10.0,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          id,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        )),
                    const SizedBox(
                      width: 16,
                    ),
                    Container(
                      // padding: const EdgeInsets.all(6),
                      // width: 39,
                      // height: 20,
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: AppColors.textColor),
                      child: Center(
                        child: Text(
                          edition,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 0.1.h),
                alignment: Alignment.centerLeft,
                child: Text(
                  dateTime,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(123, 123, 123, 1)),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      "Contact: ",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(123, 123, 123, 1)),
                    ),
                    SizedBox(
                      width: 1.h,
                    ),
                    Text(
                      name,
                      style: const TextStyle(
                          color: AppColors.textColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Phone: ",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(123, 123, 123, 1)),
                    ),
                    SizedBox(
                      width: 2.h,
                    ),
                    Text(
                      phone,
                      style: const TextStyle(
                          color: AppColors.textColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 0.2.h,
            ),
            Row(
              children: [
                Row(
                  children: [
                    const Text(
                      "Delivery: ",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(123, 123, 123, 1)),
                    ),
                    SizedBox(
                      width: 1.h,
                    ),
                    Text(
                      delivery,
                      style: const TextStyle(
                          color: Color.fromRGBO(123, 123, 123, 1),
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}