import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scofia/common/utils/constants.dart';
import 'package:scofia/common/widgets/CustomTextField.dart';
import 'package:scofia/common/widgets/appstyle.dart';
import 'package:scofia/common/widgets/common_otn_btn.dart';
import 'package:scofia/common/widgets/height_spacer.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:scofia/features/todo/controllers/dates/dates_provider.dart';
import 'package:scofia/features/todo/controllers/todo/todo_provider.dart';

class UpdateTask extends ConsumerStatefulWidget {
  const UpdateTask({required this.id, super.key});

  final int id;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTaskState();
}

class _AddTaskState extends ConsumerState<UpdateTask> {
  final TextEditingController title = TextEditingController(text: titles);
  final TextEditingController desc = TextEditingController(text: descs);

  @override
  Widget build(BuildContext context) {
    var sceduleDate = ref.watch(dateStateProvider);
    var start = ref.watch(startTimeStateProvider);
    var finish = ref.watch(finishTimeStateProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/appbackground2.jpg"),fit: BoxFit.cover)
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
                }, icon: Icon(Icons.arrow_back_ios,
            color: Colors.white,size: 30,
            )),
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
                height: 52.h,
                color: AppConst.kLight,
                text: sceduleDate == ""
                    ? " Set Date"
                    : sceduleDate.substring(0, 10),
                color2: AppConst.kBlueLight,
              ),
              HeightSpacer(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonOtnBtn(
                    onTap: () {
                      picker.DatePicker.showDateTimePicker(context,
                          showTitleActions: true, onConfirm: (date) {
                        ref
                            .read(startTimeStateProvider.notifier)
                            .setStart(date.toString());
                      }, locale: picker.LocaleType.en);
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
                          showTitleActions: true, onConfirm: (date) {
                        ref
                            .read(finishTimeStateProvider.notifier)
                            .setStart(date.toString());
                      }, locale: picker.LocaleType.en);
                    },
                    width: AppConst.kWidth * 0.4,
                    height: 52.h,
                    color: AppConst.kLight,
                    text: finish == "" ? "Start Time" : finish.substring(10, 16),
                    color2: AppConst.kBlueLight,
                  ),
                ],
              ),
              HeightSpacer(height: 20),
              CommonOtnBtn(
                onTap: () {
                  if (title.text.isNotEmpty &&
                      desc.text.isNotEmpty &&
                      sceduleDate.isNotEmpty &&
                      start.isNotEmpty &&
                      finish.isNotEmpty) {

                    ref.read(todoStateProvider.notifier).updateItem(
                        widget.id,
                        title.text,
                        desc.text,
                        0,
                        sceduleDate,
                        start.substring(10, 16),
                        finish.substring(10, 16));

                    ref.read(finishTimeStateProvider.notifier).setStart('');

                    ref.read(startTimeStateProvider.notifier).setStart('');

                    ref.read(dateStateProvider.notifier).setDate('');

                    Navigator.pop(context);
                  } else {
                    print("faild to add task");
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
      ),
    );
  }
}
