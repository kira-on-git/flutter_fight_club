import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/resources/fight_club_images.dart';

class FightResultWidget extends StatelessWidget {
  const FightResultWidget({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10),
      width: 132,
      height: 150,
      child:Row(children: [
        Column(
          children: [
            //const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 12),
              child: Text('You',
                  style: TextStyle(color: FightClubColors.darkGreyText)),
            ),
            //const SizedBox(height: 12),
            Image.asset(FightClubImages.youAvatar, width: 92 ,height: 92)
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
            //const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 12),
              child: Text('Enemy',
                  style: TextStyle(color: FightClubColors.darkGreyText)),
            ),
            //const SizedBox(height: 12),
            Image.asset(FightClubImages.enemyAvatar, width: 92 , height: 92),
          ],
        ),
      ],)
    );
  }
}
/*
Column(
children: [
Padding(
padding: const EdgeInsets.only(bottom: 6),
child: Text(
'Won: ',
style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
),
),
Padding(
padding: const EdgeInsets.only(bottom: 6),
child: Text('Draw: '),
),
Text('Lost: '),
],
),*/