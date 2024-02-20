import 'dart:io';
import 'package:dio/dio.dart';
import 'package:tiflo_tv/features/domain/models/categories/categories.dart';

final apiClient = ApiClient();

class ApiClient {
  final dio = Dio();
  Future<dynamic> getData() async {
    const url = 'https://abasoft.az/tiflo_tv/get_categories_items.php';
    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );
      final responseData = response.data;
      final data = responseData
          .map((e) => Categories.fromJson(e as Map<String, dynamic>))
          .toList();

      return data;
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<dynamic> getViewsIncrement(id) async {
    const url = 'https://abasoft.az/tiflo_tv/post_views_increment.php';
    try {
      final response = await dio.get(url, queryParameters: {"id": id});
      final responseData = response.data;
      return int.parse(responseData);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
