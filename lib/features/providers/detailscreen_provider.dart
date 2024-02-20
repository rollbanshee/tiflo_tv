import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:tiflo_tv/features/domain/api_client/api_client.dart';

class DetailScreenProvider extends ChangeNotifier {
  String? views;
  final box = Hive.box("favourites");
  bool isGetViewsCalled = false;
  int elapsedTime = 0;

  VoidCallback videoListener(controller, id, item) {
    return () async {
      if (controller.value.isPlaying && !isGetViewsCalled) {
        isGetViewsCalled = true;
        await getViews(id, item);
        notifyListeners();
      }
    };
  }

  Future<dynamic> getViews(id, item) async {
    item.views = await apiClient.getViewsIncrement(id);
    notifyListeners();
  }

  Future<void> addFavourite(item) async {
    final int count = box.length;
    box.put(count, item);
    notifyListeners();
  }

  Future<void> deleteFavourite(item) async {
    final key = box.keys.toList().firstWhere(
          (e) => box.get(e).id == item.id,
          orElse: () => null,
        );
    box.delete(key);
    notifyListeners();
  }

  String formatDateTime(dateTimeString, String locale) {
    final inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    final dateTime = inputFormat.parse(dateTimeString);

    final outputFormat = DateFormat("dd MMMM y", locale);
    final formattedDateTime = outputFormat.format(dateTime);

    return formattedDateTime;
  }
}
