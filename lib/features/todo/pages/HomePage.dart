import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:scofia/common/utils/constants.dart';

import 'package:scofia/common/widgets/appstyle.dart';
import 'package:scofia/common/widgets/height_spacer.dart';
import 'package:scofia/common/widgets/reusable_text.dart';
import 'package:scofia/common/widgets/width_spacer.dart';
import 'package:scofia/features/todo/controllers/todo/todo_provider.dart';

import 'package:scofia/features/todo/widgets/completed_task.dart';
import 'package:scofia/features/todo/widgets/todayTask.dart';
import 'package:timezone/data/latest.dart' as tz;


// Import your SideMenu widget
import 'package:scofia/features/todo/pages/side_menu.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage>
    with TickerProviderStateMixin {
  late final TabController tabController = TabController(length: 2, vsync: this);



  final TextEditingController search = TextEditingController();

  int _totalNotification = 0;


  double value = 0;

  @override
  void initState() {
    tz.initializeTimeZones();
    super.initState();
  }

  Map payload = {};

  @override
  Widget build(BuildContext context) {
    ref.watch(todoStateProvider.notifier).refresh();

    return Scaffold(
      body: Stack(
        children: [
          // SideMenu background with the animation
          SideMenu(),
          // Main content with the animated transformation
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: value),
            duration: Duration(milliseconds: 500),
            builder: (_, double val, __) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..setEntry(0, 3, 200 * val)
                  ..rotateY((pi / 6) * val),
                child: GestureDetector(
                  onTap: () {
                    if (value == 1) {
                      setState(() {
                        value = 0;
                      });
                    }
                  },
                  child: _buildMainContent(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/taskappfile.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: ListView(
        children: [
          HeightSpacer(height: 20.h),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    value == 0 ? value = 1 : value = 0;
                  });
                },
                icon: Icon(
                  FontAwesome.tasks,
                  size: 30,
                  color: AppConst.kLight,
                ),
              ),
              WidthSpacer(width: 20),
              ReusableText(
                text: "Today's Task",
                style: appstyle(18, AppConst.kLight, FontWeight.bold),
              ),
            ],
          ),
          HeightSpacer(height: 35),
          Container(
            decoration: BoxDecoration(
              color: AppConst.kLight,
              borderRadius: BorderRadius.all(Radius.circular(AppConst.kRadius)),
            ),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.all(Radius.circular(AppConst.kRadius)),
              ),
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
                        style: appstyle(16, AppConst.kBkDark, FontWeight.bold),
                      ),
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
                        style: appstyle(16, AppConst.kBkDark, FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          HeightSpacer(height: 20),
          Container(
            padding: EdgeInsets.only(top: 10),
            height: AppConst.kHeight * 0.5,
            width: AppConst.kWidth,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(AppConst.kRadius)),
              child: TabBarView(
                controller: tabController,
                children: [
                  Container(
                    color: AppConst.kLight,
                    height: AppConst.kHeight * 0.3,
                    child: TodayTasks(),
                  ),
                  Container(
                    color: AppConst.kLight,
                    height: AppConst.kHeight * 0.3,
                    child: const CompletedTask(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
