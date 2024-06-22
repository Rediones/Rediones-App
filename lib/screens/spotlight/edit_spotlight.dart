import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:rediones/api/file_handler.dart';
import 'package:rediones/api/spotlight_service.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/widgets.dart';
import 'package:video_player/video_player.dart';

class EditSpotlightPage extends StatefulWidget {
  final Medium spotlight;

  const EditSpotlightPage({super.key, required this.spotlight});

  @override
  State<EditSpotlightPage> createState() => _EditSpotlightPageState();
}

class _EditSpotlightPageState extends State<EditSpotlightPage>
    with SingleTickerProviderStateMixin {
  late File spotlightFile;
  bool loaded = false, paused = true;
  int editIndex = 0;

  VideoPlayerController? videoController;
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    setup();
  }

  @override
  void dispose() {
    animationController.dispose();
    videoController?.dispose();
    super.dispose();
  }

  Future<void> onCreate() async {
    File file = await widget.spotlight.getFile();
    Uint8List data = await file.readAsBytes();
    String videoData = FileHandler.convertTo64(data);
    _create("$vidPrefix$videoData");
  }

  void _create(String videoData) {
    createSpotlight(data: videoData).then((resp) {
      showToast(resp.message, context);
      Navigator.of(context).pop();
    });

    showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      context: context,
      builder: (_) => const Popup(),
    );
  }

  Future<void> setup() async {
    spotlightFile = await widget.spotlight.getFile();
    videoController = VideoPlayerController.file(
      spotlightFile,
      videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: false),
    );
    await videoController!.initialize();
    setState(() => loaded = true);

    // List<Uint8List> bytes = await VideoService.extractFrames(spotlightFile.path);
    // log("Video Services: ${bytes.length}");
  }

  Widget get getBottomContent {
    if (editIndex == 0) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BottomNavItem(
              activeSVG: "assets/Trim.svg",
              inactiveSVG: "assets/Trim.svg",
              text: "Trim",
              height: 70.h,
              selected: false,
              color: theme,
              expandText: true,
              onSelect: () {},
            ),
            BottomNavItem(
              activeSVG: "assets/Music.svg",
              inactiveSVG: "assets/Music.svg",
              text: "Music",
              height: 70.h,
              selected: false,
              color: theme,
              expandText: true,
              onSelect: () => setState(() => editIndex = 2),
            ),
            BottomNavItem(
              activeSVG: "assets/Texts.svg",
              inactiveSVG: "assets/Texts.svg",
              text: "Text",
              height: 70.h,
              selected: false,
              color: theme,
              expandText: true,
              onSelect: () {},
            ),
            BottomNavItem(
              activeSVG: "assets/Smiley.svg",
              inactiveSVG: "assets/Smiley.svg",
              text: "Sticker",
              height: 70.h,
              selected: false,
              color: theme,
              expandText: true,
              onSelect: () {},
            ),
          ]);
    } else if (editIndex == 2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: Image.asset("images/hotel.jpg",
                      fit: BoxFit.cover, width: 40.h, height: 40.h)),
              SizedBox(width: 10.w),
              SizedBox(
                height: 40.h,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Add Maggi",
                          style: context.textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.w600)),
                      Text("Burna Boy", style: context.textTheme.bodySmall)
                    ]),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Boxicons.bx_x, size: 22.r),
            onPressed: () => setState(() => editIndex = 0),
            splashRadius: 0.01,
          ),
        ],
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SafeArea(
        child: !loaded
            ? const Center(child: loader)
            : Stack(
                children: [
                  SizedBox(
                    width: 390.w,
                    height: 800.h,
                    child: GestureDetector(
                      onTap: () {
                        if (videoController!.value.isPlaying) {
                          videoController!.pause();
                        } else {
                          videoController!.play();
                        }
                        setState(() {});
                      },
                      child: Stack(
                        children: [
                          Center(
                            child: AspectRatio(
                              aspectRatio: videoController!.value.aspectRatio,
                              child: VideoPlayer(videoController!),
                            ),
                          ),
                          Center(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: videoController!.value.isPlaying ? 0 : 1,
                              child: Container(
                                width: 64.r,
                                height: 64.r,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Colors.black45,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.play_arrow_rounded,
                                  size: 48.r,
                                  color: Colors.white54,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10.h,
                    left: 10.w,
                    child: IconButton(
                      splashRadius: 0.01,
                      iconSize: 26.r,
                      icon: const Icon(Icons.chevron_left, color: Colors.white),
                      onPressed: () => context.router.pop(),
                    ),
                  ),
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appRed,
                        elevation: 1.0,
                        minimumSize: Size(90.w, 35.h),
                        fixedSize: Size(90.w, 35.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      ),
                      onPressed: onCreate,
                      child: Text(
                        "Next",
                        style: context.textTheme.titleSmall!.copyWith(
                          color: theme,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            height: 80.h,
                            width: 390.w,
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: getBottomContent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _AddCaptionPage extends StatefulWidget {
  const _AddCaptionPage();

  @override
  State<_AddCaptionPage> createState() => _AddCaptionPageState();
}

class _AddCaptionPageState extends State<_AddCaptionPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
