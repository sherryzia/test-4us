import "package:candid/constants/app_colors.dart";
import "package:candid/constants/app_images.dart";
import "package:candid/view/screens/explore/explore.dart";
import "package:candid/view/screens/matches/matches.dart";
import "package:candid/view/screens/home/home.dart";
import "package:candid/view/screens/messages/messages.dart";
import "package:candid/view/screens/upload_video/upload_video.dart";
import "package:candid/view/widget/my_text_widget.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import 'dart:io';

// // ignore: must_be_immutable
// class BottomNavBar extends StatefulWidget {
//   BottomNavBar({
//     this.currentIndex = 0,
//   });

//   int? currentIndex;

//   @override
//   _BottomNavBarState createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   void _onTap(int index) {
//     setState(() {
//       widget.currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> _items = [
//       {
//         'icon': Assets.imagesHome,
//         'iconA': Assets.imagesHomeA,
//         'label': 'Home',
//       },
//       {
//         'icon': Assets.imagesExplore,
//         'iconA': Assets.imagesExploreA,
//         'label': 'Explore',
//       },
//       {
//         'icon': Assets.imagesVideo,
//         'iconA': Assets.imagesVideoA,
//         'label': 'Videos',
//       },
//       {
//         'icon': Assets.imagesMatches,
//         'iconA': Assets.imagesMatchesA,
//         'label': 'Matches',
//       },
//       {
//         'icon': Assets.imagesChats,
//         'iconA': Assets.imagesChatsA,
//         'label': 'Chats',
//       },
//     ];
//     final _screens = [
//       Home(),
//       Explore(),
//       UploadVideo(),
//       Matches(),
//       Messages(),
//     ];

//     return Scaffold(
//       extendBody: true,
//       extendBodyBehindAppBar: true,
//       body: _screens[widget.currentIndex!],
//       bottomNavigationBar: Container(
//         height: 65,
//         width: Get.width,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(16),
//           ),
//           boxShadow: [
//             BoxShadow(
//               offset: Offset(0, -4),
//               blurRadius: 12,
//               color: kBlackColor.withOpacity(0.26),
//             ),
//           ],
//           gradient: LinearGradient(
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//             colors: [
//               kSecondaryColor,
//               kPurpleColor,
//             ],
//           ),
//         ),
//         child: BottomNavigationBar(
//           elevation: 0,
//           type: BottomNavigationBarType.fixed,
//           selectedLabelStyle: TextStyle(fontSize: 10, color: kPrimaryColor),
//           unselectedLabelStyle: TextStyle(fontSize: 10, color: kPrimaryColor),
//           selectedFontSize: 10,
//           unselectedFontSize: 10,
//           showSelectedLabels: true,
//           showUnselectedLabels: true,
//           backgroundColor: Colors.transparent,
//           selectedItemColor: kPrimaryColor,
//           unselectedItemColor: kPrimaryColor,
//           currentIndex: widget.currentIndex!,
//           onTap: (index) => _onTap(index),
//           items: List.generate(_items.length, (index) {
//             var data = _items[index];
//             return BottomNavigationBarItem(
//               icon: Padding(
//                 padding: const EdgeInsets.only(bottom: 4),
//                 child: Image.asset(
//                   index == 2
//                       ? Assets.imagesNewVideo
//                       : widget.currentIndex == index
//                           ? _items[index]['iconA']
//                           : _items[index]['icon'],
//                   height: index == 2 ? 32 : 22,
//                   color: widget.currentIndex == index
//                       ? kPrimaryColor
//                       : kPrimaryColor.withOpacity(0.8),
//                 ),
//               ),
//               label: index == 2 ? '' : data['label'].toString().tr,
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }

// ignore: must_be_immutable
class BottomNavBar extends StatefulWidget {
  BottomNavBar({
    this.currentIndex = 0,
  });

  int? currentIndex;
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  void _onTap(int index) {
    setState(() {
      widget.currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _items = [
      {
        'icon': Assets.imagesHome,
        'iconA': Assets.imagesHomeA,
        'label': 'Home',
      },
      {
        'icon': Assets.imagesExplore,
        'iconA': Assets.imagesExploreA,
        'label': 'Explore',
      },
      {
        'icon': Assets.imagesVideo,
        'iconA': Assets.imagesVideoA,
        'label': 'Videos',
      },
      {
        'icon': Assets.imagesMatches,
        'iconA': Assets.imagesMatchesA,
        'label': 'Matches',
      },
      {
        'icon': Assets.imagesChats,
        'iconA': Assets.imagesChatsA,
        'label': 'Chats',
      },
    ];
    final _screens = [
      Home(),
      Explore(),
      UploadVideo(),
      Matches(),
      Messages(),
    ];
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          _screens[widget.currentIndex!],
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 65,
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, -4),
                    blurRadius: 12,
                    color: kBlackColor.withOpacity(0.26),
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    kSecondaryColor,
                    kPurpleColor,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  _items.length,
                  (index) {
                    return InkWell(
                      onTap: () => _onTap(index),
                      borderRadius: BorderRadius.circular(100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            index == 2
                                ? Assets.imagesNewVideo
                                : widget.currentIndex == index
                                    ? _items[index]['iconA']
                                    : _items[index]['icon'],
                            height: index == 2 ? 32 : 22,
                            color: widget.currentIndex == index
                                ? kPrimaryColor
                                : kPrimaryColor.withOpacity(0.8),
                          ),
                          if (index != 2)
                            MyText(
                              paddingTop: 4,
                              color: kPrimaryColor,
                              text: _items[index]['label'],
                              size: 10,
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
