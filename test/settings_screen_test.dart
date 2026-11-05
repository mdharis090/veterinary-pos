import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veterinary_pos/src/features/settings/presentation/settings_screen.dart';

class _MemorySettingsStore implements SettingsStore {
  Map<String, dynamic>? settings;

  @override
  Future<Map<String, dynamic>?> read() async => settings;

  @override
  Future<void> write(Map<String, dynamic> value) async {
    settings = jsonDecode(jsonEncode(value)) as Map<String, dynamic>;
  }
}

void main() {
  testWidgets('profile changes validate and persist locally', (tester) async {
    final store = _MemorySettingsStore();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SettingsScreen(store: store)),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    expect(find.text('Full name is required.'), findsOneWidget);
    expect(store.settings, isNull);

    await tester.enterText(find.byType(TextFormField).at(0), 'Dr. Sana');
    await tester.enterText(find.byType(TextFormField).at(1), 'sana.vet');
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(store.settings!['profile']['name'], 'Dr. Sana');
    expect(store.settings!['profile']['username'], 'sana.vet');
    expect(find.text('Profile saved on this device.'), findsOneWidget);
  });

  testWidgets('notifications, users, and roles can be changed', (tester) async {
    final store = _MemorySettingsStore();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SettingsScreen(store: store)),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Notifications'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    expect(store.settings!['notifications']['appointment_reminders'], isFalse);

    await tester.tap(find.text('Users'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add user'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Amina');
    await tester.tap(find.text('Add').last);
    await tester.pumpAndSettle();
    expect(store.settings!['users'].single['name'], 'Amina');

    await tester.tap(find.text('Roles'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add role'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Nurse');
    await tester.tap(find.text('Save').last);
    await tester.pumpAndSettle();
    expect(store.settings!['roles'], contains('Nurse'));
  });

  testWidgets('clinic details and settings backup restore work', (
    tester,
  ) async {
    final store = _MemorySettingsStore();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: SettingsScreen(store: store)),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Clinic info'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Vetnalay Clinic');
    await tester.enterText(find.byType(TextFormField).at(1), 'Main Street');
    await tester.tap(find.text('Save clinic info'));
    await tester.pumpAndSettle();
    expect(store.settings!['clinic']['name'], 'Vetnalay Clinic');
    expect(store.settings!['clinic']['address'], 'Main Street');

    await tester.tap(find.text('Backup'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Restore from JSON'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField).last,
      '{"profile":{"name":"Restored","username":"restored"}}',
    );
    await tester.tap(find.text('Restore').last);
    await tester.pumpAndSettle();
    expect(store.settings!['profile']['name'], 'Restored');
    expect(store.settings!['clinic']['name'], '');
  });
}
