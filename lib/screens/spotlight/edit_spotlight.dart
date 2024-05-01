import 'dart:io';



import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:glassmorphism/glassmorphism.dart';
//import 'package:media_gallery2/media_gallery2.dart' as mg;
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/widgets.dart';

class EditSpotlightPage extends StatefulWidget {
  final dynamic spotlight;

  const EditSpotlightPage({Key? key, required this.spotlight})
      : super(key: key);

  @override
  State<EditSpotlightPage> createState() => _EditSpotlightPageState();
}

class _EditSpotlightPageState extends State<EditSpotlightPage> {
  late File spotlightFile;
  bool loaded = false;
  int editIndex = 0;

  @override
  void initState() {
    super.initState();
    setup();
  }

  Future<void> setup() async {
    spotlightFile = File("path");//(await widget.spotlight.getFile())!;
    setState(() => loaded = true);
  }

  // Widget getBottomContent() {
  //   if (editIndex == 0) {
  //     return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
  //       BottomNavItem(
  //         //iconData: Boxicons.bx_trim,
  //         text: "Trim",
  //         height: 70.h,
  //         selected: false,
  //         color: theme,
  //         onSelect: () {},
  //       ),
  //       BottomNavItem(
  //         //iconData: Boxicons.bxs_music,
  //         text: "Music",
  //         height: 70.h,
  //         selected: false,
  //         color: theme,
  //         onSelect: () => setState(() => editIndex = 2),
  //       ),
  //       BottomNavItem(
  //         //iconData: Boxicons.bx_text,
  //         text: "Text",
  //         height: 70.h,
  //         selected: false,
  //         color: theme,
  //         onSelect: () {},
  //       ),
  //       BottomNavItem(
  //         //iconData: Boxicons.bxs_sticker,
  //         text: "Sticker",
  //         height: 70.h,
  //         selected: false,
  //         color: theme,
  //         onSelect: () {},
  //       ),
  //     ]);
  //   } else if (editIndex == 2) {
  //     return Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             ClipRRect(
  //                 borderRadius: BorderRadius.circular(6.r),
  //                 child: Image.asset("images/hotel.jpg",
  //                     fit: BoxFit.cover, width: 40.h, height: 40.h)),
  //             SizedBox(width: 10.w),
  //             SizedBox(
  //               height: 40.h,
  //               child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text("Add Maggi",
  //                         style: context.textTheme.bodyMedium!
  //                             .copyWith(fontWeight: FontWeight.w600)),
  //                     Text("Burna Boy", style: context.textTheme.bodySmall)
  //                   ]),
  //             ),
  //           ],
  //         ),
  //         IconButton(
  //           icon: Icon(Boxicons.bx_x, size: 22.r),
  //           onPressed: () => setState(() => editIndex = 0),
  //           splashRadius: 0.01,
  //         ),
  //       ],
  //     );
  //   }
  //   return const SizedBox();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SafeArea(
          child: !loaded
              ? Center(child: SpinKitWave(color: appRed, size: 40.r))
              : Stack(children: [
                  Align(
                    alignment: Alignment.center,
                    child: const SizedBox(),
                  ),
                  Positioned(
                    top: 10.h,
                    left: 10.w,
                    child: IconButton(
                      splashRadius: 0.01,
                      iconSize: 26.r,
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () => context.router.pop(),
                    ),
                  ),
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: appRed,
                          minimumSize: Size(90.w, 40.h)),
                      onPressed: () {},
                      child: Text(
                        "Next",
                        style:
                            context.textTheme.bodyLarge!.copyWith(color: theme),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GlassmorphicContainer(
                        height: 70.h,
                        width: 390.w,
                        blur: 5,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.withOpacity(0.1),
                            theme.withOpacity(0.05),
                          ],
                          stops: const [0.1, 1],
                        ),
                        borderGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.withOpacity(0.5),
                            theme.withOpacity(0.5),
                          ],
                        ),
                        border: 0,
                        borderRadius: 0,
                        child: const SizedBox(), ),
                  ),
                ])),
    );
  }
}

class _AddCaptionPage extends StatefulWidget {
  const _AddCaptionPage({Key? key}) : super(key: key);

  @override
  State<_AddCaptionPage> createState() => _AddCaptionPageState();
}

class _AddCaptionPageState extends State<_AddCaptionPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
