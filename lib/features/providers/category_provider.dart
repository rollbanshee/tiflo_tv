// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tiflo_tv/features/providers/onboarding_provider.dart';
import 'package:tiflo_tv/features/resources/resources.dart';

class CategoryProvider extends ChangeNotifier {
  final String linkStart = 'https://tiflotv.az/storage/';
  int indexItem1 = 0;
  // List? categoryItems;
  // List audio = [];
  bool isBackPressed = false;
  // bool isLoading = false;
  final player = AudioPlayer();
  ScrollController controller = ScrollController();

  // Future<void> getCategoryItems(int id, int sliding, List? initAudio) async {
  //   // Uint8List dataVersionUint8 = Uint8List.fromList(dataVersion!.codeUnits);
  //   // FileInfo? fileInfo = await manager.getFileFromCache("version.txt");
  //   // final cachedVersion = fileInfo?.file.readAsStringSync();
  //   // if (cachedVersion != dataVersion) {
  //   isLoading = true;
  //   categoryItems = await apiClient.getCategoryItems(id);
  //   isLoading = false;
  //   notifyListeners();
  //   if (sliding == 1) {
  //     initStateCategorySounds(
  //         // providerOnBoarding.categoriesIdWithItems![widget.categoryIndex],
  //         categoryItems,
  //         initAudio);
  //   }
  //   // await manager.emptyCache();
  //   // await manager.putFile("version.txt", dataVersionUint8);
  //   // boxCategoryItems.add(categoryItems);
  //   audio.clear();
  //   categoryItems?.forEach((e) {
  //     if (e.audio != null && e.audio.isNotEmpty) {
  //       audio.add(linkStart + e.audio[0]['download_link']);
  //     }
  //   });
  //   await Future.wait(audio.map((audioUrl) async {
  //     try {
  //       await manager.downloadFile(audioUrl);
  //     } catch (e) {
  //       print("${e}AAAAAAAAAAAAAAAAAAAAA");
  //     }
  //   }));
  //   // }
  //   notifyListeners();
  // }

  onSwipe(String swipe, int length) {
    if (swipe == "+") {
      indexItem1 >= length ? indexItem1 = 0 : indexItem1++;
    } else if (swipe == "-") {
      indexItem1 <= 0 ? indexItem1 = length : indexItem1--;
    }
    notifyListeners();
  }

  initStateCategorySounds(items, audio) async {
    if (isBackPressed) {
      return;
    }
    final check1 = audio != null && audio.isNotEmpty;
    final check2 = items.length > 0
        ? (items[indexItem1].audio != null &&
            items?[indexItem1].audio.isNotEmpty)
        : false;

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
      audio2 != null
          ? audioSources.add(AudioSource.uri(Uri.file(audio2.file.path)))
          : audioSources.add(AudioSource.asset(AppSounds.audionone));
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
    final check2 = items.length > 0
        ? (items[indexItem1].audio != null &&
            items[indexItem1].audio.isNotEmpty)
        : false;
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
      audio2 != null
          ? audioSources.add(AudioSource.uri(Uri.file(audio2.file.path)))
          : audioSources.add(AudioSource.asset(AppSounds.audionone));
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
