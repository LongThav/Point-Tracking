import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PersonList extends StatelessWidget {
  final String name;
  final String number;
  final String? email;
  final String? image;
  final VoidCallback detials;

  const PersonList({
    super.key,
    required this.name,
    required this.number,
    required this.detials,
    required this.image,
    this.email,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: detials,
      child: Container(
        margin: EdgeInsets.only(top: 1.h, left: 15, right: 15),
        width: MediaQuery.of(context).size.width,
        height: 70,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: const [
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
          children: [
            image != null
                ? Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.7.h),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueGrey[300],
                      image: DecorationImage(image: CachedNetworkImageProvider(image!), fit: BoxFit.fill),
                    ),
                  )
                : const Text('No photo'),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // margin: EdgeInsets.only(
                  //   top: 1.7.h,
                  // ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                ),
                number == ''
                    ? const SizedBox.shrink()
                    : Container(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                              text: number,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: email != null ? ' / $email' : '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black, overflow: TextOverflow.ellipsis),
                                ),
                              ]),
                        ),
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
