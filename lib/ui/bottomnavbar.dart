import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tiflo_tv/features/resources/resources.dart';
import 'package:tiflo_tv/ui/categories/categories.dart';
import 'package:tiflo_tv/ui/favourites.dart';
import 'package:tiflo_tv/ui/homescreen/homescreen.dart';
import 'package:tiflo_tv/ui/infotext.dart';

// class BottomNavBar extends StatelessWidget {
//   const BottomNavBar({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return PersistentTabView(
//       context,
//       controller: _controller,
//       screens: _buildScreens(),
//       items: _navBarsItems(),
//       navBarStyle: NavBarStyle.simple,
//       // navBarHeight: 60.h,
//       hideNavigationBar: false,
//       popAllScreensOnTapOfSelectedTab: true,
//       screenTransitionAnimation: const ScreenTransitionAnimation(
//         animateTabTransition: true,
//         curve: Curves.ease,
//         duration: Duration(milliseconds: 500),
//       ),
//     );
//   }
// }

// final PersistentTabController _controller =
//     PersistentTabController(initialIndex: 0);

// List<Widget> _buildScreens() {
//   return [
//     const HomeScreen(),
//     const Categories(),
//     const Favourites(),
//     const InfoText()
//   ];
// }

// List<PersistentBottomNavBarItem> _navBarsItems() {
//   return [
//     PersistentBottomNavBarItem(
//       icon: SvgPicture.asset(
//         AppSvgs.bottomNavBarHome,
//         color: const Color.fromRGBO(239, 81, 64, 1),
//       ),
//       title: "Ana səhifə",
//       textStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
//     ),
//     PersistentBottomNavBarItem(
//       icon: SvgPicture.asset(
//         AppSvgs.bottomNavBarCategory,
//         // ignore: deprecated_member_use
//         color: const Color.fromRGBO(239, 81, 64, 1),
//       ),
//       title: "Kateqoriyalar",
//     ),
//     PersistentBottomNavBarItem(
//       icon: SvgPicture.asset(AppSvgs.bottomNavBarFavourites,
//           color: const Color.fromRGBO(239, 81, 64, 1)),
//       title: "Seçilmişlər",
//     ),
//     PersistentBottomNavBarItem(
//       icon: SvgPicture.asset(AppSvgs.bottomNavBarInfo,
//           color: const Color.fromRGBO(239, 81, 64, 1)),
//       title: "Haqqımızda",
//     ),
//   ];
// }

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  final List<Widget> _widgets = const [
    HomeScreen(),
    Categories(),
    Favourites(),
    InfoText()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgets[_currentIndex],
      ),
      bottomNavigationBar: SizedBox(
        height: 60.h,
        child: Theme(
          data: ThemeData(highlightColor: Colors.transparent),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            unselectedItemColor: const Color.fromRGBO(180, 185, 201, 1),
            selectedItemColor: const Color.fromRGBO(239, 81, 64, 1),
            selectedFontSize: 11.sp,
            unselectedFontSize: 11.sp,
            currentIndex: _currentIndex,
            onTap: (value) => setState(() {
              _currentIndex = value;
            }),
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(AppSvgs.bottomNavBarHome),
                label: "Ana səhifə",
                activeIcon: SvgPicture.asset(
                  AppSvgs.bottomNavBarHome,
                  // ignore: deprecated_member_use
                  color: const Color.fromRGBO(239, 81, 64, 1),
                ),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(AppSvgs.bottomNavBarCategory),
                label: "Kateqoriyalar",
                activeIcon: SvgPicture.asset(
                  AppSvgs.bottomNavBarCategory,
                  // ignore: deprecated_member_use
                  color: const Color.fromRGBO(239, 81, 64, 1),
                ),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(AppSvgs.bottomNavBarFavourites),
                label: "Seçilmişlər",
                activeIcon: SvgPicture.asset(
                  AppSvgs.bottomNavBarFavourites,
                  // ignore: deprecated_member_use
                  color: const Color.fromRGBO(239, 81, 64, 1),
                ),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(AppSvgs.bottomNavBarInfo),
                label: "Haqqımızda",
                activeIcon: SvgPicture.asset(
                  AppSvgs.bottomNavBarInfo,
                  // ignore: deprecated_member_use
                  color: const Color.fromRGBO(239, 81, 64, 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class CupertinoBottomNavBar extends StatefulWidget {
//   const CupertinoBottomNavBar({super.key});

//   @override
//   State<CupertinoBottomNavBar> createState() => _CupertinoBottomNavBarState();
// }

// class _CupertinoBottomNavBarState extends State<CupertinoBottomNavBar> {
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoTabScaffold(
//         tabBar: CupertinoTabBar(
//             activeColor: const Color.fromRGBO(239, 81, 64, 1),
//             inactiveColor: const Color.fromRGBO(180, 185, 201, 1),
//             iconSize: 11.sp,
//             height: 60.h,
//             // showUnselectedLabels: true,
//             // unselectedItemColor: const Color.fromRGBO(180, 185, 201, 1),
//             // selectedItemColor: const Color.fromRGBO(239, 81, 64, 1),
//             // selectedFontSize: 11.sp,
//             // unselectedFontSize: 11.sp,
//             items: <BottomNavigationBarItem>[
//               BottomNavigationBarItem(
//                 icon: SvgPicture.asset(AppSvgs.bottomNavBarHome),
//                 label: "Ana səhifə",
//                 activeIcon: SvgPicture.asset(
//                   AppSvgs.bottomNavBarHome,
//                   // ignore: deprecated_member_use
//                   color: const Color.fromRGBO(239, 81, 64, 1),
//                 ),
//               ),
//               BottomNavigationBarItem(
//                 icon: SvgPicture.asset(AppSvgs.bottomNavBarCategory),
//                 label: "Kateqoriyalar",
//                 activeIcon: SvgPicture.asset(
//                   AppSvgs.bottomNavBarCategory,
//                   // ignore: deprecated_member_use
//                   color: const Color.fromRGBO(239, 81, 64, 1),
//                 ),
//               ),
//               BottomNavigationBarItem(
//                 icon: SvgPicture.asset(AppSvgs.bottomNavBarFavourites),
//                 label: "Seçilmişlər",
//                 activeIcon: SvgPicture.asset(
//                   AppSvgs.bottomNavBarFavourites,
//                   // ignore: deprecated_member_use
//                   color: const Color.fromRGBO(239, 81, 64, 1),
//                 ),
//               ),
//               BottomNavigationBarItem(
//                 icon: SvgPicture.asset(AppSvgs.bottomNavBarInfo),
//                 label: "Haqqımızda",
//                 activeIcon: SvgPicture.asset(
//                   AppSvgs.bottomNavBarInfo,
//                   // ignore: deprecated_member_use
//                   color: const Color.fromRGBO(239, 81, 64, 1),
//                 ),
//               ),
//             ]),
//         tabBuilder: (context, index) {
//           switch (index) {
//             case 0:
//               return CupertinoTabView(builder: (context) {
//                 return const CupertinoPageScaffold(child: HomeScreen());
//               });
//             case 1:
//               return CupertinoTabView(builder: (context) {
//                 return const CupertinoPageScaffold(child: Categories());
//               });
//             case 2:
//               return CupertinoTabView(builder: (context) {
//                 return const CupertinoPageScaffold(child: Favourites());
//               });
//             case 3:
//               return CupertinoTabView(builder: (context) {
//                 return const CupertinoPageScaffold(
//                     // navigationBar: CupertinoNavigationBar(),
//                     child: InfoText());
//               });
//           }

//           return Container();
//         });
//   }
// }
