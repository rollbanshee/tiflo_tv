// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:tiflo_tv/ui/bottomnavbar.dart';
// import 'package:tiflo_tv/ui/categories/categories.dart';
// import 'package:tiflo_tv/ui/detailscreen/detailscreen.dart';
// import 'package:tiflo_tv/ui/favourites.dart';
// import 'package:tiflo_tv/ui/homescreen/homescreen.dart';
// import 'package:tiflo_tv/ui/infotext.dart';
// import 'package:tiflo_tv/ui/onboarding/onboarding.dart';
// import 'package:tiflo_tv/ui/splashscreen.dart';
// import 'package:tiflo_tv/ui/subcategory/subcategory.dart';

// final _rootNavigatorKey = GlobalKey<NavigatorState>();
// final _sectionNavigatorKey = GlobalKey<NavigatorState>();

// class AppRoutes {
//   // static const String tiflotv = "/tiflo_tv";
//   // static const String splashscreen = "/splashscreen";
//   // static const String onboarding = "/onboarding";
//   // static const String homescreen = "/homescreen";
//   // static const String bottomnavbar = "/bottomnavbar";
//   // static const String favourites = "/favourites";
//   // static const String infotext = "/infotext";
//   // static const String detailscreen = "/detailscreen";
//   // static const String categories = "/categories";
//   // static const String subcategory = "/subcategory";
//   static final GoRouter goRoutes = GoRouter(
//       navigatorKey: _rootNavigatorKey,
//       initialLocation: "/splashscreen",
//       routes: [
//         GoRoute(
//             path: "/splashscreen",
//             builder: (context, state) => const SplashScreen()),
//         GoRoute(
//           path: "/onboarding",
//           builder: (context, state) => const Onboarding(),
//         ),
//         StatefulShellRoute.indexedStack(
//           builder: (context, state, navigationShell) {
//             return BottomNavBar(navigationShell: navigationShell);
//           },
//           branches: [
//             StatefulShellBranch(
//               navigatorKey: _sectionNavigatorKey,
//               routes: <RouteBase>[
//                 GoRoute(
//                     path: "/homescreen",
//                     builder: (context, state) => const HomeScreen(),
//                     routes: <RouteBase>[
//                       GoRoute(
//                         path: "detailscreen",
//                         builder: (context, state) => const DetailScreen(),
//                       )
//                     ])
//               ],
//             ),
//             StatefulShellBranch(routes: <RouteBase>[
//               GoRoute(
//                   path: "/categories",
//                   builder: (context, state) => const Categories(),
//                   routes: <RouteBase>[
//                     GoRoute(
//                         path: "subcategory",
//                         builder: (context, state) => const Subcategory(),
//                         routes: <RouteBase>[
//                           GoRoute(
//                             path: "detailscreen",
//                             builder: (context, state) => const DetailScreen(),
//                           )
//                         ])
//                   ]),
//             ]),
//             StatefulShellBranch(routes: <RouteBase>[
//               GoRoute(
//                   path: "/favourites",
//                   builder: (context, state) => const Favourites(
//                       detailscreenPath: "/favourites/detailscreen"),
//                   routes: <RouteBase>[
//                     GoRoute(
//                       path: "detailscreen",
//                       builder: (context, state) => const DetailScreen(),
//                     )
//                   ]),
//             ]),
//             StatefulShellBranch(routes: <RouteBase>[
//               GoRoute(
//                 path: "/infotext",
//                 builder: (context, state) => const InfoText(),
//               ),
//             ]),
//           ],
//         ),
//       ]);
// }
