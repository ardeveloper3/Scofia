import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scofia/common/controllers/sidemenuecontroller.dart';
import 'package:scofia/common/widgets/infocard.dart';

class SideMenu extends StatelessWidget {
  SideMenu({Key? key}) : super(key: key);

  final SideMenuController controller = Get.put(SideMenuController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/appbackground2.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Container(
              width: 210,
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() => InfoCard(
                          title1: "Last 30 days all Task",
                          title2: "${controller.preferencesData['last30dayslist']}",
                        )),
                        Obx(() => InfoCard(
                          title1: "Today's Task",
                          title2: "${controller.preferencesData['TodaysTask']}",
                        )),
                        Obx(() => InfoCard(
                          title1: "Tomorrow Task",
                          title2: "${controller.preferencesData['TomorrowTask']}",
                        )),
                        Obx(() => InfoCard(
                          title1: "Day After Tomorrows Task",
                          title2: "${controller.preferencesData['DayAfterTomorrowsTask']}",
                        )),
                        Obx(() => InfoCard(
                          title1: "Completed List",
                          title2: "${controller.preferencesData['CompletedList']}",
                        )),
                        Container(
                          height: 70,
                          width: 200,
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.privacy_tip),
                                Text(
                                  "Privacy policy",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(() => TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: controller.value.value),
            duration: Duration(milliseconds: 500),
            builder: (_, double val, __) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..setEntry(0, 3, 200 * val)
                  ..rotateY((pi / 6) * val),
                child: GestureDetector(
                  onTap: () => controller.toggleDrawer(),
                ),
              );
            },
          )),
        ],
      ),
    );
  }
}
