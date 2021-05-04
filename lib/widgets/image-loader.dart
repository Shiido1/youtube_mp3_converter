// import 'dart:io';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:mp3_music_converter/utils/string_assets/assets.dart';
//
// // ignore: must_be_immutable, non_constant_identifier_names
// class ImageLoader extends StatelessWidget {
//   ImageLoader(
//       {this.width,
//       this.height,
//       this.path,
//       this.file,
//       this.color,
//       this.dColor,
//       this.isOnline = false,
//       this.onTap,
//       this.fit = BoxFit.contain,
//       Key key})
//       : super(key: key);
//
//   double width;
//   double height;
//   String path;
//   File file;
//   Color color;
//   Color dColor;
//   bool isOnline;
//   Function() onTap;
//   BoxFit fit;
//
//   @override
//   Widget build(BuildContext context) {
//     if (file != null) {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(height / 2),
//         child: Image.file(
//           file,
//           width: width,
//           height: height,
//           fit: fit,
//         ),
//       );
//     } else if (path.contains("http")) {
//       return GestureDetector(
//         onTap: onTap,
//         child: CachedNetworkImage(
//           imageUrl: path,
//           imageBuilder: (context, imageProvider) => Container(
//             width: width,
//             height: height,
//             child: Stack(
//               children: <Widget>[
//                 Container(
//                   width: width,
//                   height: height,
//                   decoration: BoxDecoration(
//                     color: color != null ? color : Colors.transparent,
//                     shape: BoxShape.rectangle,
//                     image: DecorationImage(
//                       image: imageProvider,
//                       fit: fit,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           placeholder: (context, url) => Container(
//             width: width,
//             height: height,
//             child: SvgPicture.asset(AppAssets.logo, fit: fit),
//           ),
//           errorWidget: (context, url, error) => Container(
//             width: width,
//             height: height,
//             child: SvgPicture.asset(AppAssets.logo, fit: fit),
//           ),
//         ),
//       );
//     } else {
//       return Container(
//         width: width,
//         height: height,
//         child: GestureDetector(
//           onTap: onTap,
//           child: CircleAvatar(
//             backgroundColor: color != null ? color : Colors.transparent,
//             child: path.contains(".svg")
//                 ? SvgPicture.asset(
//                     path,
//                     width: width,
//                     height: height,
//                     color: dColor,
//                     fit: fit,
//                   )
//                 : Image.asset(
//                     path,
//                     width: width,
//                     height: height,
//                     fit: fit,
//                   ),
//           ),
//         ),
//       );
//     }
//   }
// }
//
// // ignore: non_constant_identifier_names
// Widget CircleImage(
//     {double width,
//     double height,
//     String path,
//     File file,
//     Color color,
//     Color dColor,
//     bool isOnline = false,
//     Function() onTap}) {
//   if (file != null) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(height / 2),
//       child: Image.file(
//         file,
//         width: width,
//         height: height,
//         fit: BoxFit.fill,
//       ),
//     );
//   } else if (path.contains("http")) {
//     return GestureDetector(
//       onTap: onTap,
//       child: CachedNetworkImage(
//         imageUrl: path,
//         imageBuilder: (context, imageProvider) => Container(
//           width: width,
//           height: height,
//           child: Stack(
//             children: <Widget>[
//               Container(
//                 width: width,
//                 height: height,
//                 decoration: BoxDecoration(
//                   color: color != null ? color : Colors.transparent,
//                   shape: BoxShape.circle,
//                   image: DecorationImage(
//                     image: imageProvider,
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//               ),
//               Visibility(
//                 visible: isOnline,
//                 child: Align(
//                     alignment: Alignment.bottomRight,
//                     child: Container(
//                         width: width > 100 ? 30 : 20,
//                         height: height > 100 ? 30 : 20,
//                         decoration: BoxDecoration(
//                             color: Colors.green,
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: Colors.white,
//                               //                   <--- border color
//                               width: 3.0,
//                             )))),
//               )
//             ],
//           ),
//         ),
//         placeholder: (context, url) => Container(
//           width: width,
//           height: height,
//           child: SvgPicture.asset(AppAssets.logo),
//         ),
//         errorWidget: (context, url, error) => Container(
//           width: width,
//           height: height,
//           child: SvgPicture.asset(AppAssets.logo),
//         ),
//       ),
//     );
//   } else {
//     return Container(
//       width: width,
//       height: height,
//       child: GestureDetector(
//         onTap: onTap,
//         child: CircleAvatar(
//           backgroundColor: color != null ? color : Colors.transparent,
//           child: path.contains(".svg")
//               ? SvgPicture.asset(
//                   path,
//                   width: width,
//                   color: dColor,
//                   height: height,
//                 )
//               : Image.asset(
//                   path,
//                   width: width,
//                   height: height,
//                 ),
//         ),
//       ),
//     );
//   }
// }
