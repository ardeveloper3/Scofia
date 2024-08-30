import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scofia/common/helpers/notification_helper.dart';
import 'package:scofia/common/helpers/notify.dart';
import 'package:scofia/common/models/task_model.dart';
import 'package:scofia/common/utils/constants.dart';
import 'package:scofia/common/widgets/CustomTextField.dart';
import 'package:scofia/common/widgets/appstyle.dart';
import 'package:scofia/common/widgets/common_otn_btn.dart';
import 'package:scofia/common/widgets/height_spacer.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
as picker;
import 'package:scofia/common/widgets/showDialog.dart';
import 'package:scofia/features/todo/controllers/dates/dates_provider.dart';
import 'package:scofia/features/todo/controllers/todo/todo_provider.dart';
import 'package:scofia/features/todo/pages/HomePage.dart';
import 'package:scofia/features/todo/pages/default_home_page.dart';
import 'package:timezone/data/latest.dart' as tz;
class AddTask extends ConsumerStatefulWidget {
  const AddTask({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTaskState();
}

class _AddTaskState extends ConsumerState<AddTask> {

  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textEditingController = TextEditingController();

  speak(String text,int days,int hours,int minutes,int seconds){
    Future.delayed(Duration(days: days,hours: hours,minutes: minutes,seconds: seconds),()async{
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1);//0.5 to 1.5
      await flutterTts.speak(text);
      await flutterTts.setSpeechRate(0.3);

    });

    // await flutterTts.setLanguage("en-US");
    // await flutterTts.setPitch(1.4);//0.5 to 1.5
    // await flutterTts.speak(text);
  }

  final TextEditingController title = TextEditingController();
  final TextEditingController desc = TextEditingController();
  List<int> notification = [];
  late NotificationHelper notifierHelper;
  late NotificationHelper controller;


  initializeNoti()async{
    await NotificationService.init();
    tz.initializeTimeZones();
  }



  @override
  void initState() {
    initializeNoti();
    // TODO: implement initState
    notifierHelper = NotificationHelper(ref: ref);
    Future.delayed(Duration(seconds: 0),(){
      controller = NotificationHelper(ref: ref);
    });
    notifierHelper.initializeNotification();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var sceduleDate = ref.watch(dateStateProvider);
    var start = ref.watch(startTimeStateProvider);
    var finish = ref.watch(finishTimeStateProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ListView(
        children: [
          HeightSpacer(height: 20),
          CustomTextField(
              keyboardType:TextInputType.text ,
              hintText: "Add title",
              controller: title,
            hintstyle: appstyle(16, AppConst.kGreyLight, FontWeight.bold),
          ),

          HeightSpacer(height: 20),
          CustomTextField(
            keyboardType:TextInputType.text ,
            hintText: "Add description",
            controller: desc,
            hintstyle: appstyle(16, AppConst.kGreyLight, FontWeight.w600),
          ),

          HeightSpacer(height: 20),

          CommonOtnBtn(
            onTap: (){
              picker.DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime(2024, 3, 5),
                  maxTime: DateTime(2120, 6, 7),
                  theme: picker.DatePickerTheme(
                    
                      doneStyle:
                      TextStyle(color: AppConst.kGreen, fontSize: 16)),
                 onConfirm: (date) {
              ref.read(dateStateProvider.notifier).setDate(date.toString());
                  }, currentTime: DateTime.now(), locale: picker.LocaleType.en);
            },
              width: AppConst.kWidth,
              height: 120.h,
              color: AppConst.kLight,
              text:sceduleDate == "" ? " Set Date":sceduleDate.substring(0,10),
            color2: AppConst.kBlueLight,
          ),

          HeightSpacer(height: 20),


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonOtnBtn(
                onTap: (){
                  picker.DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                     onConfirm: (date) {
                    ref.read(startTimeStateProvider.notifier).setStart(date.toString());
                    notification = ref.read(startTimeStateProvider.notifier).dates(date);
                      }, locale: picker.LocaleType.en);


                },
                width: AppConst.kWidth*0.4,
                height: 120.h,
                color: AppConst.kLight,
                text:start == "" ? "Start Time":start.substring(10,16),
                color2: AppConst.kBlueLight,
              ),

              CommonOtnBtn(
                onTap: (){
                  picker.DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      onConfirm: (date) {
                        ref.read(finishTimeStateProvider.notifier).setStart(date.toString());
                      }, locale: picker.LocaleType.en);


                },
                width: AppConst.kWidth*0.4,
                height: 120.h,
                color: AppConst.kLight,
                text:finish == "" ? "End  Time":finish.substring(10,16),
                color2: AppConst.kBlueLight,
              ),


            ],
          ),

          HeightSpacer(height: 20),

          CommonOtnBtn(
            onTap: (){
              if(
              title.text.isNotEmpty&&
              desc.text.isNotEmpty&&
              sceduleDate.isNotEmpty&&
              start.isNotEmpty&&
              finish.isNotEmpty
              ){
                Task task = Task(
                  title: title.text,
                  desc: desc.text,
                  isCompleted: 0,
                  date: sceduleDate,
                  startTime: start.substring(10,16),
                  endTime:finish.substring(10,16),
                  remind: 0,
                  repeat: "yes",

                );
                DateTime SceduleDate = DateTime.now().add(const Duration(seconds: 5));

                NotificationService.scheduleNotification("Scedule Notification", "this is Scedule notification", SceduleDate);

                notifierHelper.scheduleNotification(
                    notification[0],
                    notification[1],
                    notification[2],
                    notification[3],
                    task);

                speak(
                  "${task.desc.toString()}|${"if you complete your task please tap to view notification and confirm that task is completed "}",
                  notification[0],
                  notification[1],
                  notification[2],
                  notification[3],
                );



                ref.read(todoStateProvider.notifier).addItem(task);

                ref.read(finishTimeStateProvider.notifier).setStart('');

                ref.read(startTimeStateProvider.notifier).setStart('');

                ref.read(dateStateProvider.notifier).setDate('');

            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));

              }else{
            showAlertDialog(context: context, message: "Failed to add task");
              }
            },
            width: AppConst.kWidth,
            height: 52.h,
            color: AppConst.kLight,
            text: "Submit ",
            color2: AppConst.kGreen,
          ),



        ],
      ),
      ),
    );
  }
}
