import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RoundButton extends StatelessWidget {

  final String title ;
  final bool loading ;
  final VoidCallback onPress ;
  const RoundButton({Key? key ,
    required this.title,
    this.loading = false ,
     required this.onPress ,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        margin:  EdgeInsets.symmetric(horizontal: 2.h, vertical: 28),
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromRGBO(67, 110, 220, 1),
                Color.fromRGBO(44, 54, 145, 1),
              ]),
        ),
        child: Center(
          child: loading? const CircularProgressIndicator(color:  Colors.white,)
          :Text(title,
          style: const TextStyle(
                color: Color(0XFFFFFFFF),
                fontWeight: FontWeight.w500,
                fontSize: 20),
          ),
        ),
      ),
    );
  }
}
