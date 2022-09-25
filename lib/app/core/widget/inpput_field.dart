import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoest/app/core/values/theme.dart';
class MyInputField extends StatelessWidget {
  const MyInputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget})
      : super(key: key);
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: titleStyle,
            ),
            Container(
              padding: const EdgeInsets.only(left: 12),
              height: 52,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
              Expanded(
                child: TextFormField(
                  readOnly: widget != null ? true : false,
                  autofocus: false,
                  cursorColor:
                      Get.isDarkMode ? Colors.grey[100] : Colors.grey[400],
                  controller: controller,
                  style: subTitleStyle,
                  decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subTitleStyle,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: context.theme.backgroundColor,
                              width: 0))),
                ),
              ),
              widget == null
                  ? Container()
                  : Container(
                      child: widget,
                    )
                ],
              ),
            )
          ],
        ));
  }
}
