import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scofia/common/models/task_model.dart';
import 'package:scofia/common/utils/constants.dart';
import 'package:scofia/features/todo/controllers/todo/todo_provider.dart';
import 'package:scofia/features/todo/pages/UpdateTask.dart';
import 'package:scofia/features/todo/widgets/todo_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class TodayTasks extends ConsumerWidget {
  const TodayTasks({
    super.key,
  });
  // Function to save the length of completedList in SharedPreferences
  Future<void> saveCompletedListLength(int length) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('TodaysTask', length);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Task> listData = ref.watch(todoStateProvider);

    String today = ref.read(todoStateProvider.notifier).getToday();
    var todayList = listData.where((element) =>
    element.isCompleted == 0 && element.date!.contains(today)).toList();

    saveCompletedListLength(todayList.length);

    if (todayList.isEmpty) {
      // Show image when there are no tasks
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/taskfile.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text("please add a task ",style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 30,
              fontWeight: FontWeight.bold,),)
          ],
        ),
      );
    }

    // Show list of tasks if todayList is not empty
    return ListView.builder(
      itemCount: todayList.length,
      itemBuilder: (context, index) {
        final data = todayList[index];
        bool isCompleted = ref.read(todoStateProvider.notifier).getStatus(data);

        dynamic color = ref.read(todoStateProvider.notifier).getRandomColor();

        return TodoTile(
          delete: () {
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

                        ref.read(todoStateProvider.notifier).deleteTodo(data.id ?? 0);
                        Workmanager().cancelByUniqueName(data.id.toString());
                        print("${data.id } this id wise task hase been deleted");

                        Navigator.of(context).pop();
                      },
                      child: Text('yes'),
                    ),
                  ],
                );
              },
            );
          },
          editWidget: GestureDetector(
            onTap: () {
              titles = data.title.toString();
              descs = data.desc.toString();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateTask(id: data.id ?? 0),
                ),
              );
            },
            child: Icon(MaterialCommunityIcons.circle_edit_outline),
          ),
          title: data.title,
          color: color,
          description: data.desc,
          start: data.startTime,
          end: data.endTime,
          switcher: Column(
            children: [
              Checkbox(
                value: isCompleted,
                onChanged: (value) {
                  // Show confirmation dialog when checkbox is checked
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
                                'assets/images/greatjob.png',
                                width: 280,
                                height: 130,
                              ),
                              SizedBox(height: 16),
                              // Title text
                              Text(
                                'Great YOU HAVE COMPLETED YOUR TASK',
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
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Mark the task as complete and close the dialog
                              ref.read(todoStateProvider.notifier).MarkAsComplete(
                                data.id ?? 0,
                                data.title.toString(),
                                data.desc.toString(),
                                1,
                                data.date.toString(),
                                data.startTime.toString(),
                                data.endTime.toString(),
                              );
                              Navigator.of(context).pop();
                            },
                            child: Text('Confirm'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              Text("completed",style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),)
            ],
          ),

        );
      },
    );
  }

}
