import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:flutter_fight_club/pages/statistics_page.dart';
import 'package:flutter_fight_club/widget/fight_result_widget.dart';
import 'package:flutter_fight_club/widget/go_button.dart';
import 'package:flutter_fight_club/pages/fight_page.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/secondary_button.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _MainPageContent();
  }
}


class _MainPageContent extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Center(child: Text("The\nFigh\nClub", textAlign: TextAlign.center, style: TextStyle(fontSize: 30, color: FightClubColors.darkGreyText),)),
            Expanded(child: SizedBox()),
            FutureBuilder <String?>(
                future: SharedPreferences.getInstance().then(
                      (sharedPreferences) => sharedPreferences.getString("last_fight_result"),
                ),
                builder: (context, snaphot) {
                  if (!snaphot.hasData || snaphot.data == null) {
                    return const SizedBox();
                  }
                  final FightResult fightResult = FightResult.getByName(snaphot.data!);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Last fight result", style: TextStyle(color: FightClubColors.darkGreyText, fontSize: 14),),
                      const SizedBox(height: 12),
                      FightResultWidget(fightResult: fightResult),
                    ],
                  );
                },),

            Expanded(child: SizedBox()),
            Secondary_Button(
              text: "Statistics",
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => StatisticsPage(),)
                );
            },),
            const SizedBox(height: 12),
            GoButton(text: "Start".toUpperCase(), onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => FightPage(),
              ));
            }, color: FightClubColors.blackButton),

            const SizedBox(height: 16),

          ],
        ),
      ),
    );

  }
  
}