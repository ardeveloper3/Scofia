
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scofia/common/utils/constants.dart';
import 'package:scofia/common/widgets/xpansion_tile.dart';
import 'package:scofia/features/todo/controllers/todo/todo_provider.dart';
import 'package:scofia/features/todo/controllers/xpansion_provider.dart';
import 'package:scofia/features/todo/pages/UpdateTask.dart';
import 'package:scofia/features/todo/widgets/todo_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class DayAfta extends ConsumerWidget {
  const DayAfta({
    super.key,

  });

  Future<void> saveCompletedListLength(int length) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('DayAfterTomorrowsTask', length);
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final todos = ref.watch(todoStateProvider);
    var color = ref.read(todoStateProvider.notifier).getRandomColor();

    String dayafter = ref.read(todoStateProvider.notifier).getDayAfta();
    var tomorrowsTasks = todos.where((element) => element.date!.contains(dayafter));
    saveCompletedListLength(tomorrowsTasks.length);

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
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    content: SizedBox(
                      height: 200,
                      width: 300,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Centered image
                          Image.asset(
                            'assets/images/deletetask.png',
                            width: 280,
                            height: 130,
                          ),
                          SizedBox(height: 16),
                          // Title text
                          Text(
                            'Do you want to delete this task ?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Close the dialog without making any changes
                          Navigator.of(context).pop();
                        },
                        child: Text('No'),
                      ),
                      TextButton(
                        onPressed: () {

                          ref.read(todoStateProvider.notifier).deleteTodo(todo.id??0);
                          Workmanager().cancelByUniqueName(todo.id.toString());
                          print("${todo.id } this id wise task hase been deleted");

                          Navigator.of(context).pop();
                        },
                        child: Text('yes'),
                      ),
                    ],
                  );
                },
              );
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