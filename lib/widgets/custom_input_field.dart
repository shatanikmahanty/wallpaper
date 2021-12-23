import 'package:flutter/material.dart';
import 'package:wallpaper/configs/color.dart';

buildInputFieldThemeColor(
  String label,
  IconData? icon,
  TextInputType type,
  TextEditingController controller,
  BuildContext context,
  bool isLast,
  FocusNode node,
  FocusNode? nextNode,
  bool isEnabled,
  bool obscure,
  Widget suffix,
  double radius,
  Color fill,
  String? Function(String? value) validator,
) {
  return TextFormField(
    controller: controller,
    textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
    focusNode: node,
    enabled: isEnabled,
    validator: validator,
    obscureText: obscure,
    obscuringCharacter: '*',
    onFieldSubmitted: (s) {
      if (nextNode != null) {
        nextNode.requestFocus();
      } else if (isLast) {
        FocusScope.of(context).unfocus();
      } else {
        FocusScope.of(context).nextFocus();
      }
    },
    autofocus: false,
    style: const TextStyle(
      color: Colors.black,
    ),
    keyboardType: type,
    cursorColor: THEME_COLOR_PURPLE,
    //(Platform.isIOS || Platform.isMacOS) ? null : THEME_COLOR,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black),
      errorMaxLines: 2,
      suffix: suffix,
      prefixIcon: Icon(
        icon,
        size: 18,
        color: Colors.black,
      ),
      filled: true,
      fillColor: fill,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(
          width: 3,
          color: THEME_COLOR_PURPLE,
          style: BorderStyle.solid,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(
          width: 3,
          color: Colors.blue,
          style: BorderStyle.solid,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(
          width: 3,
          color: Colors.blueGrey,
          style: BorderStyle.solid,
        ),
      ),
    ),
  );
}
