import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todoest/app/core/base/task_controller.dart';
import 'package:todoest/app/core/model/task.dart';
import 'package:todoest/app/core/utils/notif_services.dart';
import 'package:todoest/app/core/values/theme.dart';
import 'package:todoest/app/core/values/theme_services.dart';
import 'package:todoest/app/core/widget/button.dart';
import 'package:todoest/app/core/widget/task_tile.dart';
import 'package:todoest/app/modules/add_tasks/views/add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _taskController = Get.put(TaskController());
  var notifyHelper;
  DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => ThemeServices().switchTheme(),
        backgroundColor: Get.isDarkMode ? Colors.white : Colors.grey[700],
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
          size: 25,
          color: Get.isDarkMode ? Colors.black : Colors.white,
        ),
      ),
      backgroundColor: context.theme.backgroundColor,
      // appBar: _appBar(),
      body: Column(
        children: [
          SizedBox(
            height: size.height * .07,
          ),
          _addTaskBar(),
          _addDateBar(size),
          SizedBox(
            height: size.height * .02,
          ),
          const Divider(
            height: 2,
            color: Colors.grey,
          ),
          SizedBox(
            height: size.height * .02,
          ),
          _showTasks(size),
        ],
      ),
    );
  }

  Container _addDateBar(size) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 15),
      child: DatePicker(
        DateTime.now(),
        height: size.height * .115,
        width: size.height * .09,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: titleStyle,
        dayTextStyle: subTitleStyle,
        monthTextStyle: subTitleStyle,
        onDateChange: (date) {
          _selectedDate = date;
          setState(() {});
        },
      ),
    );
  }

  Container _addTaskBar() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMd().format(DateTime.now()),
                  style: subTitleStyle,
                ),
                Text(
                  'Today',
                  style: headingStyle,
                )
              ],
            ),
          ),
          MyButton(
              label: '+Add Task',
              onTap: () async {
                await Get.to(() => AddTaskPage());
                _taskController.getTasks();
              })
        ],
      ),
    );
  }

  _showTasks(size) {
    return Expanded(child: Obx(() {
      if (_taskController.taskList
          .where((p0) =>
              p0.date == DateFormat.yMd().format(_selectedDate) ||
              p0.repeat == "Daily")
          .isNotEmpty) {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              Task task = _taskController.taskList[index];
              if (task.repeat == "Daily") {
                DateTime date =
                    DateFormat.jm().parse(task.startTime.toString());
                var myTime = DateFormat('HH:mm').format(date);
                print(myTime);

                return AnimationConfiguration.staggeredGrid(
                    position: index,
                    columnCount: 1,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                          child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => _showBottomSheet(context, task),
                            child: TaskTile(task),
                          ),
                        ],
                      )),
                    ));
              } else if (task.date == DateFormat.yMd().format(_selectedDate)) {
                return AnimationConfiguration.staggeredGrid(
                    position: index,
                    columnCount: 1,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                          child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => _showBottomSheet(context, task),
                            child: TaskTile(task),
                          ),
                        ],
                      )),
                    ));
              } else {
                return Container();
              }
            });
      } else {
        return AnimationConfiguration.staggeredGrid(
            position: 1,
            columnCount: 1,
            child: SlideAnimation(
                child: FadeInAnimation(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * .1,
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    size: size.height * size.width * .0003,
                    color: Colors.blue[900],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Nothing to do for today!\n\nCreate new task from "Add Task"\nbutton at the top.',
                    textAlign: TextAlign.center,
                    style: titleStyle,
                  )
                ],
              ),
            )));
      }
    }));
  }

  _showBottomSheet(context, Task task) {
    var size = MediaQuery.of(context).size;
    Get.bottomSheet(Container(
      padding: EdgeInsets.only(top: 4),
      height: task.isCompleted == 1 ? size.height * 0.24 : size.height * 0.32,
      color: Get.isDarkMode ? darkGreyClr : Colors.white,
      child: Column(
        children: [
          Container(
            height: 5,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
          ),
          Spacer(),
          task.isCompleted == 1
              ? Container()
              : _bottomSheetButton(
                  label: 'Task Completed',
                  onTap: () {
                    _taskController.markTaskCompleted(task.id!);
                    Get.back();
                  },
                  clr: primaryClr,
                  context: context),
          _bottomSheetButton(
              label: 'Delete Task',
              onTap: () {
                _taskController.delete(task);
                Get.back();
              },
              clr: Colors.red[300]!,
              context: context),
          SizedBox(
            height: 20,
          ),
          _bottomSheetButton(
              label: 'Close',
              onTap: () {
                Get.back();
              },
              clr: Colors.red[300]!,
              context: context,
              isClose: true),
          SizedBox(
            height: 10,
          )
        ],
      ),
    ));
  }

  _bottomSheetButton(
      {required String label,
      required Function() onTap,
      required Color clr,
      bool isClose = false,
      required BuildContext context}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 3),
        height: 48,
        width: MediaQuery.of(context).size.width * .9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
            child: Text(
          label,
          style:
              isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
        )),
      ),
    );
  }
}
