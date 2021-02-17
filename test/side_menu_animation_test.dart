import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:side_menu_animation/side_menu_animation.dart';

void main() {
  group('SideMenuAnimation::Tests', () {
    testWidgets('SideMenuAnimation:: Press menu - Show Scrim Widget', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SideMenuAnimation(
            appBarBuilder: (showMenu) => AppBar(
              leading: IconButton(icon: Icon(Icons.menu, color: Colors.black), onPressed: showMenu),
            ),
            views: List.generate(4, (index) => Container()),
            items: List.generate(4, (index) => const SizedBox()).map((value) => value).toList(),
            tapOutsideToDismiss: true,
            onItemSelected: (value) {},
          ),
        ),
      ));

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.byType(AnimatedContainer), findsOneWidget);
    });

    testWidgets('SideMenuAnimation:: Press menu, press scrim widget and hide menu', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SideMenuAnimation(
            appBarBuilder: (showMenu) => AppBar(
              leading: IconButton(icon: Icon(Icons.menu, color: Colors.black), onPressed: showMenu),
            ),
            views: List.generate(4, (index) => Container()),
            items: List.generate(4, (index) => const SizedBox()).map((value) => value).toList(),
            tapOutsideToDismiss: true,
            onItemSelected: (value) {},
          ),
        ),
      ));

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      expect(find.byType(AnimatedContainer), findsOneWidget);
      await tester.tap(find.byType(AnimatedContainer));
      await tester.pumpAndSettle();
      expect(find.byType(AnimatedContainer), findsNothing);
    });

    testWidgets('SideMenuAnimation:: Press menu, press item 2 and display page 2', (tester) async {
      int _indexSelected;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SideMenuAnimation(
            appBarBuilder: (showMenu) => AppBar(
              leading: IconButton(icon: Icon(Icons.menu, color: Colors.black), onPressed: showMenu),
            ),
            views: List.generate(
                4, (index) => Container(color: Colors.red, child: Center(child: Text('Page ${index + 1}')))),
            items: List.generate(
              4,
              (index) => Center(
                child: Text('Item $index'),
              ),
            ).map((value) => value).toList(),
            tapOutsideToDismiss: true,
            scrimColor: Colors.black45,
            onItemSelected: (value) {
              _indexSelected = value;
            },
          ),
        ),
      ));
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Item 3'));
      await tester.pumpAndSettle();
      expect(find.text('Page 3'), findsOneWidget);
      expect(_indexSelected, 3);
    });
  });
}
