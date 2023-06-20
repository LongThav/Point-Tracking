import 'package:flutter/material.dart';

import '../../mains/constants/colors.dart';
import '../../mains/constants/index_colors.dart';

class SelectedFilterByLogistic extends StatefulWidget {
  final int selected;
  final Function callBack;
  const SelectedFilterByLogistic({super.key, required this.selected, required this.callBack});

  @override
  State<SelectedFilterByLogistic> createState() => _SelectedFilterByLogisticState();
}

class _SelectedFilterByLogisticState extends State<SelectedFilterByLogistic> {
  List<String> manuList = ['In service', 'Confirm'];
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
                  widget.callBack(index);
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                  decoration: BoxDecoration(
                    color: widget.selected == index ? AppColors.textColor : IndexColors.select,
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
