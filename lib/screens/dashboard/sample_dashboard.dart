import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/bottom_navigation/my_library.dart';
import 'package:mp3_music_converter/bottom_navigation/playlist.dart';
import 'package:mp3_music_converter/bottom_navigation/search.dart';
import 'package:mp3_music_converter/bottom_navigation/setting.dart';
import 'package:mp3_music_converter/screens/converter/converter_screen.dart';
import 'package:mp3_music_converter/screens/dashboard/dashboard.dart';
import 'package:mp3_music_converter/screens/playlist/test_container.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class Sample extends StatefulWidget {
  int index;
  @override
  _SampleState createState() => _SampleState();
}

class _SampleState extends State<Sample> {
  int _currentIndex = 0;

  List<Widget> _screens = [
    DashBoard(),
    PlayList(),
    Library(),
    Search(),
    Setting()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      // Container(
      //   color: AppColor.background,
      //   child: SingleChildScrollView(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.end,
      //       children: [
      //         Column(children: [
      //           Stack(
      //             children: [
      //               Image.asset('assets/rect.png'),
      //               Column(
      //                 children: [
      //                   SizedBox(height: 45),
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Image.asset(AppAssets.logo),
      //                       SizedBox(
      //                         width: 20,
      //                       ),
      //                       Column(
      //                         mainAxisAlignment: MainAxisAlignment.center,
      //                         children: [
      //                           ClipOval(
      //                             child: Image.asset('assets/burna.png'),
      //                           ),
      //                           Padding(
      //                             padding: const EdgeInsets.only(top: 5.0),
      //                             child: Text(
      //                               'Profile',
      //                               style: TextStyle(
      //                                   fontSize: 17,
      //                                   color: AppColor.white,
      //                                   fontWeight: FontWeight.w500,
      //                                   fontFamily: 'Montserrat-Thin'),
      //                             ),
      //                           ),
      //                           SizedBox(
      //                             height: 160,
      //                           ),
      //                         ],
      //                       )
      //                     ],
      //                   ),
      //                 ],
      //               ),
      //             ],
      //           ),
      //         ]),
      //         Column(
      //           mainAxisAlignment: MainAxisAlignment.end,
      //           children: [
      //             InkWell(
      //               onTap: () {
      //                 res1();
      //                 Navigator.pushReplacement(
      //                   context,
      //                   MaterialPageRoute(
      //                       builder: (context) => ConverterScreen()),
      //                 );
      //               },
      //               child: Container(
      //                   margin: converterRes != true
      //                       ? EdgeInsets.only(right: 120)
      //                       : EdgeInsets.only(right: 90),
      //                   decoration: BoxDecoration(
      //                       color: converterRes != true
      //                           ? AppColor.transparent
      //                           : Colors.redAccent[100].withOpacity(0.8),
      //                       border: Border.all(
      //                         color: converterRes != true
      //                             ? AppColor.white
      //                             : Colors.redAccent[100].withOpacity(0.8),
      //                       ),
      //                       borderRadius: BorderRadius.only(
      //                           topRight: Radius.circular(10),
      //                           bottomRight: Radius.circular(10))),
      //                   child: Padding(
      //                     padding: const EdgeInsets.all(13.0),
      //                     child: Row(
      //                       children: [
      //                         SvgPicture.asset(
      //                           'assets/svg/mp_file.svg',
      //                           color: converterRes != true
      //                               ? AppColor.white
      //                               : AppColor.black,
      //                           height: 24,
      //                           width: 25,
      //                         ),
      //                         SizedBox(width: 10),
      //                         TextViewWidget(
      //                           color: converterRes != true
      //                               ? AppColor.white
      //                               : AppColor.black,
      //                           text: 'Converter',
      //                           textSize: 22,
      //                           fontWeight: FontWeight.w500,
      //                           fontFamily: 'Montserrat',
      //                         ),
      //                       ],
      //                     ),
      //                   )),
      //             ),
      //             SizedBox(
      //               height: 20,
      //             ),
      //             InkWell(
      //               onTap: () {
      //                 res2();
      //               },
      //               child: Container(
      //                 margin: musicRes != true
      //                     ? EdgeInsets.only(right: 120)
      //                     : EdgeInsets.only(right: 90),
      //                 decoration: BoxDecoration(
      //                     // color: Colors.redAccent[100].withOpacity(0.8),
      //                     color: musicRes != true
      //                         ? AppColor.transparent
      //                         : Colors.redAccent[100].withOpacity(0.8),
      //                     border: Border.all(
      //                       color: musicRes != true
      //                           ? AppColor.white
      //                           : Colors.redAccent[100].withOpacity(0.8),
      //                     ),
      //                     borderRadius: BorderRadius.only(
      //                         topRight: Radius.circular(10),
      //                         bottomRight: Radius.circular(10))),
      //                 child: Padding(
      //                   padding: const EdgeInsets.all(13),
      //                   child: Row(
      //                     children: [
      //                       SvgPicture.asset(
      //                         'assets/svg/radio_wave.svg',
      //                         color: musicRes != true
      //                             ? AppColor.white
      //                             : AppColor.black,
      //                         height: 24,
      //                         width: 25,
      //                       ),
      //                       SizedBox(width: 10),
      //                       Expanded(
      //                         child: TextViewWidget(
      //                           color: musicRes != true
      //                               ? AppColor.white
      //                               : AppColor.black,
      //                           text: 'Create your Music',
      //                           textSize: 22,
      //                           fontWeight: FontWeight.w500,
      //                           fontFamily: 'Montserrat',
      //                           // onTapCallBack: () => res(),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             SizedBox(
      //               height: 20,
      //             ),
      //             InkWell(
      //               onTap: () {
      //                 res3();
      //               },
      //               child: Container(
      //                 margin: radioRes != true
      //                     ? EdgeInsets.only(right: 120)
      //                     : EdgeInsets.only(right: 90),
      //                 decoration: BoxDecoration(
      //                     color: radioRes != true
      //                         ? AppColor.transparent
      //                         : Colors.redAccent[100].withOpacity(0.8),
      //                     border: Border.all(
      //                       color: radioRes != true
      //                           ? AppColor.white
      //                           : Colors.redAccent[100].withOpacity(0.8),
      //                     ),
      //                     borderRadius: BorderRadius.only(
      //                         topRight: Radius.circular(10),
      //                         bottomRight: Radius.circular(10))),
      //                 child: Padding(
      //                   padding: const EdgeInsets.all(13),
      //                   child: Row(
      //                     children: [
      //                       SvgPicture.asset(
      //                         'assets/svg/radio.svg',
      //                         color: radioRes != true
      //                             ? AppColor.white
      //                             : AppColor.black,
      //                         height: 24,
      //                         width: 25,
      //                       ),
      //                       SizedBox(width: 10),
      //                       Expanded(
      //                         child: TextViewWidget(
      //                           color: radioRes != true
      //                               ? AppColor.white
      //                               : AppColor.black,
      //                           text: 'Radio World Wide',
      //                           textSize: 22,
      //                           fontWeight: FontWeight.w500,
      //                           fontFamily: 'Montserrat',
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             SizedBox(
      //               height: 20,
      //             ),
      //             InkWell(
      //               onTap: () {
      //                 res4();
      //               },
      //               child: Container(
      //                 margin: djRes != true
      //                     ? EdgeInsets.only(right: 120)
      //                     : EdgeInsets.only(right: 90),
      //                 decoration: BoxDecoration(
      //                     color: djRes != true
      //                         ? AppColor.transparent
      //                         : Colors.redAccent[100].withOpacity(0.8),
      //                     border: Border.all(
      //                       color: djRes != true
      //                           ? AppColor.white
      //                           : Colors.redAccent[100].withOpacity(0.8),
      //                     ),
      //                     borderRadius: BorderRadius.only(
      //                         topRight: Radius.circular(10),
      //                         bottomRight: Radius.circular(10))),
      //                 child: Padding(
      //                   padding: const EdgeInsets.all(13),
      //                   child: Row(
      //                     children: [
      //                       SvgPicture.asset(
      //                         'assets/svg/dj_mixer.svg',
      //                         color: djRes != true
      //                             ? AppColor.white
      //                             : AppColor.black,
      //                         height: 24,
      //                         width: 25,
      //                       ),
      //                       SizedBox(
      //                         width: 10,
      //                       ),
      //                       TextViewWidget(
      //                         color: djRes != true
      //                             ? AppColor.white
      //                             : AppColor.black,
      //                         text: 'Disk Jockey',
      //                         textSize: 22,
      //                         fontWeight: FontWeight.w500,
      //                         fontFamily: 'Montserrat',
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             SizedBox(
      //               height: 20,
      //             ),
      //             InkWell(
      //               onTap: () => res5(),
      //               child: Container(
      //                 margin: planRes != true
      //                     ? EdgeInsets.only(right: 120)
      //                     : EdgeInsets.only(right: 90),
      //                 decoration: BoxDecoration(
      //                     color: planRes != true
      //                         ? AppColor.transparent
      //                         : Colors.redAccent[100].withOpacity(0.8),
      //                     border: Border.all(
      //                       color: planRes != true
      //                           ? AppColor.white
      //                           : Colors.redAccent[100].withOpacity(0.8),
      //                     ),
      //                     borderRadius: BorderRadius.only(
      //                         topRight: Radius.circular(10),
      //                         bottomRight: Radius.circular(10))),
      //                 child: Padding(
      //                   padding: const EdgeInsets.all(13),
      //                   child: Row(
      //                     children: [
      //                       SvgPicture.asset(
      //                         'assets/svg/plan.svg',
      //                         color: planRes != true
      //                             ? AppColor.white
      //                             : AppColor.black,
      //                         height: 24,
      //                         width: 25,
      //                       ),
      //                       SizedBox(width: 10),
      //                       TextViewWidget(
      //                         fontFamily: 'Montserrat',
      //                         color: planRes != true
      //                             ? AppColor.white
      //                             : AppColor.black,
      //                         text: 'Plan',
      //                         textSize: 22,
      //                         fontWeight: FontWeight.w500,
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             SizedBox(height: 30),
      //             Container(
      //               decoration: BoxDecoration(color: Colors.black),
      //               child: Padding(
      //                 padding: const EdgeInsets.all(10),
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                   children: [
      //                     Image.asset(
      //                       AppAssets.image1,
      //                       height: 80,
      //                     ),
      //                     Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         TextViewWidget(
      //                           text: 'kofi',
      //                           color: AppColor.white,
      //                           textSize: 16,
      //                         ),
      //                         TextViewWidget(
      //                           text: 'Came Up',
      //                           color: AppColor.white,
      //                           textSize: 20,
      //                         ),
      //                         SizedBox(
      //                           height: 8,
      //                         ),
      //                         SvgPicture.asset(AppAssets.line),
      //                       ],
      //                     ),
      //                     SizedBox(
      //                       width: 10,
      //                     ),
      //                     SvgPicture.asset(AppAssets.play,
      //                         height: 50, width: 80)
      //                   ],
      //                 ),
      //               ),
      //             ),
      //             Divider(color: AppColor.white, height: 0.1),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: AppColor.black,
        selectedItemColor: AppColor.bottomRed,
        unselectedItemColor: AppColor.white,
        selectedLabelStyle: Theme.of(context).textTheme.caption,
        elevation: 5,
        unselectedLabelStyle: Theme.of(context).textTheme.caption,
        unselectedFontSize: 30,
        onTap: (value) {
          setState(() => _currentIndex = value);
        },
        items: [
          BottomNavigationBarItem(
            label: 'Menu',
            icon: Icon(
              Icons.apps_outlined,
              color: _currentIndex == 0 ? AppColor.bottomRed : AppColor.white,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Playlist',
            icon: SvgPicture.asset(
              AppAssets.library,
              color: _currentIndex == 1 ? AppColor.bottomRed : AppColor.white,
            ),
          ),
          BottomNavigationBarItem(
            label: 'My Library',
            icon: SvgPicture.asset(
              AppAssets.playlist,
              height: 22,
              color: _currentIndex == 2 ? AppColor.bottomRed : AppColor.white,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Search',
            icon: SvgPicture.asset(
              AppAssets.search,
              color: _currentIndex == 3 ? AppColor.bottomRed : AppColor.white,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Setting',
            icon: SvgPicture.asset(
              AppAssets.setting,
              color: _currentIndex == 4 ? AppColor.bottomRed : AppColor.white,
            ),
          ),
        ],
      ),
    );
  }
}
