import 'package:flutter/material.dart';

import 'package:line_icons/line_icons.dart';

import '../../mains/utils/logger.dart';

class CommonDropDownButton extends StatefulWidget {
  const CommonDropDownButton({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.textLabel,
    required this.hint,
    required this.items,
    this.validator,
  });
  final String? initialValue;
  final void Function(String newValue) onChanged;
  final String? textLabel;
  final String hint;
  final String? Function(dynamic)? validator;
  final List<Map<String, dynamic>> items;

  @override
  State<CommonDropDownButton> createState() => _CommonDropDownButtonState();
}

class _CommonDropDownButtonState extends State<CommonDropDownButton> {
  ///declaration state start
  String? _currentValue;
  List<DropdownMenuItem<Object>> _dropItems = <DropdownMenuItem<Object>>[];

  /// declaration function start
  List<DropdownMenuItem<Object>> _mappedItem(List<Map<String, dynamic>> items) {
    return List.generate(items.length, (index) {
      var value = items[index]['value'];
      var text = items[index]['text'];
      return DropdownMenuItem(
        value: value,
        child: Text(text),
      );
    }).toList();
  }

  void _init() {
    'initialValue: ${widget.initialValue}'.log();
    'total items: ${widget.items.length}'.log();

    var isCurrValid = false;
    if (widget.items.isNotEmpty) {
      /// Rebuild-UI if items selections is not empty
      setState(() {
        _dropItems = _mappedItem(widget.items);
      });

      for (var i = 0; i < widget.items.length; i++) {
        if (widget.initialValue == widget.items[i]['value']) {
          isCurrValid = true;
          break;
        }
      }
    }

    if (isCurrValid) {
      /// Rebuild-UI if initialValue match items selections is not empty
      setState(() {
        _currentValue = widget.initialValue;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.textLabel != null ? Text(widget.textLabel!) : const SizedBox.shrink(),
          DropdownButtonFormField(
            style: const TextStyle(fontSize: 16, color: Colors.black, overflow: TextOverflow.ellipsis),
            isExpanded: true,
            validator: widget.validator,
            focusColor: Colors.transparent,
            value: _currentValue,
            onChanged: (newValue) {
              var valueUpdated = newValue.toString();
              setState(() {
                _currentValue = valueUpdated;
              });
              widget.onChanged(valueUpdated);
            },
            items: _dropItems,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.zero,
              isDense: true,
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            ),
            hint: Text(widget.hint),
            icon: const Icon(LineIcons.angleDown),
          ),
        ],
      ),
    );
  }
}
