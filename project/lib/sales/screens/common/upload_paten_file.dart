import 'package:flutter/material.dart';

import 'package:dotted_border/dotted_border.dart';

class UploadPatenFile extends StatelessWidget {
  const UploadPatenFile({
    Key? key,
    this.title = 'Upload Paten File',
    required this.onTap,
  }) : super(key: key);

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        color: Colors.grey,
        strokeWidth: 3,
        dashPattern: const [10, 5],
        child: Container(
          width: double.infinity,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color.fromRGBO(44, 54, 145, 0.52)),
            ),
          ),
        ),
      ),
    );
  }
}
