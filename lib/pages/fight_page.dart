import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';

import '../resources/fight_club_colors.dart';
import '../resources/fight_club_icons.dart';
import '../resources/fight_club_images.dart';
import '../widgets/action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FightPage extends StatefulWidget {
  const FightPage({Key? key}) : super(key: key);

  @override
  FightPageState createState() => FightPageState();
}

class FightPageState extends State<FightPage> {
  static const maxLives = 5;

  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;

  BodyPart whatEnemyAttacks = BodyPart.random();
  BodyPart whatEnemyDefends = BodyPart.random();

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
            FightersInfo(
                maxLivesCount: maxLives,
                yourLivesCount: yourLives,
                enemysLivesCount: enemysLives),
            const SizedBox(height: 30),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ColoredBox(
                color: FightClubColors.darkPurple,
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    centerText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: FightClubColors.darkGreyText, fontSize: 10),
                  )),
                ),
              ),
            )),
            const SizedBox(height: 30),
            ControlsWidget(
                defendingBodyPart: defendingBodyPart,
                selectDefendingBodyPart: _selectDefendingBodyPart,
                attackingBodyPart: attackingBodyPart,
                selectAttackingBodyPart: _selectAttackingBodyPart),
            SizedBox(height: 14),
            ActionButton(
              text: yourLives == 0 || enemysLives == 0 ? "Back" : "Go",
              onTap: _onGoButtonClicked,
              color: _getGoButtonColor(),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

//COLOR of GoButton depending of State
  Color _getGoButtonColor() {
    if (yourLives == 0 || enemysLives == 0) {
      return FightClubColors.blackButton;
    } else if (attackingBodyPart == null || defendingBodyPart == null) {
      return FightClubColors.greyButton;
    } else {
      return FightClubColors.blackButton;
    }
  }

  //States for Lives by Clicking of GoButton
  void _onGoButtonClicked() {
    if (yourLives == 0 || enemysLives == 0) {
      Navigator.of(context).pop();
    } else if (attackingBodyPart != null && defendingBodyPart != null) {
      setState(() {
        final bool enemyLoseLife = attackingBodyPart != whatEnemyDefends;
        final bool youLoseLife = defendingBodyPart != whatEnemyAttacks;

        if (enemyLoseLife) {
          enemysLives -= 1;
        }
        if (youLoseLife) {
          yourLives -= 1;
        }

        //here sharedPreference
        final FightResult? fightResult =
            FightResult.calculateResult(yourLives, enemysLives);
        if (fightResult != null) {
          SharedPreferences.getInstance().then((sharedPreferences) {
            sharedPreferences.setString(
                "last_fight_result", fightResult.result);
            //task #6_1
            final String key = "stats_${fightResult.result.toLowerCase()}";
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

  String _calculateCenterText(
      final bool youLoseLife, final bool enemyLoseLife) {
    if (enemysLives == 0 && yourLives == 0) {
      return "Draw";
    } else if (yourLives == 0) {
      return "You lost";
    } else if (enemysLives == 0) {
      return "You won";
    } else {
      final String first = enemyLoseLife
          ? "You hit enemy's ${attackingBodyPart!.name.toLowerCase()}."
          : "Your attack was blocked.";
      final String second = youLoseLife
          ? "Enemy hit your ${whatEnemyAttacks.name.toLowerCase()}."
          : "Enemy's attack was blocked.";
      return "$first\n$second";
    }
  }

//ValueSetter
  void _selectDefendingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemysLives == 0) {
      return;
    }

    setState(() {
      defendingBodyPart = value;
    });
  }

  void _selectAttackingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemysLives == 0) {
      return;
    }
    setState(() {
      attackingBodyPart = value;
    });
  }
}

// FightersInfo: Lives Score
class FightersInfo extends StatelessWidget {
  final int maxLivesCount;
  final int yourLivesCount;
  final int enemysLivesCount;

  const FightersInfo(
      {Key? key,
      required this.maxLivesCount,
      required this.yourLivesCount,
      required this.enemysLivesCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: ColoredBox(
                color: Colors.white,
              )),
              Expanded(
                  child: DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.white, FightClubColors.darkPurple])),
              )),
              Expanded(
                  child: ColoredBox(
                color: FightClubColors.darkPurple,
              )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              LivesWidget(
                overallLivesCount: maxLivesCount,
                currentLivesCount: yourLivesCount,
              ),
              Column(
                children: [
                  const SizedBox(height: 16),
                  Text('You',
                      style: TextStyle(color: FightClubColors.darkGreyText)),
                  const SizedBox(height: 12),
                  Image.asset(FightClubImages.youAvatar, width: 92, height: 92)
                ],
              ),
              SizedBox(
                width: 44,
                height: 44,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: FightClubColors.blueButton),
                  child: Center(
                    child: Text(
                      'vs',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 16),
                  Text('Enemy',
                      style: TextStyle(color: FightClubColors.darkGreyText)),
                  const SizedBox(height: 12),
                  Image.asset(FightClubImages.enemyAvatar,
                      width: 92, height: 92),
                ],
              ),
              LivesWidget(
                overallLivesCount: maxLivesCount,
                currentLivesCount: enemysLivesCount,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//Panel with Body Parts
class ControlsWidget extends StatelessWidget {
  final BodyPart? defendingBodyPart;
  final ValueSetter<BodyPart> selectDefendingBodyPart;
  final BodyPart? attackingBodyPart;
  final ValueSetter<BodyPart> selectAttackingBodyPart;

  const ControlsWidget(
      {Key? key,
      required this.defendingBodyPart,
      required this.selectDefendingBodyPart,
      required this.attackingBodyPart,
      required this.selectAttackingBodyPart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 16),
        Expanded(
          child: Column(children: [
            Text('Defend'.toUpperCase(),
                style: TextStyle(color: FightClubColors.darkGreyText)),
            SizedBox(height: 13),
            BodyPartButton(
                bodyPart: BodyPart.head,
                selected: defendingBodyPart == BodyPart.head,
                bodyPartSetter: selectDefendingBodyPart),
            SizedBox(height: 14),
            BodyPartButton(
                bodyPart: BodyPart.torso,
                selected: defendingBodyPart == BodyPart.torso,
                bodyPartSetter: selectDefendingBodyPart),
            SizedBox(height: 14),
            BodyPartButton(
                bodyPart: BodyPart.legs,
                selected: defendingBodyPart == BodyPart.legs,
                bodyPartSetter: selectDefendingBodyPart),
          ]),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(children: [
            Text('Attack'.toUpperCase(),
                style: TextStyle(color: FightClubColors.darkGreyText)),
            SizedBox(height: 13),
            BodyPartButton(
                bodyPart: BodyPart.head,
                selected: attackingBodyPart == BodyPart.head,
                bodyPartSetter: selectAttackingBodyPart),
            SizedBox(height: 14),
            BodyPartButton(
                bodyPart: BodyPart.torso,
                selected: attackingBodyPart == BodyPart.torso,
                bodyPartSetter: selectAttackingBodyPart),
            SizedBox(height: 14),
            BodyPartButton(
                bodyPart: BodyPart.legs,
                selected: attackingBodyPart == BodyPart.legs,
                bodyPartSetter: selectAttackingBodyPart),
          ]),
        ),
        SizedBox(width: 16),
      ],
    );
  }
}

