import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scofia/common/models/task_model.dart';
import 'package:scofia/common/utils/constants.dart';
import 'package:scofia/features/todo/controllers/todo/todo_provider.dart';
import 'package:scofia/features/todo/widgets/todo_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class CompletedTask extends ConsumerWidget {
  const CompletedTask({
    super.key,
  });

  Future<void> saveCompletedListLength(int length) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('CompletedList', length);
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    List<Task> listData = ref.watch(todoStateProvider);

    List lastMounth = ref.read(todoStateProvider.notifier).last30days();
    var completedList = listData.where((element)
    => element.isCompleted == 1 || lastMounth.contains(element.date!.substring(0,10)) ).toList();
    saveCompletedListLength(completedList.length);

  if(completedList.isEmpty){
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
          Text("No completed task yet!",style: TextStyle(fontSize: 30,color: AppConst.kBkDark),)
        ],
      ),
    );
  }
    return ListView.builder(
      itemCount:completedList.length ,
      itemBuilder: (context , index){
        final data = completedList[index];

        dynamic color = ref.read(todoStateProvider.notifier).getRandomColor();

        return  TodoTile(
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

                        ref.read(todoStateProvider.notifier).deleteTodo(data.id??0);
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
          editWidget: SizedBox.shrink(),
          title: data.title,
          color: color,
          description: data.desc,
          start: data.startTime,
          end: data.endTime,
          switcher: Icon(AntDesign.checkcircle,color: AppConst.kGreen,),

        );
      },);
  }
}
