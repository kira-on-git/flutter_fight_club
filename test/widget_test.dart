import 'package:flutter/material.dart';
import 'package:flutter_fight_club/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('l02h01', () {
    testWidgets('Scaffold have right background color', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      expect(
        (tester.firstWidget(find.byType(Scaffold)) as Scaffold).backgroundColor,
        const Color.fromRGBO(213, 222, 240, 1),
      );
    });
  });

  group("l02h02", () {
    testWidgets('Buttons with BodyParts have right background in unselected state',
        (WidgetTester tester) async {
      const Color correctBackgroundColor = Colors.black38;
      const Color correctBackgroundColor2 = Color(0x60000000);
      await tester.pumpWidget(MyApp());

      final coloredBoxInButtonFinder =
          (text) => findTypeByTextOnlyInParentType(ColoredBox, text, BodyPartButton);

      final List<ColoredBox> widgetsWithButtons = [
        ...tester.widgetList(coloredBoxInButtonFinder("HEAD")),
        ...tester.widgetList(coloredBoxInButtonFinder("TORSO")),
        ...tester.widgetList(coloredBoxInButtonFinder("LEGS")),
      ].cast<ColoredBox>().toList();
      final Set<Color> allColors = widgetsWithButtons.map((e) => e.color).toSet();
      expect(allColors, isNotEmpty);
      expect(allColors.length, 1);
      expect(allColors.single, isOneOrAnother(correctBackgroundColor, correctBackgroundColor2));
    });
  });

  group("l02h03", () {
    testWidgets(
        'Tap on GO button clears selected attackingBodyPart and defendingBodyPart only when'
        ' selected both of them', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      final GestureDetector goButton = tester.widget(find.widgetWithText(GestureDetector, "GO"));
      expect(goButton, isNotNull);
      final List<GestureDetector> widgetsWithBodyParts =
          tester.widgetList<GestureDetector>(find.widgetWithText(GestureDetector, "HEAD")).toList();
      expect(widgetsWithBodyParts.length, 2);

      const Color selectedButtonColor = Color.fromRGBO(28, 121, 206, 1);

      final coloredBoxInGestureDetectorFinder =
          (text) => findTypeByTextOnlyInParentType(ColoredBox, text, GestureDetector);

      final Color unselectedButtonColor =
          tester.widget<ColoredBox>(coloredBoxInGestureDetectorFinder("HEAD").first).color;

      await tester.tap(find.widgetWithText(GestureDetector, "HEAD").first);
      await tester.pump();

      expect(
        tester.widget<ColoredBox>(coloredBoxInGestureDetectorFinder("HEAD").first).color,
        selectedButtonColor,
      );
      expect(
        tester.widget<ColoredBox>(coloredBoxInGestureDetectorFinder("HEAD").last).color,
        unselectedButtonColor,
      );

      await tester.tap(find.widgetWithText(GestureDetector, "GO"));
      await tester.pump();

      expect(
        tester.widget<ColoredBox>(coloredBoxInGestureDetectorFinder("HEAD").first).color,
        selectedButtonColor,
      );
      expect(
        tester.widget<ColoredBox>(coloredBoxInGestureDetectorFinder("HEAD").last).color,
        unselectedButtonColor,
      );

      await tester.tap(coloredBoxInGestureDetectorFinder("HEAD").last);
      await tester.pump();

      expect(
        tester.widget<ColoredBox>(coloredBoxInGestureDetectorFinder("HEAD").first).color,
        selectedButtonColor,
      );
      expect(
        tester.widget<ColoredBox>(coloredBoxInGestureDetectorFinder("HEAD").last).color,
        selectedButtonColor,
      );

      await tester.tap(find.widgetWithText(GestureDetector, "GO"));
      await tester.pump();

      expect(
        tester.widget<ColoredBox>(coloredBoxInGestureDetectorFinder("HEAD").first).color,
        unselectedButtonColor,
      );
      expect(
        tester.widget<ColoredBox>(coloredBoxInGestureDetectorFinder("HEAD").last).color,
        unselectedButtonColor,
      );
    });
  });

  group('l01h04', () {
    testWidgets(
        'GO button changes its background if either attacking or defending body parts'
        ' is not selected', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      final GestureDetector goButton = tester.widget(find.widgetWithText(GestureDetector, "GO"));
      expect(goButton, isNotNull);

      final gestureDetectorFinder =
          (text) => findTypeByTextOnlyInParentType(GestureDetector, text, Row);

      final List<GestureDetector> widgetsWithBodyParts =
          tester.widgetList<GestureDetector>(gestureDetectorFinder("HEAD")).toList();
      expect(widgetsWithBodyParts.length, 2);

      const Color unselectedButtonColor = Colors.black38;
      const Color unselectedButtonColor2 = Color(0x60000000);
      const Color selectedGoButtonColor = Colors.black87;
      const Color selectedGoButtonColor2 = Color(0xDE000000);

      final coloredBoxFinder = (text) => findTypeByTextOnlyInParentType(ColoredBox, text, Row);

      expect(
        tester.widget<ColoredBox>(coloredBoxFinder("GO")).color,
        isOneOrAnother(unselectedButtonColor, unselectedButtonColor2),
      );

      await tester.tap(gestureDetectorFinder("HEAD").first);
      await tester.pump();

      expect(
        tester.widget<ColoredBox>(coloredBoxFinder("GO")).color,
        isOneOrAnother(unselectedButtonColor, unselectedButtonColor2),
      );

      await tester.tap(gestureDetectorFinder("HEAD").last);
      await tester.pump();

      expect(
        tester.widget<ColoredBox>(coloredBoxFinder("GO")).color,
        isOneOrAnother(selectedGoButtonColor, selectedGoButtonColor2),
      );
    });
  });

  group('l01h05', () {
    testWidgets('There are 5 ones below You and Enemy', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      final List<Text> widgetsWithLegs = tester.widgetList<Text>(find.text("1")).toList();
      expect(widgetsWithLegs.length, 10);
    });
  });
}

Matcher isOneOrAnother(dynamic one, dynamic another) => OneOrAnotherMatcher(one, another);

Finder findTypeByTextOnlyInParentType(
  final Type type,
  final String text,
  final Type parentType,
) {
  return find.descendant(
    of: find.byType(parentType),
    matching: find.ancestor(of: find.text(text), matching: find.byType(type)),
  );
}

class OneOrAnotherMatcher extends Matcher {
  final dynamic _one;
  final dynamic _another;

  const OneOrAnotherMatcher(this._one, this._another);

  @override
  Description describe(Description description) {
    return description
        .add('either ${_one.runtimeType}:<$_one> or ${_another.runtimeType}:<$_another>');
  }

  @override
  bool matches(Object? item, Map matchState) => item == _one || item == _another;
}