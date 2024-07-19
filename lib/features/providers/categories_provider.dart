// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tiflo_tv/features/domain/api_client/api_client.dart';
import 'package:tiflo_tv/features/providers/onboarding_provider.dart';
import 'package:tiflo_tv/features/resources/resources.dart';

class CategoriesProvider extends ChangeNotifier {
  final String linkStart = 'https://tiflotv.az/storage/';
  List? categories;
  List audio = [];
  bool isLoading = false;
  bool isBackPressed = false;
  int indexItem1 = 0;
  final player = AudioPlayer();
  ScrollController controller = ScrollController();

  Future<void> getCategories(int sliding) async {
    // Uint8List dataVersionUint8 = Uint8List.fromList(dataVersion!.codeUnits);
    // FileInfo? fileInfo = await manager.getFileFromCache("version.txt");
    // final cachedVersion = fileInfo?.file.readAsStringSync();
    // if (cachedVersion != dataVersion) {
    if (categories == null) {
      isLoading = true;
      categories = await apiClient.getCategories();
      isLoading = false;
      notifyListeners();
    }
    if (sliding == 1) {
      initStateCategoriesSounds(categories ?? []);
    }
    // await manager.emptyCache();
    // await manager.putFile("version.txt", dataVersionUint8);
    audio.clear();
    categories?.forEach((e) {
      if (e.audio != null && e.audio.isNotEmpty) {
        audio.add(linkStart + e.audio[0]['download_link']);
        // boxCategories.add(e);
      }
    });
    await Future.wait(audio.map((audioUrl) async {
      try {
        await manager.downloadFile(audioUrl);
      } catch (e) {
        print("${e}AAAAAAAAAAAAAAAAAAAAA");
      }
    }));
    // }
    notifyListeners();
  }

  onSwipe(String swipe, int length) {
    if (swipe == "+") {
      indexItem1 >= length ? indexItem1 = 0 : indexItem1++;
    } else if (swipe == "-") {
      indexItem1 <= 0 ? indexItem1 = length : indexItem1--;
    }
    notifyListeners();
  }

  initStateCategoriesSounds(categories) async {
    if (isBackPressed) {
      return;
    }
    try {
      final audioLink = linkStart +
          (categories.length > 0
              ? (categories[indexItem1].audio[0]['download_link'])
              : '');
      final audio1 = await manager.getFileFromCache(audioLink);
      final playlist = ConcatenatingAudioSource(children: [
        AudioSource.asset(AppSounds.categories),
        AudioSource.asset(AppSounds.navinfo),
        categories.isEmpty
            ? AudioSource.asset(AppSounds.emptyback)
            : AudioSource.uri(Uri.file((audio1)!.file.path))
      ]);

      await player.setAudioSource(playlist,
          initialIndex: 0, initialPosition: Duration.zero);
      await player.play();
    } catch (e) {
      final playlist = ConcatenatingAudioSource(children: [
        AudioSource.asset(AppSounds.categories),
        AudioSource.asset(AppSounds.navinfo),
        categories.isEmpty
            ? AudioSource.asset(AppSounds.emptyback)
            : AudioSource.asset(AppSounds.audionone),
      ]);
      await player.setAudioSource(playlist,
          initialIndex: 0, initialPosition: Duration.zero);
      await player.play();
      print("$e /////////////////////////////////////////////");
    }
  }

  onPopSounds(categories) async {
    try {
      final audioLink = linkStart +
          (categories.length > 0
              ? (categories[indexItem1].audio[0]['download_link'])
              : '');
      final audio1 = await manager.getFileFromCache(audioLink);
      final playlist = ConcatenatingAudioSource(children: [
        AudioSource.asset(AppSounds.categories),
        AudioSource.uri(Uri.file((audio1)!.file.path))
      ]);

      await player.setAudioSource(playlist,
          initialIndex: 0, initialPosition: Duration.zero);
      await player.play();
    } catch (e) {
      final playlist = ConcatenatingAudioSource(children: [
        AudioSource.asset(AppSounds.categories),
        AudioSource.asset(AppSounds.audionone)
      ]);
      await player.setAudioSource(playlist,
          initialIndex: 0, initialPosition: Duration.zero);
      await player.play();
      print("$e /////////////////////////////////////////////");
    }
  }

  itemsNameSounds(categories) async {
    try {
      final audioLink =
          linkStart + categories[indexItem1].audio[0]['download_link'];
      final audioPath = (await manager.getFileFromCache(audioLink))!.file.path;
      await player.stop();
      await player.setFilePath(audioPath);
      await player.play();
    } catch (e) {
      await player.setAsset(AppSounds.audionone);
      await player.play();
    }
  }
}
