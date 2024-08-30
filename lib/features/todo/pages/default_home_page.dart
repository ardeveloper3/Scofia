import 'package:flutter/material.dart';
import 'package:scofia/common/utils/constants.dart';
import 'package:scofia/features/todo/pages/HomePage.dart';
import 'package:scofia/features/todo/pages/add.dart';
import 'package:scofia/features/todo/pages/future_task.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
Homepage(),
FutureTask(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
            color: AppConst.kGreyLight, borderRadius: BorderRadius.circular(15)),
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

        child: Material(

          color: AppConst.kLight,
          elevation: 10,
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTask()));
            },
            child: SizedBox(
                width: 70,
                height: 70,
                child: Icon(Icons.add,color: AppConst.kBkDark,size: 40,)
            ),
          ),
        ),
      ),
      //     .onTap((){
      //   // Get.to(()=>QrscannerPage());
      // }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
            color: _selectedIndex == index ? Colors.blue : Colors.white,
          ),
          Text(
            '$label',
            style: TextStyle(
                color: _selectedIndex == index ? Colors.blue : Colors.white),
          ),
        ],
      ),
    );
  }
}