//Counting of Lives
class LivesWidget extends StatelessWidget {
  final int overallLivesCount;
  final int currentLivesCount;

  const LivesWidget(
      {Key? key,
      required this.overallLivesCount,
      required this.currentLivesCount})
      : assert(overallLivesCount >= 1),
        assert(currentLivesCount >= 0),
        assert(currentLivesCount <= overallLivesCount),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(overallLivesCount, (index) {
        if (index < currentLivesCount) {
          return [
            Image.asset(FightClubIcons.heartFull, width: 18, height: 18),
            if (index < overallLivesCount - 1) SizedBox(height: 4)
          ];
        } else {
          return [
            Image.asset(FightClubIcons.heartEmpty, width: 18, height: 18),
            if (index < overallLivesCount - 1) SizedBox(height: 4)
          ];
        }
      }).expand((element) => element).toList(),
    );
  }
}

//States of BodyPartButtons => Rich Enum
class BodyPart {
  final String name; //название параметра класса BodyPart

  const BodyPart._(this.name); //конструкрор

  static const head = BodyPart._("Head");
  static const torso = BodyPart._("Torso");
  static const legs = BodyPart._("Legs");

  @override
  String toString() => 'BodyPart{name: $name}';

  static const List<BodyPart> _values = [head, torso, legs];

  static BodyPart random() {
    return _values[Random().nextInt(_values.length)];
  }
}

//Button for Body Parts
class BodyPartButton extends StatelessWidget {
  final BodyPart bodyPart;
  final bool selected;
  final ValueSetter<BodyPart> bodyPartSetter;

  const BodyPartButton({
    Key? key,
    required this.bodyPart,
    required this.selected,
    required this.bodyPartSetter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => bodyPartSetter(bodyPart),
      child: SizedBox(
        height: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
              border: !selected
                  ? Border.all(color: FightClubColors.darkGreyText, width: 2)
                  : null,
              color:
                  selected ? FightClubColors.blueButton : Colors.transparent),
          child: Center(
            child: Text(bodyPart.name.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  color: selected
                      ? FightClubColors.whiteText
                      : FightClubColors.darkGreyText,
                )),
          ),
        ),
      ),
    );
  }
}
