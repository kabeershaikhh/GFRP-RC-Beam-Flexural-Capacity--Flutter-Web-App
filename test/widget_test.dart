import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gfrp_ann/main.dart';

void main() {
  testWidgets('GFRP Capacity App smoke test and calculation simulation', (WidgetTester tester) async {
    // Set web desktop screen resolution
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const GfrpCapacityApp());
    await tester.pumpAndSettle();

    // Verify header title and conference badge are rendered
    expect(find.text('GFRP-RC Flexural Capacity Analyzer'), findsOneWidget);
    expect(find.text('ICEC 2026 Paper'), findsOneWidget);

    // Verify preset chips are present
    expect(find.text('Standard Beam'), findsOneWidget);
    expect(find.text('Heavy Girder'), findsOneWidget);
    expect(find.text('Tension-Controlled'), findsOneWidget);

    // Verify calculate button
    final calcBtn = find.text('CALCULATE CAPACITIES');
    expect(calcBtn, findsOneWidget);

    // Verify empty state text
    expect(find.text('Ready for Flexural Analysis'), findsOneWidget);

    // Scroll until calculate button is visible in viewport, then tap it
    await tester.ensureVisible(calcBtn);
    await tester.pumpAndSettle();
    await tester.tap(calcBtn);
    await tester.pump(); // Render loading state

    // Verify circular loading bar is shown during calculation
    expect(find.byType(CircularProgressIndicator), findsWidgets);
    expect(find.text('Evaluating GFRP Beam Capacity...'), findsOneWidget);

    // Advance 2 seconds for calculation to complete
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Verify results are now visible
    expect(find.text('AI PREDICTED (Mn,AI)'), findsOneWidget);
    expect(find.text('ACI 440.1R-15 (Mn,ACI)'), findsOneWidget);
    expect(find.text('Safety Factors & Failure Mechanism'), findsOneWidget);
    expect(find.text('Detailing & Constructability Compliance'), findsOneWidget);
  });
}
