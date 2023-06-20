import 'package:flutter/material.dart';

class CommonBlockRow extends StatelessWidget {
  const CommonBlockRow({
    Key? key,
    required this.rowText,
    required this.rowValue,
  }) : super(key: key);
  final String rowText;
  final String rowValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          rowText,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color.fromRGBO(114, 114, 114, 1),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            rowValue,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color.fromRGBO(70, 70, 70, 1),
            ),
          ),
        ),
      ],
    );
  }
}
