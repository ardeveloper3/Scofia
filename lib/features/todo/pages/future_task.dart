import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scofia/common/widgets/height_spacer.dart';
import 'package:scofia/features/todo/widgets/allTask.dart';
import 'package:scofia/features/todo/widgets/day_after_tomorrow.dart';
import 'package:scofia/features/todo/widgets/tomorrow_list.dart';

class FutureTask extends ConsumerStatefulWidget {
  const FutureTask({super.key});

  @override
  ConsumerState<FutureTask> createState() => _FutureTaskState();
}

class _FutureTaskState extends ConsumerState<FutureTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/taskappfile.png"),fit: BoxFit.cover)
        ),
        child: ListView(
          children: [
            HeightSpacer(height:20),
            //TODO this tomorrows hole section
            TomorrowList(),
        
            HeightSpacer(height: 20),
        
            DayAfta(),
        
            HeightSpacer(height: 20),
        
            Alltask(),
          ],
        ),
      ),
    );
  }
}
