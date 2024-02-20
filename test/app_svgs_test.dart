import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tiflo_tv/features/resources/resources.dart';

void main() {
  test('app_svgs assets test', () {
    expect(File(AppSvgs.arrowLeft).existsSync(), isTrue);
    expect(File(AppSvgs.bottomNavBarCategory).existsSync(), isTrue);
    expect(File(AppSvgs.bottomNavBarFavourites).existsSync(), isTrue);
    expect(File(AppSvgs.bottomNavBarHome).existsSync(), isTrue);
    expect(File(AppSvgs.bottomNavBarInfo).existsSync(), isTrue);
    expect(File(AppSvgs.favouriteStar).existsSync(), isTrue);
    expect(File(AppSvgs.notFavouriteStar).existsSync(), isTrue);
    expect(File(AppSvgs.onboardingLogo).existsSync(), isTrue);
    expect(File(AppSvgs.playCircle).existsSync(), isTrue);
    expect(File(AppSvgs.splashScreenLogo).existsSync(), isTrue);
  });
}
