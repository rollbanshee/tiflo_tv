// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tiflo_tv/features/providers/onboarding_provider.dart';
import 'package:tiflo_tv/features/resources/resources.dart';

class CategoryProvider extends ChangeNotifier {
  final String linkStart = 'https://tiflotv.abasoft.dev/storage/';
  late double heightGridItem;
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

  initStateCategorySounds(items, audio) async {
    final check1 = audio != null && audio.isNotEmpty;
    final check2 =
        items[indexItem1].audio != null && items[indexItem1].audio.isNotEmpty;

    final audioLink1 = check1 ? linkStart + audio[0]['download_link'] : '';
    final audioLink2 =
        check2 ? linkStart + items[indexItem1].audio[0]['download_link'] : '';

    final audio1 = await manager.getFileFromCache(audioLink1);
    final audio2 = await manager.getFileFromCache(audioLink2);
    final List<AudioSource> audioSources = [];
    if (audio1 == null && audio2 == null) {
      audioSources.add(AudioSource.asset(AppSounds.audionone));
    } else if (items.isEmpty) {
      audioSources.add(AudioSource.asset(AppSounds.emptyback));
    } else if (audio1 != null) {
      audioSources.add(AudioSource.uri(Uri.file(audio1.file.path)));
    } else if (audio2 != null) {
      audioSources.add(AudioSource.uri(Uri.file(audio2.file.path)));
    }
    final playlist = ConcatenatingAudioSource(children: audioSources);
    try {
      await player.setAudioSource(playlist,
          initialIndex: 0, initialPosition: Duration.zero);
      await player.play();
    } catch (e) {
      print("$e /////////////////////////////////////////////");
    }
  }

  onPopSounds(items, categoryAudio) async {
    final check1 = categoryAudio != null && categoryAudio.isNotEmpty;
    final check2 =
        items[indexItem1].audio != null && items[indexItem1].audio.isNotEmpty;
    final audioLink1 =
        check1 ? linkStart + categoryAudio[0]['download_link'] : '';
    final audioLink2 =
        check2 ? linkStart + items[indexItem1].audio[0]['download_link'] : '';

    final audio1 = await manager.getFileFromCache(audioLink1);
    final audio2 = await manager.getFileFromCache(audioLink2);
    final List<AudioSource> audioSources = [];

    if (audio1 == null && audio2 == null) {
      audioSources.add(AudioSource.asset(AppSounds.audionone));
    } else if (audio1 != null) {
      audioSources.add(AudioSource.uri(Uri.file(audio1.file.path)));
    } else if (audio2 != null) {
      audioSources.add(AudioSource.uri(Uri.file(audio2.file.path)));
    }

    final playlist = ConcatenatingAudioSource(children: audioSources);

    try {
      await player.setAudioSource(playlist,
          initialIndex: 0, initialPosition: Duration.zero);
      await player.play();
    } catch (e) {
      print("$e /////////////////////////////////////////////");
    }
  }

  itemsNameSounds(items) async {
    try {
      final audioLink = linkStart + items[indexItem1].audio[0]['download_link'];
      await player.stop();
      await player
          .setFilePath((await manager.getFileFromCache(audioLink))!.file.path);
      await player.play();
    } catch (e) {
      await player.setAsset(AppSounds.audionone);
      await player.play();
    }
  }
}
