import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../widgets/save_btn.dart';


class CardSaleProfile extends StatefulWidget {
  const CardSaleProfile({super.key});

  @override
  State<CardSaleProfile> createState() => _CardSaleProfileState();
}

class _CardSaleProfileState extends State<CardSaleProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1.7.h, vertical: 1.h),
      width: double.infinity,
      height: 46.8.h,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(85, 75, 186, 0.14),
              offset: Offset(
                5.0,
                5.0,
              ),
              blurRadius: 10.0,
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
        padding: EdgeInsets.symmetric(horizontal: 1.7.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.person_outline,
                  size: 30,
                  color: Colors.grey[600],
                ),
              ),
            ),
            _frmName(),
            SizedBox(
              height: 1.5.h,
            ),
            _frmEmail(),
            SizedBox(
              height: 1.5.h,
            ),
            _frmPhoneNumber(),
            SizedBox(
              height: 1.5.h,
            ),
            _frmSave(),
          ],
        ),
      ),
    );
  }

  Widget _frmName() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: TextFormField(
        style: TextStyle(
            color: Colors.grey[600], fontWeight: FontWeight.w400, fontSize: 16),
        decoration: const InputDecoration(
          labelText: 'Name',
          labelStyle: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 0.87),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _frmEmail() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: TextFormField(
        style: TextStyle(
            color: Colors.grey[600], fontWeight: FontWeight.w400, fontSize: 16),
        decoration: const InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 0.87),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _frmPhoneNumber() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: TextFormField(
        style: TextStyle(
            color: Colors.grey[600], fontWeight: FontWeight.w400, fontSize: 16),
        decoration: const InputDecoration(
          labelText: 'Phone Number',
          labelStyle: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 0.87),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _frmSave() {
    return SaveBtn(title: "Save", onPress: () {});
  }
}
