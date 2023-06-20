import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProductList extends StatelessWidget {
  final String productName;
  final String weight;
  final String productDescription;
  final int total;
  final VoidCallback? callback;
  const ProductList({
    super.key,
    required this.productName,
    required this.weight,
    required this.productDescription,
    required this.total,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: EdgeInsets.all(1.h),
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 0.5.h, vertical: 0.5.h),
        // height: 8.3.h, // for height update
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(85, 75, 186, 0.14),
            offset: Offset(
              5.0,
              5.0,
            ),
            blurRadius: 7.0,
            spreadRadius: 2.0,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ),
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Color(0XFF343434)),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  weight,
                  style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Color(0XFF343434)),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  productDescription,
                  style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Color(0XFF979797)),
                ),
              ],
            ),
            Container(
              width: 44.87,
              height: 26.92,
              margin: EdgeInsets.only(right: 1.7.h),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(85, 75, 186, 0.14),
                  offset: Offset(
                    5.0,
                    5.0,
                  ),
                  blurRadius: 7.0,
                  spreadRadius: 2.0,
                ),
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0.0, 0.0),
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                ),
              ]),
              child: Center(
                child: Text(
                  total.toString(),
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Color.fromRGBO(52, 52, 52, 1)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
