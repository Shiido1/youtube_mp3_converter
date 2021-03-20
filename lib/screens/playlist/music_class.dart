// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:mp3_music_converter/bottom_navigation/my_library.dart';
// import 'package:mp3_music_converter/bottom_navigation/playlist.dart';
// import 'package:mp3_music_converter/bottom_navigation/search.dart';
// import 'package:mp3_music_converter/bottom_navigation/setting.dart';
// import 'package:mp3_music_converter/database/model/log.dart';
// import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
// import 'package:mp3_music_converter/utils/color_assets/color.dart';
// import 'package:mp3_music_converter/utils/helper/instances.dart';
// import 'package:mp3_music_converter/utils/string_assets/assets.dart';
// import 'package:provider/provider.dart';

// import 'music_screen.dart';

// class MusicClass extends StatefulWidget {
//   int index;

//   MusicClass({@required this.index});
//   @override
//   _MusicClassState createState() => _MusicClassState(currentIndex: index);
// }

// class _MusicClassState extends State<MusicClass> {
//   int currentIndex = 0;

//   _MusicClassState({@required this.currentIndex});

//   List<Widget> _screens = [
//     MusicScreen(),
//     PlayList(),
//     Library(),
//     Search(),
//     Setting(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: currentIndex,
//         backgroundColor: AppColor.black,
//         selectedItemColor: AppColor.bottomRed,
//         unselectedItemColor: AppColor.white,
//         selectedLabelStyle: Theme.of(context).textTheme.caption,
//         elevation: 5,
//         unselectedLabelStyle: Theme.of(context).textTheme.caption,
//         unselectedFontSize: 30,
//         onTap: (value) {
//           setState(() => currentIndex = value);
//         },
//         items: [
//           BottomNavigationBarItem(
//             label: 'Menu',
//             icon: Icon(
//               Icons.apps_outlined,
//               color: currentIndex == 0 ? AppColor.bottomRed : AppColor.white,
//             ),
//           ),
//           BottomNavigationBarItem(
//             label: 'Playlist',
//             icon: SvgPicture.asset(
//               AppAssets.library,
//               color: currentIndex == 1 ? AppColor.bottomRed : AppColor.white,
//             ),
//           ),
//           BottomNavigationBarItem(
//             label: 'My Library',
//             icon: SvgPicture.asset(
//               AppAssets.playlist,
//               color: currentIndex == 2 ? AppColor.bottomRed : AppColor.white,
//             ),
//           ),
//           BottomNavigationBarItem(
//             label: 'Search',
//             icon: SvgPicture.asset(
//               AppAssets.search,
//               color: currentIndex == 3 ? AppColor.bottomRed : AppColor.white,
//             ),
//           ),
//           BottomNavigationBarItem(
//             label: 'Setting',
//             icon: SvgPicture.asset(
//               AppAssets.setting,
//               color: currentIndex == 4 ? AppColor.bottomRed : AppColor.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
