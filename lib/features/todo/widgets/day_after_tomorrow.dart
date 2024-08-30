
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scofia/common/utils/constants.dart';
import 'package:scofia/common/widgets/xpansion_tile.dart';
import 'package:scofia/features/todo/controllers/todo/todo_provider.dart';
import 'package:scofia/features/todo/controllers/xpansion_provider.dart';
import 'package:scofia/features/todo/pages/UpdateTask.dart';
import 'package:scofia/features/todo/widgets/todo_tile.dart';

class DayAfta extends ConsumerWidget {
  const DayAfta({
    super.key,

  });

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final todos = ref.watch(todoStateProvider);
    var color = ref.read(todoStateProvider.notifier).getRandomColor();

    String dayafter = ref.read(todoStateProvider.notifier).getDayAfta();
    var tomorrowsTasks = todos.where((element) => element.date!.contains(dayafter));
    return XpansionTile(

      text: DateTime.now()
          .add(Duration(days: 2))
          .toString()
          .substring(5, 10),
      text2: "Day After tomorrow  tasks ",
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
        for(final todo in tomorrowsTasks)
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
    );
  }
}