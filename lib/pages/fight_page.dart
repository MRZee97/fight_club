import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/resources/fight_club_icons.dart';
import 'package:flutter_fight_club/resources/fight_club_images.dart';
import 'package:flutter_fight_club/widget/go_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FightPage extends StatefulWidget {
  const FightPage({Key? key}) : super(key: key);

  @override
  State<FightPage> createState() => FightPageState();
}

class FightPageState extends State<FightPage> {
  static const maxLives = 5;

  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;

  BodyPart whatEnemyAttacks = BodyPart.random();
  BodyPart whatEnemyDefends  = BodyPart.random();

  int yourLives = maxLives;
  int enemysLives = maxLives;
  String centerText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Fightersinfo(maxLivesCount: maxLives, yourLivesCount: yourLives, enemyLivesCount: enemysLives,),
            const SizedBox(height: 30),
            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ColoredBox(color: Color(0xFFC5D1EA), child: SizedBox(width: double.infinity,
                child: Center(
                  child: Text(
                    centerText,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: FightClubColors.darkGreyText),
                  ),
                ),
              ),
              ),
            )),
            const SizedBox(height: 30),
            Controls(defendingBodyPart: defendingBodyPart,
                attackingBodyPart: attackingBodyPart,
                selectDefendingBodyPart: _selectDefendingBodyPart,
                selectAttackingBodyPart: _selectAttackingBodyPart),
            SizedBox(height: 14),
            GoButton(text: yourLives == 0 || enemysLives ==0 ? "Back" : "Go",
              onTap: _onGoButtonClicked,
              color:
              attackingBodyPart == null || defendingBodyPart == null ? FightClubColors.greyButton: Colors.black87,
            ),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _onGoButtonClicked(){
    if (yourLives == 0 || enemysLives == 0){
      Navigator.of(context).pop();
    }
    else if (attackingBodyPart != null && defendingBodyPart != null){
      setState((){
        final bool enemyLoseLife = attackingBodyPart != whatEnemyDefends;
        final bool youLoseLife = defendingBodyPart != whatEnemyAttacks;
        if (enemyLoseLife) {
          enemysLives -= 1;
        }
        if (youLoseLife) {
          yourLives -= 1;
        }
        if (youLoseLife == 0 || enemysLives == 0) {
          yourLives == maxLives;
          enemysLives == maxLives;
        }
        final FightResult? fightResult = FightResult.calculateResult(yourLives, enemysLives);
        if (fightResult != null ) {

          SharedPreferences.getInstance().then((sharedPreferences){
            sharedPreferences.setString("last_fight_result", fightResult.result);
            final key = "stats_${fightResult.result.toLowerCase()}";
            final int currentValue = sharedPreferences.getInt(key) ?? 0;
            sharedPreferences.setInt(key, currentValue + 1);
            });
        }
        centerText = _calculateCenterText(youLoseLife, enemyLoseLife);


        whatEnemyDefends = BodyPart.random();
        whatEnemyAttacks = BodyPart.random();

        attackingBodyPart = null;
        defendingBodyPart = null;
      });
    }
  }

  String _calculateCenterText(final bool enemyLoseLife, final bool youLoseLife){
    if (enemysLives == 0 && yourLives == 0){
      return  "Draw";
    } else if (yourLives == 0) {
      return  "You Lost";
    } else if (enemysLives == 0){
      return "You Won";
    } else {
      String first = enemyLoseLife
          ? "You hit enemys ${attackingBodyPart!.name. toLowerCase()}"
          : "Yor attack was bloked";
      String second = youLoseLife
          ? "Enemy hit your ${whatEnemyAttacks.name. toLowerCase()}"
          : "Enemy attack was bloked";
      return  "$first\n$second";
    }

  }


  void _selectDefendingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemysLives == 0){
      return;
    }
    setState((){
      defendingBodyPart = value;
    });
  }

  void _selectAttackingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemysLives == 0){
      return;
    }
    setState((){
      attackingBodyPart = value;
    });
  }
}

class Fightersinfo extends StatelessWidget {
  final int maxLivesCount;
  final int yourLivesCount;
  final int enemyLivesCount;

  const Fightersinfo({
    Key? key, required this.maxLivesCount, required this.yourLivesCount, required this.enemyLivesCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: ColoredBox(color: Colors.green)),
              Expanded(child: DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.green, Colors.redAccent],
                    )
                ),
              )),
              Expanded(child: ColoredBox(color: Colors.redAccent)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Lives(overallLivesCount: maxLivesCount, currentLivesCount: yourLivesCount),
              Column(
                children: [
                  const SizedBox(height: 16),
                  Text("You", style: TextStyle(
                      color: FightClubColors.darkGreyText)),
                  const SizedBox(height: 12),
                  Image.asset(FightClubImages.youAvatar, height: 92, width: 92),
                ],
              ),
              SizedBox(height: 44, width: 44, child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: FightClubColors.blueButton,
                ),
                child: Center(
                    child: Text(
                      "VS",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )
                ),
              ),),
              Column(
                children: [
                  const SizedBox(height: 16),
                  Text("Enemy", style: TextStyle(
                      color: FightClubColors.darkGreyText)),
                  const SizedBox(height: 12),
                  Image.asset(FightClubImages.enemyAvatar, height: 92, width: 92),
                ],
              ),
              Lives(overallLivesCount: maxLivesCount, currentLivesCount: enemyLivesCount),
            ],),
        ],
      ),
    );
  }
}


