import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tiflo_tv/features/resources/resources.dart';

void main() {
  test('app_sounds assets test', () {
    expect(File(AppSounds.categories).existsSync(), isTrue);
    expect(File(AppSounds.entertocategories).existsSync(), isTrue);
    expect(File(AppSounds.mainpage).existsSync(), isTrue);
    expect(File(AppSounds.navinfo).existsSync(), isTrue);
    expect(File(AppSounds.navinfovideo).existsSync(), isTrue);
    expect(File(AppSounds.welcome).existsSync(), isTrue);
  });
}
