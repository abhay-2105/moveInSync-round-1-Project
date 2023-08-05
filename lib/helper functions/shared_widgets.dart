import 'package:flutter/material.dart';

import 'helper_functions.dart';

SizedBox verticalGap(double size) {
  return SizedBox(
    height: size,
  );
}

SizedBox horizontalGap(double size) {
  return SizedBox(
    width: size,
  );
}

InputBorder border = const OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0XFF707070),
      width: 1,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(30),
    ));

Widget customTextFeild(
    {String? hintText,
    TextEditingController? controller,
    bool obsecureText = false,
    bool isPassword = false,
    void Function()? onPressed}) {
  return SizedBox(
    height: 60,
    child: TextField(
      controller: controller,
      cursorColor: Colors.black,
      textAlignVertical: TextAlignVertical.center,
      obscureText: obsecureText,
      decoration: InputDecoration(
          border: border,
          focusedBorder: border,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
          hintText: hintText,
          hintStyle: const TextStyle(color: ColorManager.grey),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obsecureText ? Icons.visibility_off : Icons.visibility,
                    color: ColorManager.grey,
                  ),
                  onPressed: onPressed,
                )
              : null),
    ),
  );
}

Widget customButton(String text, void Function()? onPressed,
    {bool isLoading = false}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          disabledBackgroundColor: ColorManager.blue,
          backgroundColor: ColorManager.blue,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 18)),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ))
          : Text(text));
}
