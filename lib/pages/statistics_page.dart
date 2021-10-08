import 'package:flutter/material.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/widgets/secondary_action_button.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          children: [
            //Expanded(child: SizedBox()),
            Container(
              color: Colors.lightBlueAccent,
              //alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 16,top: 24.0,right: 16),
              height: 40,
              child: Text(
                "Statistics",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: FightClubColors.darkGreyText,
                 ),
              ),
            ),
            Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SecondaryActionButton(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  text: 'Back'),
            ),
          ],
        ),
      ),
    );
  }
}
