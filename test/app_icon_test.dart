import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tiflo_tv/features/resources/resources.dart';

void main() {
  test('app_icon assets test', () {
    expect(File(AppIcon.favicon).existsSync(), isTrue);
  });
}
