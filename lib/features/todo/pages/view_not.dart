import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scofia/common/utils/constants.dart';
import 'package:scofia/common/widgets/appstyle.dart';
import 'package:scofia/common/widgets/height_spacer.dart';
import 'package:scofia/common/widgets/reusable_text.dart';
import 'package:scofia/common/widgets/width_spacer.dart';

class NotificationViewPage extends StatelessWidget {
  const NotificationViewPage({super.key, this.payload});
  final String? payload;

  @override
  Widget build(BuildContext context) {
    var title = payload!.split('|')[0];
    var desc = payload!.split('|')[1];

    var start = payload!.split('|')[3];
    var end = payload!.split('|')[4];


    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
          child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Container(
              width: AppConst.kWidth,
              height: AppConst.kHeight * 0.7,
              decoration: BoxDecoration(
                color: AppConst.kBkLight,
                borderRadius:
                    BorderRadius.all(Radius.circular(AppConst.kRadius)),
              ),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    ReusableText(
                        text: "Reminder",
                        style: appstyle(40, AppConst.kLight, FontWeight.bold)),

                    HeightSpacer(height: 5),
                    Container(
                      width: AppConst.kWidth,
                      padding: EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                        color: AppConst.kYellow,
                        borderRadius: BorderRadius.all(Radius.circular(9.h))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ReusableText(text: "Today", style: appstyle(16, AppConst.kBkDark, FontWeight.bold)),
                          WidthSpacer(width: 15),
                          
                          ReusableText(
                              text: "From : $start  To : $end",
                              style: appstyle(15, AppConst.kBkDark, FontWeight.bold)),
                        ],
                      ),
                    ),
                    
                    HeightSpacer(height: 10),
                    ReusableText(
                        text: title,
                        style: appstyle(30, AppConst.kBkDark, FontWeight.bold)),
                    HeightSpacer(height: 10),
                    Text(
                    desc,
                        maxLines: 8,
                        textAlign: TextAlign.justify,
                        style: appstyle(16, AppConst.kLight, FontWeight.bold)),

                  ],
                ),
              ),
            ),
          ),
          Positioned(
              right: 8.w,
              top: -40,
              child: Image.asset("assets/images/New Project (1).png",
          width: 140.w,
            height: 140.h,

          ),
          ),

          Positioned(
            bottom: -AppConst.kHeight*0.100,
            left: 0,
            right: 0,
            child: Image.asset("assets/images/New Project (1).png",
              width: AppConst.kWidth*0.8,
              height: AppConst.kHeight*0.6,

            ),
          ),


        ],
      )),
    );
  }
}
