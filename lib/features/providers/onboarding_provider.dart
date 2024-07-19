// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tiflo_tv/features/domain/api_client/api_client.dart';
import 'package:tiflo_tv/features/domain/models/about_us/about_us.dart';
import 'package:tiflo_tv/features/resources/resources.dart';

DefaultCacheManager manager = DefaultCacheManager();

class OnBoardingProvider extends ChangeNotifier {
  int sliding = 1;
  final player = AudioPlayer();
  final String linkStart = 'https://tiflotv.az/storage/';
  final String imageError =
      'https://developers.google.com/static/maps/documentation/maps-static/images/error-image-generic.png';
  // List? allLessons;
  // final boxCategories = Hive.box("categories");
  // final boxCategoryItems = Hive.box('categoryItems');
  List? homeSliders;
  List? homeLessons;
  AboutUs? info;
  // String? dataVersion = "";
  bool isLoading = false;

  Future<void> getDataOnboarding(context) async {
    if (!isLoading) {
      isLoading = true;
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Platform.isAndroid
                ? const Center(
                    child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                        strokeWidth: 3, color: Colors.white),
                  ))
                : Center(
                    child: CupertinoActivityIndicator(
                    color: Colors.white,
                    radius: 15.r,
                  ));
          });
      await getHome();
      isLoading = false;
      Navigator.pop(context);
      notifyListeners();
    }
  }

  Future<void> getHome() async {
    final getHome = await apiClient.getHome();
    homeSliders = getHome.sliders;
    homeLessons = getHome.lessons;
  }

  Future<void> getInfo() async {
    info = await apiClient.getInfo();
    // dataVersion = info!.version.toString();
  }

  initStateOnBoardingSounds() async {
    final playlist = ConcatenatingAudioSource(children: [
      AudioSource.asset(AppSounds.welcome),
      AudioSource.asset(AppSounds.entertocategories),
    ]);
    await player.setAudioSource(playlist,
        initialIndex: 0, initialPosition: Duration.zero);
    await player.play();
  }

  Future<void> getData() async {
    if (!isLoading) {
      isLoading = true;
      await getHome();
      isLoading = false;
      notifyListeners();
    }
  }

  onValueChanged(value) {
    sliding = value!;
    notifyListeners();
  }

  onSwipe(value) {
    sliding = value!;
    notifyListeners();
  }
}
