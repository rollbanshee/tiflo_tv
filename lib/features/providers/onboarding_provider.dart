// ignore_for_file: avoid_print

import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tiflo_tv/features/domain/api_client/api_client.dart';
import 'package:tiflo_tv/features/domain/models/about_us/about_us.dart';
import 'package:tiflo_tv/features/domain/models/categories/categories.dart';
// ignore: unused_import
import 'package:tiflo_tv/features/domain/models/items/items.dart';
import 'package:tiflo_tv/features/resources/resources.dart';

DefaultCacheManager manager = DefaultCacheManager();

class OnBoardingProvider extends ChangeNotifier {
  int sliding = 1;
  final player = AudioPlayer();
  final String linkStart = 'https://tiflotv.az/storage/';
  final String imageError =
      'https://developers.google.com/static/maps/documentation/maps-static/images/error-image-generic.png';
  final box = Hive.box('data');
  final audioAll = [];
  String? dataVersion;
  List<Categories>? categories;
  double progressValue = 0.0;
  double getHomeLoading = 0;
  double getCategoriesLoading = 0;
  // List? allLessons;
  late Uint8List dataVersionUint8;
  AboutUs? info;
  // String? dataVersion = "";
  bool isDataLoading = false;
  bool isInfoVersionLoading = false;

  Future<void> getHome() async {
    final home = await apiClient.getHome((progress) {
      getHomeLoading = progress;
      progressValue = 0.4 + getHomeLoading;
      // print('HOME $getHomeLoading');
      notifyListeners();
    });
    final homeSliders = home.sliders;
    final homeLessons = home.lessons;
    box.put('homeSliders', homeSliders);
    box.put('homeLessons', homeLessons);
  }

  Future<void> getCategories() async {
    categories = await apiClient.getCategories((progress) {
      getCategoriesLoading = progress;
      progressValue = 0.6 + getCategoriesLoading;
      // print('CATEGORIES $getCategoriesLoading');
      notifyListeners();
    });
    box.put('categories', categories);
  }

  Future<String?> cachedVersion() async {
    FileInfo? fileInfo = await manager.getFileFromCache("version.txt");
    final cachedVersion = fileInfo?.file.readAsStringSync();
    return cachedVersion;
  }

  Future<void> cachingFiles() async {
    categories?.forEach((e) {
      if (e.audio != null) {
        audioAll.add(linkStart + e.audio?[0]['download_link']);
      }
    });
    categories?.forEach((e) {
      e.lessons?.forEach((e) {
        if (e.audio != null) {
          audioAll.add(linkStart + e.audio?[0]['download_link']);
        }
      });
    });
    await Future.wait(audioAll.map((audioUrl) async {
      try {
        await manager.downloadFile(audioUrl);
      } catch (e) {
        print('Error in cachingFiles: $e');
      }
    }));
  }

  Future<void> getData() async {
    if (isDataLoading) {
      progressValue = 0;
      for (double i = 0; i <= 0.2; i += 0.001) {
        await Future.delayed(const Duration(milliseconds: 1));
        progressValue = i;
        notifyListeners();
      }
      manager.emptyCache;
      for (double i = 0.2; i <= 0.4; i += 0.001) {
        await Future.delayed(const Duration(milliseconds: 1));
        progressValue = i;
        notifyListeners();
      }
      await getHome();
      await getCategories();
      for (double i = 0.8; i <= 0.86; i += 0.001) {
        await Future.delayed(const Duration(milliseconds: 1));
        progressValue = i;
        notifyListeners();
      }
      await cachingFiles();
      await manager.putFile("version.txt", dataVersionUint8);
      for (double i = 0.86; i <= 1; i += 0.001) {
        await Future.delayed(const Duration(milliseconds: 1));
        progressValue = i;
        notifyListeners();
      }
      isDataLoading = false;
    }
    initStateOnBoardingSounds();
  }

  Future<void> getInfoVersion() async {
    info = await apiClient.getInfo();
    dataVersion = info!.version.toString();
    dataVersionUint8 = Uint8List.fromList(dataVersion!.codeUnits);
    if (await cachedVersion() != dataVersion) {
      isDataLoading = true;
    }
  }

  initStateOnBoardingSounds() async {
    final playlist = ConcatenatingAudioSource(children: [
      AudioSource.asset(AppSounds.welcome),
      AudioSource.asset(AppSounds.onboardingtext),
      AudioSource.asset(AppSounds.entertocategories),
    ]);
    await player.setAudioSource(playlist,
        initialIndex: 0, initialPosition: Duration.zero);
    await player.play();
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
