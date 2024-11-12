import 'package:flutter/material.dart';
import 'package:scofia/common/utils/constants.dart';
import 'package:scofia/common/widgets/titles.dart';

class XpansionTile extends StatelessWidget {
  const XpansionTile({super.key, required this.text, required this.text2, this.onExpansionChange, this.trailing, required this.children});
  final String text;
  final String text2;
  final void Function(bool)? onExpansionChange;
  final Widget? trailing;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10,right: 10),
      decoration: BoxDecoration(
      gradient: LinearGradient(
          colors: [
            Colors.pinkAccent,
            Colors.blue,
          ],
        begin: Alignment.centerLeft,
      ),
        borderRadius: BorderRadius.all(Radius.circular(AppConst.kRadius)),

      ),
      child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,

          ),
          child: ExpansionTile(
              title: BottomTitles(
                text: text,
                text2: text2,
              ),
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            onExpansionChanged: onExpansionChange,
            controlAffinity: ListTileControlAffinity.trailing,
            trailing: trailing,
            children: children,
          ),


      ),
    );
  }
}
