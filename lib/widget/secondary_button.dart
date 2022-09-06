import 'package:flutter/material.dart';

import '../resources/fight_club_colors.dart';

class Secondary_Button extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const Secondary_Button({
    Key? key,
    required this.text,
    required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: FightClubColors.darkGreyText, width: 2),
          ),
          margin: EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: Text(text.toUpperCase(), style: TextStyle(
              fontSize: 13,
              color: FightClubColors.darkGreyText,
              fontWeight: FontWeight.w400),),
        ),
    );
  }
}

