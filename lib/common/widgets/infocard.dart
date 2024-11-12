import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scofia/common/utils/constants.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.title1, required this.title2});
  final String title1;
  final String title2;
  @override
  Widget build(BuildContext context) {
    return   Container(
margin: EdgeInsets.all(5),
width: 200,
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        borderRadius: BorderRadius.circular(30),

      ),
      child: ListTile(
        leading: Icon(Icons.history_edu, color: Colors.white),
        title: Text(
          "$title1: $title2",
          style: TextStyle(color: AppConst.kGreyLight,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
