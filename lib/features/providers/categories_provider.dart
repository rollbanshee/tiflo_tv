// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tiflo_tv/features/providers/onboarding_provider.dart';
import 'package:tiflo_tv/features/resources/resources.dart';

class CategoriesProvider extends ChangeNotifier {
  final String linkStart = 'https://tiflotv.abasoft.dev/storage/';
  late double heightGridItem;
  late double widthGridItem;

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
    try {
      final audioLink =
          linkStart + categories[indexItem1].audio[0]['download_link'];
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
      final audioLink =
          linkStart + categories[indexItem1].audio[0]['download_link'];
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
      await player.stop();
      await player
          .setUrl((await manager.getFileFromCache(audioLink))!.file.path);
      await player.play();
    } catch (e) {
      await player.setAsset(AppSounds.audionone);
      await player.play();
    }
  }
}
