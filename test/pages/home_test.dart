// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery/data/gallery_options.dart';
import 'package:gallery/pages/backdrop.dart';

void main() {
  testWidgets('Home page hides settings semantics when closed', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [GalleryLocalizations.delegate],
        home: ModelBinding(
          initialModel: GalleryOptions(
            textScaleFactor: 1.0,
          ),
          child: Backdrop(
            settingsPage: Text('Front'),
            homePage: Text('Back'),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 1));

    expect(find.bySemanticsLabel('Settings'), findsOneWidget);
    expect(find.bySemanticsLabel('Close settings'), findsNothing);
    expect(tester.getSemantics(find.text('Back')).label, 'Back');
    expect(tester.getSemantics(find.text('Front')).label, '');

    await tester.tap(find.bySemanticsLabel('Settings'));
    await tester.pump(const Duration(seconds: 1));

    // The test no longer finds Setting and Close settings since the semantics
    // are excluded when settings mode is activated.
    // This was done so people could ready the settings page from top to
    // bottom by utilizing an invisible widget within the Settings Page.
    expect(tester.getSemantics(find.text('Back')).owner, null);
    expect(tester.getSemantics(find.text('Front')).label, 'Front');
  });
}
