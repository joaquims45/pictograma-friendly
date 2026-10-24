import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pictograma_friendly/core/widgets/forgiving_tap.dart';

void main() {
  late int taps;
  late DateTime now;

  Widget host({Widget Function(Widget tile)? wrap}) {
    final tile = ForgivingTap(
      clock: () => now,
      onTap: () => taps++,
      builder: (context, pressed) => Container(
        key: const Key('tile'),
        width: 200,
        height: 200,
        color: pressed ? Colors.grey : Colors.white,
      ),
    );
    return MaterialApp(
      home: Scaffold(body: Center(child: wrap == null ? tile : wrap(tile))),
    );
  }

  setUp(() {
    taps = 0;
    now = DateTime(2026, 1, 1);
  });

  testWidgets('un toque común cuenta una vez', (tester) async {
    await tester.pumpWidget(host());
    await tester.tap(find.byKey(const Key('tile')));
    expect(taps, 1);
  });

  testWidgets('dos dedos a la vez dicen una sola vez', (tester) async {
    await tester.pumpWidget(host());
    final c = tester.getCenter(find.byKey(const Key('tile')));
    final a = await tester.startGesture(c - const Offset(30, 0), pointer: 1);
    final b = await tester.startGesture(c + const Offset(30, 0), pointer: 2);
    await a.up();
    await b.up();
    expect(taps, 1);
  });

  testWidgets('con un segundo dedo apoyado igual cuenta el primero', (
    tester,
  ) async {
    await tester.pumpWidget(host());
    final c = tester.getCenter(find.byKey(const Key('tile')));
    final a = await tester.startGesture(c, pointer: 1);
    final b = await tester.startGesture(c + const Offset(40, 40), pointer: 2);
    await a.up(); // el primer dedo se levanta mientras el otro sigue apoyado
    expect(taps, 1);
    await b.up();
  });

  testWidgets('un dedo que se desliza un poco igual cuenta', (tester) async {
    await tester.pumpWidget(host());
    final c = tester.getCenter(find.byKey(const Key('tile')));
    final g = await tester.startGesture(c);
    await g.moveBy(
      const Offset(30, 25),
    ); // más que el límite del toque estándar (18)
    await g.up();
    expect(taps, 1);
  });

  testWidgets('apoyar mucho rato y soltar también cuenta', (tester) async {
    await tester.pumpWidget(host());
    final g = await tester.startGesture(
      tester.getCenter(find.byKey(const Key('tile'))),
    );
    await tester.pump(const Duration(seconds: 3));
    await g.up();
    expect(taps, 1);
  });

  testWidgets('un arrastre largo no cuenta como toque', (tester) async {
    await tester.pumpWidget(host());
    final g = await tester.startGesture(
      tester.getCenter(find.byKey(const Key('tile'))),
    );
    await g.moveBy(const Offset(0, 120));
    await g.up();
    expect(taps, 0);
  });

  testWidgets('hacer scroll sobre el tablero no dice nada', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: [
              for (var i = 0; i < 12; i++)
                SizedBox(
                  height: 160,
                  child: ForgivingTap(
                    onTap: () => taps++,
                    builder: (_, _) => Container(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(taps, 0);
  });

  testWidgets('dos toques separados dicen dos veces', (tester) async {
    await tester.pumpWidget(host());
    final tile = find.byKey(const Key('tile'));
    await tester.tap(tile);
    now = now.add(const Duration(milliseconds: 500));
    await tester.tap(tile);
    expect(taps, 2);
  });

  testWidgets('feedback de presionado mientras hay un dedo', (tester) async {
    await tester.pumpWidget(host());
    Color colorNow() =>
        (tester.widget<Container>(find.byKey(const Key('tile'))).color)!;
    expect(colorNow(), Colors.white);
    final g = await tester.startGesture(
      tester.getCenter(find.byKey(const Key('tile'))),
    );
    await tester.pump();
    expect(colorNow(), Colors.grey);
    await g.up();
    await tester.pump();
    expect(colorNow(), Colors.white);
  });
}
