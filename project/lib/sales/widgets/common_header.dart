import 'package:flutter/material.dart';

class CommonHeader extends StatelessWidget {
  const CommonHeader({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color.fromRGBO(52, 52, 52, 1),
        ),
      ),
    );
  }
}
