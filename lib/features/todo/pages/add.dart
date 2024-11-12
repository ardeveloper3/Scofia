
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scofia/common/helpers/notification_helper.dart';
import 'package:scofia/common/models/task_model.dart';
import 'package:scofia/common/utils/constants.dart';
import 'package:scofia/common/widgets/CustomTextField.dart';
import 'package:scofia/common/widgets/appstyle.dart';
import 'package:scofia/common/widgets/common_otn_btn.dart';
import 'package:scofia/common/widgets/height_spacer.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import 'package:scofia/common/widgets/showDialog.dart';
import 'package:scofia/features/todo/controllers/dates/dates_provider.dart';
import 'package:scofia/features/todo/controllers/todo/todo_provider.dart';

import 'package:scofia/features/todo/pages/default_home_page.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../../common/helpers/background_task_manager.dart';
import 'package:workmanager/workmanager.dart';

class AddTask extends ConsumerStatefulWidget {
  const AddTask({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTaskState();
}

class _AddTaskState extends ConsumerState<AddTask> {
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController title = TextEditingController();
  final TextEditingController desc = TextEditingController();
  bool isReapeat = false;

  List<int> notification = [];

  Future<int> getAndIncrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    int currentCount = prefs.getInt('taskid') ?? 123; // Start at 123 if not set
    prefs.setInt('taskid', currentCount + 1); // Increment and save
    return currentCount; // Return the previous count as the ID
  }


  @override
  void initState() {

    super.initState();
    // initializeNoti();
    NotificationHelper.instance.initializeNotification(context);

  }

  // Generate and store the UUID for each user
  Future<String> getOrCreateUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null) {
      userId = const Uuid().v4(); // Generate a new UUID
      await prefs.setString('userId', userId); // Save it
    }

    return userId; // Return the existing or new UUID
  }


  // Function to send task to Firestore with UUID and device token

  @override
  Widget build(BuildContext context) {
    var scheduleDate = ref.watch(dateStateProvider);
    var start = ref.watch(startTimeStateProvider);
    var finish = ref.watch(finishTimeStateProvider);

    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/appbackground2.jpg"),fit: BoxFit.cover
          )
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ListView(
            children: [

              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                    onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,size: 40,)),
              ),

              HeightSpacer(height: 20),


              CustomTextField(
                keyboardType: TextInputType.text,
                hintText: "Add title",
                controller: title,
                hintstyle: appstyle(16, AppConst.kGreyLight, FontWeight.bold),
              ),
              HeightSpacer(height: 20),
              CustomTextField(
                keyboardType: TextInputType.text,
                hintText: "Add description",
                controller: desc,
                hintstyle: appstyle(16, AppConst.kGreyLight, FontWeight.w600),
              ),
              HeightSpacer(height: 20),
              CommonOtnBtn(

                onTap: () {
                  picker.DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime.now(),
                    maxTime: DateTime(2120, 6, 7),
                    theme: picker.DatePickerTheme(
                      doneStyle: TextStyle(color: AppConst.kGreen, fontSize: 16),
                    ),
                    onConfirm: (date) {
                      ref.read(dateStateProvider.notifier).setDate(date.toString());
                    },
                    currentTime: DateTime.now(),
                    locale: picker.LocaleType.en,
                  );
                },
                width: AppConst.kWidth,
                height: 52.h,
                color: AppConst.kLight,
                text: scheduleDate == "" ? "Set Date" : scheduleDate.substring(0, 10),
                color2: AppConst.kBlueLight,
              ),
              HeightSpacer(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonOtnBtn(
                    onTap: () {
                      picker.DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        onConfirm: (date) {
                          ref.read(startTimeStateProvider.notifier).setStart(date.toString());
                          notification = ref.read(startTimeStateProvider.notifier).dates(date);
                        },
                        locale: picker.LocaleType.en,
                      );
                    },
                    width: AppConst.kWidth * 0.4,
                    height: 52.h,
                    color: AppConst.kLight,
                    text: start == "" ? "Start Time" : start.substring(10, 16),
                    color2: AppConst.kBlueLight,
                  ),
                  CommonOtnBtn(
                    onTap: () {
                      picker.DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        onConfirm: (date) {
                          ref.read(finishTimeStateProvider.notifier).setStart(date.toString());
                        },
                        locale: picker.LocaleType.en,
                      );
                    },
                    width: AppConst.kWidth * 0.4,
                    height: 52.h,
                    color: AppConst.kLight,
                    text: finish == "" ? "End Time" : finish.substring(10, 16),
                    color2: AppConst.kBlueLight,
                  ),
                ],
              ),

              //here give a checkbox
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Transform.scale(
                      scale: 1.5, // Adjust this value to change the size
                      child: Theme(
                        data: ThemeData(
                          checkboxTheme: CheckboxThemeData(
                            side: BorderSide(
                              color: Colors.white, // Default border color (inactive)
                              width: 2, // Border width
                            ),
                            checkColor: MaterialStateProperty.all(Colors.black), // Checkmark color
                          ),
                        ),
                        child: Checkbox(
                          value: isReapeat,
                          onChanged: (value) {
                            setState(() {
                              isReapeat = value ?? false;
                            });
                          },
                        ),
                      ),
                    ),

                    Expanded(
                      child: Text("If you wants to do this task everyday click this check box please",style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                      ),),
                    )
                  ],
                ),
              ),

              HeightSpacer(height: 20),
              CommonOtnBtn(
                onTap: () async {
                  int taskId = await getAndIncrementCounter(); // Get unique task ID
                  // Validate all required fields
                  if (title.text.isNotEmpty &&
                      desc.text.isNotEmpty &&
                      scheduleDate.isNotEmpty &&
                      start.isNotEmpty &&
                      finish.isNotEmpty) {
                    Task task = Task(
                      id: taskId,
                      title: title.text,
                      desc: desc.text,
                      isCompleted: 0,
                      date: scheduleDate,
                      startTime: start.substring(10, 16),
                      endTime: finish.substring(10, 16),
                      remind: 0,
                      repeat:isReapeat == true ? "yes": "No",
                    );


                    // Send task to Firestore

                    // await sendTaskToFirestore(task);

                      scheduleOneTimeNotificationTask(
                        id: task.id ?? 0,
                      days: notification[0],
                      hours: notification[1],
                      minutes:notification[2],
                      seconds: notification[3],
                      title: task.title.toString(),
                      desc: task.desc.toString(),
                      notificationData: [
                        task.repeat.toString(),
                        task.startTime.toString(),
                        task.endTime.toString()
                      ],
                    );
                      print("${ task.id}");
                      print(task.repeat);

                    // Clear fields and navigate back to HomeScreen
                    ref.read(todoStateProvider.notifier).addItem(task);
                    ref.read(finishTimeStateProvider.notifier).setStart('');
                    ref.read(startTimeStateProvider.notifier).setStart('');
                    ref.read(dateStateProvider.notifier).setDate('');

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  } else {
                    showAlertDialog(context: context, message: "Please fill in all fields.");
                  }
                },
                width: AppConst.kWidth,
                height: 52.h,
                color: AppConst.kLight,
                text: "Submit",
                color2: AppConst.kGreen,
              ),
              HeightSpacer(height: 10),
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text("Add will here ",style: TextStyle(
                    color: AppConst.kBkDark
                  ),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
