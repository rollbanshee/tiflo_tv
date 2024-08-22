// ignore_for_file: avoid_print, depend_on_referenced_packages
import 'package:html/parser.dart';
import 'package:dio/dio.dart';
import 'package:tiflo_tv/features/domain/models/about_us/about_us.dart';
import 'package:tiflo_tv/features/domain/models/categories/categories.dart';
import 'package:tiflo_tv/features/domain/models/home/home.dart';
import 'package:tiflo_tv/features/domain/models/items/items.dart';

final apiClient = ApiClient();

class ApiClient {
  final dio = Dio();

  Future<dynamic> getHome(Function(double) updateLoading) async {
    const url = 'https://tiflotv.az/api/home';
    try {
      final response = await dio.get(
        url,
        options: Options(headers: {
          "key": "Accept",
          "value": "application/json",
          "type": "text"
        }),
        onReceiveProgress: (count, total) => updateLoading((count / total) / 5),
      );
      final Map responseData = response.data;
      var data = responseData['data'] as Map<String, dynamic>;
      final version = {'version': responseData['version']};
      data = {...data, ...version};
      final homeData = Home.fromJson(data);
      return homeData;
    } catch (error) {
      print(error);
    }
  }

  Future<dynamic> getAllItems() async {
    const url = 'https://tiflotv.az/api/lessons';
    try {
      final response = await dio.get(url,
          options: Options(headers: {
            "key": "Accept",
            "value": "application/json",
            "type": "text"
          }));
      final responseData = response.data;
      final lessons = responseData['data'];

      final data = lessons
          .map((e) => Items.fromJson(e as Map<String, dynamic>))
          .toList();
      return data;
    } catch (error) {
      print(error);
    }
  }

  Future<List<Categories>> getCategories(Function(double) updateLoading) async {
    const url = 'https://tiflotv.az/api/categories';
    try {
      final response = await dio.get(url,
          options: Options(headers: {
            "key": "Accept",
            "value": "application/json",
            "type": "text"
          }),
          onReceiveProgress: (count, total) =>
              updateLoading((count / total) / 5));
      final responseData = response.data;

      final List categories = responseData['data']['categories'];
      final List<Categories> data = categories
          .map((e) => Categories.fromJson(e as Map<String, dynamic>))
          .toList();
      return data;
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<dynamic> getCategoryItems(id) async {
    final url = 'https://tiflotv.az/api/categories/$id';
    try {
      final response = await dio.get(url,
          options: Options(headers: {
            "key": "Accept",
            "value": "application/json",
            "type": "text"
          }));
      final responseData = response.data;
      final items = responseData['data'];
      final data =
          items.map((e) => Items.fromJson(e as Map<String, dynamic>)).toList();
      return data;
    } catch (error) {
      print(error);
    }
  }

  Future<dynamic> getInfo() async {
    const url = 'https://tiflotv.az/api/about';
    try {
      final response = await dio.get(url,
          options: Options(
            headers: {
              "key": "Accept",
              "value": "application/json",
              "type": "text"
            },
          ));
      final responseData = response.data;
      String? firstText = responseData['data']['first_section_text'];
      firstText = parse(firstText).body?.text;
      String? secondText = responseData['data']['second_section_text'];
      secondText = parse(secondText).body?.text;
      final int version = responseData['version'];
      final info = {
        'first_section_text': firstText,
        'second_section_text': secondText,
        'version': version
      };
      final aboutUs = AboutUs.fromJson(info as Map<String, dynamic>);
      return aboutUs;
    } catch (error) {
      print(error);
    }
  }

  Future<dynamic> postViewIncrement(id) async {
    const url = 'https://tiflotv.az/api/increase-view-count';
    try {
      final response = await dio.post(url,
          options: Options(
            headers: {
              "key": "Accept",
              "value": "application/json",
              "type": "text"
            },
          ),
          queryParameters: {'id': id});

      return response.data['data']['view_count'];
    } catch (error) {
      print(error);
    }
  }
}





  // Future<dynamic> getData() async {
  //   const url = 'http://abasoft.az/tiflo_tv/get_categories_items.php';
  //   try {
  //     final response = await dio.get(
  //       url,
  //       options: Options(
  //         headers: {
  //           HttpHeaders.contentTypeHeader: "application/json",
  //         },
  //       ),
  //     );
  //     final responseData = response.data;
  //     final data = responseData
  //         .map((e) => Categories.fromJson(e as Map<String, dynamic>))
  //         .toList();

  //     return data;
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  // Future<dynamic> getViewsIncrement(id) async {
  //   const url = 'https://abasoft.az/tiflo_tv/post_views_increment.php';
  //   try {
  //     final response = await dio.get(url, queryParameters: {"id": id});
  //     final responseData = response.data;
  //     return int.parse(responseData);
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  // Future<dynamic> getUpdateVersion() async {
  //   const url = 'https://abasoft.az/tiflo_tv/get_update_version.php';
  //   try {
  //     final response = await dio.get(url);
  //     final responseData = response.data;
  //     return responseData;
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  // Future<dynamic> getHome() async {
  //   const url = 'https://tiflotv.az/api/home';
  //   try {
  //     final response = await dio.get(url);
  //     final responseData = response.data;
  //     return responseData;
  //   } catch (error) {
  //     print(error);
  //   }
  // }