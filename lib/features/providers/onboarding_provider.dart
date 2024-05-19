// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';
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
  final String linkStart = 'https://tiflotv.abasoft.dev/storage/';
  final String imageError =
      'https://developers.google.com/static/maps/documentation/maps-static/images/error-image-generic.png';
  List? allLessons;
  List? homeSliders;
  List? homeLessons;
  List? categories;
  AboutUs? info;
  List? categoriesIdWithItems = [];
  List audio = [];
  String? dataVersion = "";
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
      await getAllData();
      isLoading = false;
      Navigator.pop(context);
      notifyListeners();
    }
  }

  Future<void> getAllData() async {
    final getHome = await apiClient.getHome();
    info = await apiClient.getInfo();
    homeSliders = getHome.sliders;
    homeLessons = getHome.lessons;
  }

  Future<void> versionCheck() async {
    allLessons = await apiClient.getAllItems();
    final getCaregories = await apiClient.getCategories();
    dataVersion = getCaregories['version'].toString();
    categories = getCaregories['categories'];
    for (var e in categories!) {
      var items = await apiClient.getCategoryItems(e.category_id);
      categoriesIdWithItems?.add(items);
    }
    Uint8List dataVersionUint8 = Uint8List.fromList(dataVersion!.codeUnits);
    FileInfo? fileInfo = await manager.getFileFromCache("version.txt");
    final cachedVersion = fileInfo?.file.readAsStringSync();
    if (cachedVersion != dataVersion) {
      await manager.emptyCache();
      await manager.putFile("version.txt", dataVersionUint8);
      categories?.forEach((e) => e.audio != null && e.audio.isNotEmpty
          ? audio.add(linkStart + e.audio[0]['download_link'])
          : null);
      allLessons?.forEach((e) => e.audio != null && e.audio.isNotEmpty
          ? audio.add(linkStart + e.audio[0]['download_link'])
          : null);
      await Future.wait(
          audio.map((audioUrl) => manager.downloadFile(audioUrl)));
    }
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
      await getAllData();
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
