import 'package:flutter/material.dart';

import '../../mains/constants/colors.dart';
import '../../mains/constants/index_colors.dart';

class SelectedFilterByDriver extends StatelessWidget {
  final int selected;
  final Function callBack;
  SelectedFilterByDriver({
    super.key,
    required this.selected,
    required this.callBack,
  });

  final List<String> manuList = ['Delivery', 'Delivered'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: manuList.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.only(right: 15),
              child: GestureDetector(
                onTap: () {
                  callBack(index);
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                  decoration: BoxDecoration(
                    color: selected == -1 ? IndexColors.select : (selected != index ? IndexColors.select : AppColors.textColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    manuList[index],
                    style: const TextStyle(color: AppColors.white),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