class Controls extends StatelessWidget {

  final BodyPart? defendingBodyPart;
  final BodyPart? attackingBodyPart;
  final ValueSetter<BodyPart> selectDefendingBodyPart;
  final ValueSetter<BodyPart> selectAttackingBodyPart;



  const Controls({super.key,
    required this.defendingBodyPart,
    required this.attackingBodyPart,
    required this.selectDefendingBodyPart,
    required this.selectAttackingBodyPart});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              Text("Defend".toUpperCase(), style: TextStyle(
                  color: FightClubColors.darkGreyText)),
              SizedBox(height: 13),
              BodyPartButton(bodyPart: BodyPart.head, selected: defendingBodyPart == BodyPart.head,
                bodyPartSetter: selectDefendingBodyPart,),
              SizedBox(height: 14),
              BodyPartButton(bodyPart: BodyPart.torso, selected: defendingBodyPart == BodyPart.torso,
                bodyPartSetter: selectDefendingBodyPart,
              ),
              SizedBox(height: 14),
              BodyPartButton(bodyPart: BodyPart.legs, selected: defendingBodyPart == BodyPart.legs,
                bodyPartSetter: selectDefendingBodyPart,
              ),
            ],
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              Text("Attack".toUpperCase(), style: TextStyle(
                  color: FightClubColors.darkGreyText)),
              SizedBox(height: 13),
              BodyPartButton(bodyPart: BodyPart.head, selected: attackingBodyPart == BodyPart.head,
                bodyPartSetter: selectAttackingBodyPart,),
              SizedBox(height: 14),
              BodyPartButton(bodyPart: BodyPart.torso, selected: attackingBodyPart == BodyPart.torso,
                bodyPartSetter: selectAttackingBodyPart,),
              SizedBox(height: 14),
              BodyPartButton(bodyPart: BodyPart.legs, selected: attackingBodyPart == BodyPart.legs,
                bodyPartSetter: selectAttackingBodyPart,),
            ],
          ),
        ),
        SizedBox(width: 16),
      ],
    );
  }
}

// виджет под кнопку... здесь была кнопка, но ты вынес её




// виджет для вывода жизней
class Lives extends StatelessWidget {
  final int overallLivesCount;
  final int currentLivesCount;
  const Lives({
    Key? key,
    required this.overallLivesCount,
    required this.currentLivesCount
  }) : assert(overallLivesCount >= 1),
        assert(currentLivesCount >= 0),
        assert(currentLivesCount <= overallLivesCount),

        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(overallLivesCount, (index) {
        if (index < currentLivesCount){
          return Padding(
            padding: EdgeInsets.only(bottom: index < overallLivesCount - 1 ? 4: 0),
            child: Image.asset(FightClubIcons.hearEmpty, width: 18, height: 18),
          );
        }
        else {
          return Padding(
            padding: EdgeInsets.only(bottom: index < overallLivesCount - 1 ? 4: 0),
            child: Image.asset(FightClubIcons.hearFull, width: 18, height: 18),
          );
        }
      }),
    );
  }
}



class BodyPart {
  final String name;

  const BodyPart._(this.name);

  static const head = BodyPart._("Head");
  static const torso = BodyPart._("Torso");
  static const legs = BodyPart._("Legs");

  @override
  String toString() {
    return 'BodyPart{name: $name}';
  }

  static const List<BodyPart>_valuse = [head, torso, legs];

  static BodyPart random(){
    return _valuse[Random().nextInt(_valuse.length)];
  }

}

class BodyPartButton extends StatelessWidget {
  final BodyPart bodyPart;
  final bool selected;
  final ValueSetter<BodyPart> bodyPartSetter;

  const BodyPartButton({
    Key? key,
    required this.bodyPart, required this.selected, required this.bodyPartSetter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => bodyPartSetter(bodyPart),
      child: SizedBox(
        height: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: selected? FightClubColors.blueButton : Colors.transparent,
              border: !selected? Border.all(color: FightClubColors.darkGreyText, width: 2) : null
          ),
          child: Center(
            child: Text(
              bodyPart.name.toUpperCase(),
              style: TextStyle(
                  color: selected ? FightClubColors.whiteText : FightClubColors.darkGreyText),
            ),
          ),
        ),
      ),
    );
  }
}