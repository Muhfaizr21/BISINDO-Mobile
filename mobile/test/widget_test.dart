import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/core/di/injection.dart';
import 'package:mobile/main.dart';

void main() {
  setUpAll(() async {
    final tempDir = await Directory.systemTemp.createTemp('hive_test_');
    Hive.init(tempDir.path);
    sl.init();
  });

  testWidgets('App navigation bar smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 300));

    // Verify bottom navigation bar destinations
    expect(find.text('Terjemahkan'), findsWidgets);
    expect(find.text('Belajar'), findsOneWidget);
    expect(find.text('Riwayat'), findsOneWidget);

    // Verify icons
    expect(find.byIcon(Icons.translate), findsOneWidget);
    expect(find.byIcon(Icons.school_outlined), findsOneWidget);
    expect(find.byIcon(Icons.history_outlined), findsOneWidget);

    // Switch to Belajar tab
    await tester.tap(find.text('Belajar'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Belajar Bahasa Isyarat'), findsOneWidget);

    // Switch to Riwayat tab
    await tester.tap(find.text('Riwayat'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Riwayat Terjemahan'), findsOneWidget);
  });
}
