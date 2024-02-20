import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:tiflo_tv/features/domain/models/categories/categories.dart';
import 'package:tiflo_tv/features/domain/models/item/item.dart';
import 'package:tiflo_tv/features/providers/categories_provider.dart';
import 'package:tiflo_tv/features/providers/detailscreen_provider.dart';
import 'package:tiflo_tv/features/providers/homescreen_provider.dart';
import 'package:tiflo_tv/features/providers/onboarding_provider.dart';
import 'package:tiflo_tv/features/providers/category_provider.dart';
import 'package:tiflo_tv/ui/splashscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Hive.initFlutter();
  Hive.registerAdapter(CategoriesAdapter());
  Hive.registerAdapter(ItemAdapter());
  await Hive.openBox("favourites");
  runApp(const TifloTV());
}

class TifloTV extends StatelessWidget {
  const TifloTV({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => OnBoardingProvider()),
          ChangeNotifierProvider(create: (context) => HomeScreenProvider()),
          ChangeNotifierProvider(create: (context) => DetailScreenProvider()),
          ChangeNotifierProvider(create: (context) => CategoriesProvider()),
          ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ],
        child: MaterialApp(
          theme: ThemeData(
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            }),
            primaryColor: const Color.fromRGBO(0, 0, 0, 1),
            // highlightColor: Colors.transparent
          ),
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
