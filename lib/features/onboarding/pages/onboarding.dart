import 'package:flutter/material.dart';
import 'package:scofia/common/utils/constants.dart';

import 'package:scofia/features/todo/pages/HomePage.dart';
import 'package:scofia/features/todo/pages/default_home_page.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  void changeScreen(){
    Future.delayed(Duration(seconds: 2),(){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    changeScreen();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
            height: 275,
            width: 250,
            decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(70)
            ),
            child:Column(
              children: [
                Image.asset("assets/images/provoice.png",fit: BoxFit.cover,),
              ],
            ),

        ),
      )
    );
  }
}
