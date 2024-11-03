import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:rediones/api/file_handler.dart';
import 'package:rediones/api/post_service.dart';
import 'package:rediones/api/user_service.dart';
import 'package:rediones/components/poll_data.dart';
import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/postable.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/screens/home/comments.dart';
import 'package:rediones/screens/other/media_view.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/providers.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:timeago/timeago.dart' as time;

import 'common.dart' show loader;

const BottomNavBar bottomNavBar = BottomNavBar();

class BottomNavBar extends ConsumerStatefulWidget {
  const BottomNavBar({
    super.key,
  });

  @override
  ConsumerState<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends ConsumerState<BottomNavBar> {
  void navigate(SingleFileResponse resp) {
    context.router
        .pushNamed(
          Pages.editSpotlight,
          extra: resp,
        )
        .then((_) =>
            ref.watch(spotlightsPlayStatusProvider.notifier).state = true);
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;
    int currentTab = ref.watch(dashboardIndexProvider);

    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      if (isKeyboardVisible) {
        return const SizedBox();
      }

      return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 120.h,
                child: Stack(
                  children: [
                    Positioned(
                      top: 20.h,
                      left: 160.w,
                      right: 160.w,
                      child: GestureDetector(
                        onTap: () {
                          if (currentTab == 0) {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) => Dialog(
                                backgroundColor: Colors.transparent,
                                elevation: 0.0,
                                insetPadding: EdgeInsets.only(
                                  left: 130.w,
                                  right: 130.w,
                                  top: 450.h,
                                ),
                                child: ClipPath(
                                  clipper: TriangleClipper(
                                    borderRadius: 10.r,
                                    triangleHeight: 15.h,
                                    triangleWidth: 20.h,
                                  ),
                                  child: Container(
                                    color: darkTheme ? primary : theme,
                                    height: 120.h,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.w, vertical: 5.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 15.h),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                            context.router
                                                .pushNamed(Pages.createPosts);
                                          },
                                          child: Text(
                                            "Create Post",
                                            style: context.textTheme.titleSmall!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                        ),
                                        SizedBox(height: 15.h),
                                        ColoredBox(
                                          color: Colors.black12,
                                          child: SizedBox(
                                            width: 80.w,
                                            height: 1.h,
                                          ),
                                        ),
                                        SizedBox(height: 15.h),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                            context.router
                                                .pushNamed(Pages.askQuestion);
                                          },
                                          child: Text(
                                            "Ask A Question",
                                            style: context.textTheme.titleSmall!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else if (currentTab == 1) {
                            showDialog(
                              context: context,
                              useSafeArea: true,
                              barrierDismissible: true,
                              builder: (context) => Dialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: EdgeInsets.only(
                                  left: 100.w,
                                  right: 100.w,
                                  top: 500.h,
                                ),
                                elevation: 0.0,
                                child: ClipPath(
                                  clipper: TriangleClipper(
                                    borderRadius: 10.r,
                                    triangleHeight: 15.h,
                                    triangleWidth: 20.h,
                                  ),
                                  child: Container(
                                    color: Colors.white,
                                    height: 65.h,
                                    width: 80.w,
                                    child: Column(
                                      children: [
                                        SizedBox(height: 15.h),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                            FileHandler.single(
                                                    type: FileType.video)
                                                .then((resp) {
                                              if (resp == null) return;
                                              navigate(resp);
                                            });
                                          },
                                          child: Text(
                                            "Create A Spotlight Video",
                                            style: context.textTheme.titleSmall!
                                                .copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: 65.r,
                          width: 65.r,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentTab == 1
                                ? goodYellow
                                : (darkTheme ? midPrimary : primary),
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            size: 32.r,
                            color: currentTab == 1 ? primary : offWhite,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ClipPath(
                        clipper: BottomNavBarClipper(
                          borderRadius: 15.r,
                          cutoutRadius: 35.r,
                        ),
                        child: Container(
                          color: currentTab == 1
                              ? primary
                              : (darkTheme ? midPrimary : primary),
                          height: 70.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 160.w,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    BottomNavItem(
                                      color: currentTab == 1 ? offWhite : null,
                                      selected: currentTab == 0,
                                      height: 70.h,
                                      text: "Home",
                                      activeSVG: "assets/Home Active.svg",
                                      inactiveSVG: "assets/Home Inactive.svg",
                                      onSelect: () {
                                        unFocus();
                                        if (currentTab != 0) {
                                          ref
                                              .watch(dashboardIndexProvider
                                                  .notifier)
                                              .state = 0;
                                          ref
                                              .watch(
                                                  spotlightsPlayStatusProvider
                                                      .notifier)
                                              .state = false;
                                        }
                                      },
                                    ),
                                    BottomNavItem(
                                      selected: currentTab == 1,
                                      color: currentTab == 1 ? appRed : null,
                                      height: 70.h,
                                      activeSVG: "assets/Spotlight Active.svg",
                                      inactiveSVG:
                                          "assets/Spotlight Inactive.svg",
                                      text: "Spotlight",
                                      onSelect: () {
                                        unFocus();
                                        if (currentTab != 1) {
                                          ref
                                              .watch(dashboardIndexProvider
                                                  .notifier)
                                              .state = 1;

                                          ref
                                              .watch(
                                                  spotlightsPlayStatusProvider
                                                      .notifier)
                                              .state = true;
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 160.w,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    BottomNavItem(
                                      selected: currentTab == 2,
                                      color: currentTab == 1 ? offWhite : null,
                                      height: 70.h,
                                      text: "Communities",
                                      activeSVG: "assets/Groups.svg",
                                      inactiveSVG: "assets/Groups.svg",
                                      onSelect: () {
                                        unFocus();
                                        ref
                                            .watch(spotlightsPlayStatusProvider
                                                .notifier)
                                            .state = false;
                                        context.router
                                            .pushNamed(Pages.groups)
                                            .then((resp) {
                                          if (currentTab == 1) {
                                            ref
                                                .watch(
                                                    spotlightsPlayStatusProvider
                                                        .notifier)
                                                .state = false;
                                          }
                                        });
                                      },
                                    ),
                                    BottomNavItem(
                                      selected: currentTab == 3,
                                      color: currentTab == 1 ? offWhite : null,
                                      height: 70.h,
                                      text: "Notification",
                                      activeSVG:
                                          "assets/Notification Active.svg",
                                      inactiveSVG:
                                          "assets/Notification Inactive.svg",
                                      onSelect: () {
                                        unFocus();
                                        if (currentTab != 3) {
                                          ref
                                              .watch(dashboardIndexProvider
                                                  .notifier)
                                              .state = 3;
                                          ref
                                              .watch(
                                                  spotlightsPlayStatusProvider
                                                      .notifier)
                                              .state = false;
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.h)
            ],
          ),
        ),
      );
    });
  }
}

class BottomNavItem extends StatelessWidget {
  final String activeSVG;
  final String inactiveSVG;
  final String text;
  final Color? color;
  final bool expandText;
  final bool invertColor;
  final bool selected;
  final double height;
  final VoidCallback onSelect;

  const BottomNavItem({
    super.key,
    this.color,
    this.expandText = false,
    this.invertColor = false,
    this.activeSVG = "",
    this.inactiveSVG = "",
    required this.text,
    required this.height,
    required this.selected,
    required this.onSelect,
  });

  Color getColor(bool darkTheme) {
    if (color != null) {
      return color!;
    }

    if (selected) {
      return appRed;
    }

    if (darkTheme) {
      return invertColor ? Colors.white54 : Colors.black54;
    } else {
      return !invertColor ? Colors.white54 : Colors.black54;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: SizedBox(
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcherZoom.zoomIn(
              duration: const Duration(milliseconds: 200),
              child: SvgPicture.asset(
                selected ? activeSVG : inactiveSVG,
                key: ValueKey<bool>(selected),
                width: expandText ? 28.r : 20.r,
                height: expandText ? 28.r : 20.r,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              text,
              style: expandText
                  ? context.textTheme.bodyLarge!.copyWith(
                      color: theme,
                      fontWeight: FontWeight.w600,
                    )
                  : context.textTheme.bodyMedium!.copyWith(
                      color: selected ? appRed : theme.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavBarClipper extends CustomClipper<Path> {
  final double borderRadius;
  final double cutoutRadius;

  const BottomNavBarClipper({
    required this.borderRadius,
    required this.cutoutRadius,
  });

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, borderRadius);
    path.arcToPoint(Offset(borderRadius, 0.0),
        radius: Radius.circular(borderRadius));
    path.lineTo((size.width * 0.5) - cutoutRadius - borderRadius, 0.0);
    path.arcToPoint(Offset((size.width * 0.5) - cutoutRadius, borderRadius),
        radius: Radius.circular(borderRadius));
    path.arcToPoint(Offset((size.width * 0.5) + cutoutRadius, borderRadius),
        clockwise: false, radius: Radius.elliptical(cutoutRadius * 1.02, 28.r));
    path.arcToPoint(
        Offset((size.width * 0.5) + cutoutRadius + borderRadius, 0.0),
        radius: Radius.circular(borderRadius));
    path.lineTo(size.width - borderRadius, 0.0);
    path.arcToPoint(Offset(size.width, borderRadius),
        radius: Radius.circular(borderRadius));
    path.lineTo(size.width, size.height - borderRadius);
    path.arcToPoint(Offset(size.width - borderRadius, size.height),
        radius: Radius.circular(borderRadius));
    path.lineTo(borderRadius, size.height);
    path.arcToPoint(Offset(0, size.height - borderRadius),
        radius: Radius.circular(borderRadius));
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class TriangleClipper extends CustomClipper<Path> {
  final double triangleHeight;
  final double triangleWidth;
  final double borderRadius;

  const TriangleClipper({
    required this.triangleHeight,
    required this.triangleWidth,
    required this.borderRadius,
  });

  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(borderRadius, 0);
    path.lineTo(size.width - borderRadius, 0);
    path.arcToPoint(
      Offset(size.width, borderRadius),
      radius: Radius.circular(borderRadius),
    );
    path.lineTo(size.width, size.height - borderRadius - triangleHeight);
    path.arcToPoint(
      Offset(size.width - borderRadius, size.height - triangleHeight),
      radius: Radius.circular(borderRadius),
    );
    path.lineTo(
        (size.width * 0.5 + triangleWidth * 0.5), size.height - triangleHeight);
    path.lineTo(size.width * 0.5, size.height);
    path.lineTo(
        (size.width * 0.5 - triangleWidth * 0.5), size.height - triangleHeight);
    path.lineTo(borderRadius, size.height - triangleHeight);
    path.arcToPoint(
      Offset(0, size.height - borderRadius - triangleHeight),
      radius: Radius.circular(borderRadius),
    );
    path.lineTo(0, borderRadius);
    path.arcToPoint(
      Offset(borderRadius, 0),
      radius: Radius.circular(borderRadius),
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}

