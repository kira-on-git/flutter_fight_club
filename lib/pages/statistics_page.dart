import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/widgets/secondary_action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Expanded(child: SizedBox()),
            Container(
              //color: Colors.lightBlueAccent,
              //alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 16, top: 24.0, right: 16),
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
            Expanded(child: SizedBox.shrink()),
            //task_#6
            FutureBuilder<SharedPreferences>(
                future: SharedPreferences.getInstance(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const SizedBox();
                  }
                  final SharedPreferences sp = snapshot.data!;
                  return Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Won: ${sp.getInt('stats_won') ?? 0}',
                          style: TextStyle(fontSize: 16,
                              color: FightClubColors.darkGreyText)),
                      const SizedBox(height: 6),
                      Text('Lost: ${sp.getInt('lost') ?? 0}',
                          style: TextStyle(fontSize: 16,
                              color: FightClubColors.darkGreyText)),
                      const SizedBox(height: 6),

                      Text('Draw: ${sp.getInt('stats_draw') ?? 0}',
                          style: TextStyle(fontSize: 16,
                              color: FightClubColors.darkGreyText)),
                    ],
                  );
                }),
            //task_#6
            /*Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 40,
                  child: Text(
                    'Won: ',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: FightClubColors.darkGreyText),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 40,
                  child: Text('Lost: ',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: FightClubColors.darkGreyText),),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 40,
                  child: Text('Draw: ',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: FightClubColors.darkGreyText),),
                ),
              ],
            ),*/
            Expanded(child: SizedBox.shrink()),
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
