import 'package:flutter/material.dart';

class CommonTextFormField extends StatelessWidget {
  const CommonTextFormField({
    Key? key,
    this.ctr,
    this.text,
    this.isRequired = false,
    this.readOnly = false,
    this.onTap,
    this.validator,
    this.keyboardType,
    required this.hintText,
    this.focusNode,
    this.onFieldSubmitted,
    this.textInputAction,
    this.obscuringCharacter = ' ',
    this.obSecureText = false,
    this.suffixIcon,
    this.focusBorder,
    this.initialValue,
  }) : super(key: key);

  final String? text;
  final bool isRequired;
  final TextEditingController? ctr;
  final bool readOnly;
  final VoidCallback? onTap;
  final String hintText;
  final String? Function(String? value)? validator;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final String obscuringCharacter;
  final bool obSecureText;
  final Widget? suffixIcon;
  final InputBorder? focusBorder;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text == null
            ? const SizedBox.shrink()
            : RichText(
                text: TextSpan(
                    text: text,
                    style: const TextStyle(color: Colors.black),
                    children: !isRequired
                        ? null
                        : [
                            const TextSpan(
                              text: ' *',
                              style: TextStyle(color: Colors.red),
                            ),
                          ]),
              ),
        TextFormField(
          initialValue: initialValue,
          obscureText: obSecureText,
          obscuringCharacter: obscuringCharacter,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          focusNode: focusNode,
          controller: ctr,
          style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w400, fontSize: 16),
          readOnly: readOnly,
          onTap: onTap,
          validator: validator,
          keyboardType: keyboardType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            focusedBorder: focusBorder,
            hintText: hintText,
            labelStyle: const TextStyle(
              color: Color.fromRGBO(0, 0, 0, 0.87),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
