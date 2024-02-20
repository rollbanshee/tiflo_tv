import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tiflo_tv/features/resources/resources.dart';

void main() {
  test('app_images assets test', () {
    expect(File(AppImages.carousel).existsSync(), isTrue);
    expect(File(AppImages.onboardingBackground).existsSync(), isTrue);
    expect(File(AppImages.onboardingBackground4K).existsSync(), isTrue);
  });
}
