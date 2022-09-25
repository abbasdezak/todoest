import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:todoest/app/core/values/theme.dart';
class NotiFiedPage extends StatelessWidget {
  const NotiFiedPage({Key? key, required this.label}) : super(key: key);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Get.isDarkMode ? Colors.grey : Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Get.isDarkMode ? Colors.white : Colors.grey,
          ),
        ),
        title: Text(label.toString().split("+")[0], style: biggerTitleStyle),
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          height: 400,
          width: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Get.isDarkMode ? Colors.white : Colors.grey),
          child: Text(label.toString().split("+")[1], style: biggerSubHeadingStyle),
        ),
      ),
    );
  }
}
