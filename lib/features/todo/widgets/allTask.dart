import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scofia/common/models/task_model.dart';
import 'package:scofia/common/utils/constants.dart';
import 'package:scofia/common/widgets/xpansion_tile.dart';
import 'package:scofia/features/todo/controllers/todo/todo_provider.dart';
import 'package:scofia/features/todo/controllers/xpansion_provider.dart';
import 'package:scofia/features/todo/pages/UpdateTask.dart';
import 'package:scofia/features/todo/widgets/todo_tile.dart';

class Alltask extends ConsumerWidget {
  const Alltask({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    List<Task> listData = ref.watch(todoStateProvider);

    List lastMounth = ref.read(todoStateProvider.notifier).last30days();
    var color = ref.read(todoStateProvider.notifier).getRandomColor();

    var completedList = listData.where((element)
    => element.isCompleted == 0 || lastMounth.contains(element.date!.substring(0,10)) ).toList();

    return   XpansionTile(

      text: "All Task",
      text2: "Last 30 day's  tasks ",
      onExpansionChange: (bool expanded) {
        ref.read(xpansionStateProvider.notifier)
            .setStart(!expanded);
      },
      trailing:
      Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: ref.watch(xpansionStateProvider)? Icon(AntDesign.circledown,):
        Icon(AntDesign.closecircleo,),
      ),
      children: [
        for(final todo in completedList)
          TodoTile(
            title: todo.title,
            description: todo.desc,
            color:color ,
            start: todo.startTime,
            end: todo.endTime,
            delete: (){
              ref.read(todoStateProvider.notifier).deleteTodo(todo.id??0);
            },
            editWidget: GestureDetector(
              onTap: (){
                titles = todo.title.toString();
                descs = todo.desc.toString();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateTask(id: todo.id??0,)));
              },
              child: Icon(MaterialCommunityIcons.circle_edit_outline),
            ),

            switcher: const SizedBox.shrink(),
          ),


      ],
    );;
  }
}
