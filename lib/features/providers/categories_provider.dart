// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tiflo_tv/features/providers/onboarding_provider.dart';
import 'package:tiflo_tv/features/resources/resources.dart';

class CategoriesProvider extends ChangeNotifier {
  int indexItem1 = 0;
  final player = AudioPlayer();
  ScrollController controller = ScrollController();

  onSwipe(String swipe, int length) {
    if (swipe == "+") {
      indexItem1 >= length ? indexItem1 = 0 : indexItem1++;
    } else if (swipe == "-") {
      indexItem1 <= 0 ? indexItem1 = length : indexItem1--;
    }
    notifyListeners();
  }

  initStateCategoriesSounds(categories) async {
    final playlist = ConcatenatingAudioSource(children: [
      AudioSource.asset(AppSounds.categories),
      AudioSource.asset(AppSounds.navinfo),
      categories.isEmpty
          ? AudioSource.asset(AppSounds.emptyback)
          : AudioSource.uri(Uri.file(
              (await manager.getFileFromCache(categories[indexItem1].audio))!
                  .file
                  .path))
    ]);

    try {
      await player.setAudioSource(playlist,
          initialIndex: 0, initialPosition: Duration.zero);
      await player.play();
    } catch (e) {
      print("$e /////////////////////////////////////////////");
    }
  }

  onPopSounds(categories) async {
    final playlist = ConcatenatingAudioSource(children: [
      AudioSource.asset(AppSounds.categories),
      AudioSource.uri(Uri.file(
          (await manager.getFileFromCache(categories[indexItem1].audio))!
              .file
              .path))
    ]);
    try {
      await player.setAudioSource(playlist,
          initialIndex: 0, initialPosition: Duration.zero);
      await player.play();
    } catch (e) {
      print("$e /////////////////////////////////////////////");
    }
  }

  itemsNameSounds(categories) async {
    try {
      final audio = categories[indexItem1].audio;
      await player.stop();
      await player.setUrl((await manager.getFileFromCache(audio))!.file.path);
      await player.play();
    } catch (e) {
      e;
    }
  }
}
