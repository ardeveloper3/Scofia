import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'dates_provider.g.dart';

@riverpod
class DateState extends _$DateState {
  @override
  String build(){
    return "";

  }
  void setDate(String newState){
    state = newState;
  }
}


@riverpod
class StartTimeState extends _$StartTimeState {
  @override
  String build(){
    return "";

  }
  void setStart(String newState){
    state = newState;
  }
  List<int> dates(DateTime startDate){
    DateTime now = DateTime.now();
    Duration diffrerence = startDate.difference(now);

    int days = diffrerence.inDays;
    int hours = diffrerence.inHours % 24;
    int minutes = diffrerence.inMinutes % 60;
    int seconds = diffrerence.inSeconds % 60;

    return [days,hours,minutes,seconds];

  }
}

@riverpod
class FinishTimeState extends _$FinishTimeState {
  @override
  String build(){
    return "";

  }
  void setStart(String newState){
    state = newState;
  }
}