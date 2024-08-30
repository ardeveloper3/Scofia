import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scofia/common/helpers/db_helper.dart';
import 'package:scofia/common/models/task_model.dart';
import 'package:scofia/common/utils/constants.dart';
part 'todo_provider.g.dart';

@riverpod
class TodoState extends _$TodoState {
  @override
  List<Task> build(){
    return [];

  }
  void refresh()async{
   final data = await DBHelper.getItems();

   state = data.map((e) => Task.fromJson(e)).toList();
  }

  void addItem(Task task)async{
    await DBHelper.creatItem(task);
    refresh();
  }

  dynamic getRandomColor(){
    Random random = Random();
    int randomIndex = random.nextInt(colors.length);
    return colors[randomIndex];
  }

  void updateItem(int id, String title, String desc,
      int isCompleted,String date, String startTime ,String endTime)async{
    await DBHelper.updateItem( id,  title,  desc,
         isCompleted, date,  startTime , endTime);
    refresh();
  }


 Future <void> deleteTodo(int id)async{
    await DBHelper.deleteItem(id);
    refresh();
  }


  void MarkAsComplete(int id, String title, String desc,
      int isCompleted,String date, String startTime ,String endTime)async{
    await DBHelper.updateItem( id,  title,  desc,
        1, date,  startTime , endTime);
    refresh();
  }

  //Today
  String getToday(){
    DateTime today = DateTime.now();

    return today.toString().substring(0,10);
  }
  //Tomorrow
  String getTomorrow(){
    DateTime tomorrow = DateTime.now().add(Duration(days: 1));

    return tomorrow.toString().substring(0,10);
  }
  //
  //day after tomorrow
  String getDayAfta(){
    DateTime tomorrow = DateTime.now().add(Duration(days: 2));

    return tomorrow.toString().substring(0,10);
  }

  List<String> last30days(){
    DateTime today = DateTime.now();
    DateTime oneMonthAgo = today.subtract(const Duration(days: 30));
    List<String> dates = [];
    for(int i = 0; i <30; i++){

      DateTime date = oneMonthAgo.add( Duration(days: i));
      dates.add(date.toString().substring(1,10));
    }
    return dates;
  }

  bool getStatus(Task data){

    bool? isCompleted;
    if(data.isCompleted == 0){
      isCompleted = false;
    }else{
      isCompleted =true;
    }
    return isCompleted;
  }

}