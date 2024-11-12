import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:scofia/common/controllers/home_coontroller.dart';
import 'package:scofia/common/utils/constants.dart';
import 'package:scofia/features/todo/pages/HomePage.dart';
import 'package:scofia/features/todo/pages/add.dart';
import 'package:scofia/features/todo/pages/future_task.dart';
import 'package:get/get.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  var controller = Get.put(HomeController());

  static final List<Widget> _screens = [
Homepage(),
FutureTask(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      controller.currentNaIndex.value = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show dialog when back button is pressed
        if (controller.currentNaIndex.value == 0) {
          bool shouldExit = await _showExitPopup(context);
          return shouldExit; // Return true if Yes is pressed, false otherwise
        } else {
          controller.currentNaIndex.value = 0; // Navigate to Home if not already there
          return false; // Prevent back navigation
        }
      },
      child: Container(
        decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/images/taskappfile.png"),fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: _screens[controller.currentNaIndex.value],
          bottomNavigationBar: Container(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      
            decoration: BoxDecoration(
                color: Colors.greenAccent, borderRadius: BorderRadius.circular(15)),
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildNavBarItem(Icons.list_alt, "Today's Task", 0),
                buildNavBarItem(Icons.history_edu, "Future Task", 1),
      
              ],
            ),
          ),
          floatingActionButton: ClipOval(
      
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
      
                    colors: [
                      Color(0xFFFCB0BF),
                        Colors.blue.shade400,
                    ],
      
                )
              ),
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTask()));
                },
                child: SizedBox(
                    width: 70,
                    height: 70,
                    child: Icon(Icons.add,color: AppConst.kLight,size: 40,)
                ),
              ),
            ),
          ),
          //
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }

  Widget buildNavBarItem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: controller.currentNaIndex.value == index ? AppConst.kGreyLight : Colors.white,
          ),
          Text(
            '$label',
            style: TextStyle(
              fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: controller.currentNaIndex.value == index ? AppConst.kGreyLight : Colors.white),
          ),
        ],
      ),
    );
  }


  Future<bool> _showExitPopup(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.pinkAccent,
        title: Text(
          "Do you want to get out from the app",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "If you want please press yes otherwise press cancel",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Stay in the app
            child: Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog first
              SystemNavigator.pop(); // Exit the app
            },
            child: Text("Yes", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ?? false;
  }

}
