import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scofia/common/helpers/notification_helper.dart';

import 'package:scofia/common/utils/constants.dart';
import 'package:scofia/common/widgets/CustomTextField.dart';
import 'package:scofia/common/widgets/appstyle.dart';
import 'package:scofia/common/widgets/height_spacer.dart';
import 'package:scofia/common/widgets/reusable_text.dart';
import 'package:scofia/common/widgets/width_spacer.dart';
import 'package:scofia/features/todo/controllers/todo/todo_provider.dart';
import 'package:scofia/features/todo/pages/add.dart';
import 'package:scofia/features/todo/widgets/completed_task.dart';
import 'package:scofia/features/todo/widgets/day_after_tomorrow.dart';
import 'package:scofia/features/todo/widgets/todayTask.dart';
import 'package:scofia/features/todo/widgets/tomorrow_list.dart';
import 'package:timezone/data/latest.dart' as tz;

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage>
    with TickerProviderStateMixin {
  late final TabController tabController =
      TabController(length: 2, vsync: this);

  late NotificationHelper notifierHelper;
  late NotificationHelper controller;

  final TextEditingController search = TextEditingController();

  @override
  void initState() {
    // NotificationService.init();
    tz.initializeTimeZones();
    notifierHelper = NotificationHelper(ref: ref);
    Future.delayed(Duration(seconds: 0),(){
      controller = NotificationHelper(ref: ref);
    });
    notifierHelper.initializeNotification();
    notifierHelper.requestIOSPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(todoStateProvider.notifier).refresh();

    return Scaffold(
      backgroundColor: AppConst.kBkDark,

      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ListView(
          children: [
            HeightSpacer(height: 35.h),
            Row(
              children: [
                Icon(
                  FontAwesome.tasks,
                  size: 20,
                  color: AppConst.kLight,
                ),
                WidthSpacer(width: 10),
                ReusableText(
                    text: "Today's Task",
                    style: appstyle(18, AppConst.kLight, FontWeight.bold)),
              ],
            ),
            HeightSpacer(height: 35),
            Container(
              decoration: BoxDecoration(
                  color: AppConst.kLight,
                  borderRadius:
                      BorderRadius.all(Radius.circular(AppConst.kRadius))),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    color: AppConst.kGreyLight,
                    borderRadius:
                        BorderRadius.all(Radius.circular(AppConst.kRadius))),
                controller: tabController,
                labelPadding: EdgeInsets.zero,
                isScrollable: false,
                labelColor: AppConst.kBlueLight,
                labelStyle: appstyle(12, AppConst.kBlueLight, FontWeight.w700),
                unselectedLabelColor: AppConst.kLight,
                tabs: [
                  Tab(
                    child: SizedBox(
                      width: AppConst.kWidth * 0.5,
                      child: Center(
                        child: ReusableText(
                            text: "Pending",
                            style: appstyle(
                                16, AppConst.kBkDark, FontWeight.bold)),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: EdgeInsets.only(left: 30.w),
                      width: AppConst.kWidth * 0.5,
                      child: Center(
                        child: ReusableText(
                            text: "Completed",
                            style: appstyle(
                                16, AppConst.kBkDark, FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            HeightSpacer(height: 20),
            SizedBox(
              height: AppConst.kHeight * 0.5,
              width: AppConst.kWidth,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(AppConst.kRadius)),
                child: TabBarView(
                  controller: tabController,
                  children: [
                    Container(
                      color: AppConst.kBkLight,
                      height: AppConst.kHeight * 0.3,
                      child: TodayTasks(),
                    ),
                    Container(
                      color: AppConst.kBkLight,
                      height: AppConst.kHeight * 0.3,
                      child:const CompletedTask(),
                    ),
                  ],
                ),
              ),
            ),

          //   HeightSpacer(height: 20),
          //   //TODO this tomorrows hole section
          //   TomorrowList(),
          //
          //   HeightSpacer(height: 20),
          //
          // DayAfta(),

          ],
        ),
      )),
    );
  }
}


