import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideMenuController extends GetxController {
  // Observable variables for state management
  var value = 0.0.obs;

  // Map to store retrieved data from SharedPreferences
  var preferencesData = {
    'last30dayslist': 'Loading...',
    'TodaysTask': 'Loading...',
    'TomorrowTask': 'Loading...',
    'DayAfterTomorrowsTask': 'Loading...',
    'CompletedList': 'Loading...',
  }.obs;

  @override
  void onInit() {
    super.onInit();
    loadDataFromSharedPreferences();
  }

  // Function to load multiple pieces of data from SharedPreferences
  Future<void> loadDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    preferencesData['last30dayslist'] = (prefs.getInt('last30dayslist') ?? 0).toString();
    preferencesData['TodaysTask'] = (prefs.getInt('TodaysTask') ?? 0).toString();
    preferencesData['TomorrowTask'] = (prefs.getInt('TomorrowTask') ?? 0).toString();
    preferencesData['DayAfterTomorrowsTask'] = (prefs.getInt('DayAfterTomorrowsTask') ?? 0).toString();
    preferencesData['CompletedList'] = (prefs.getInt('CompletedList') ?? 0).toString();
  }

  // Toggle function for drawer animation
  void toggleDrawer() {
    value.value = value.value == 0 ? 1 : 0;
  }
}
