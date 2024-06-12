import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rediones/api/base.dart';
import 'package:rediones/api/post_service.dart';
import 'package:rediones/api/profile_service.dart';
import 'package:rediones/components/poll_data.dart';
import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/postable.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/screens/other/media_view.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:timeago/timeago.dart' as time;

import 'common.dart' show loader;

const BottomNavBar bottomNavBar = BottomNavBar();

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool darkTheme = context.isDark;
    int currentTab = ref.watch(dashboardIndexProvider);

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
                                                  fontWeight: FontWeight.w500),
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
                                                  fontWeight: FontWeight.w500),
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
                                  color: neutral2,
                                  height: 65.h,
                                  width: 80.w,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 20.h),
                                      GestureDetector(
                                        onTap: () async {
                                          Navigator.pop(context);
                                          Permission.storage
                                              .request()
                                              .then((resp) {
                                            if (resp.isGranted) {
                                              context.router.pushNamed(
                                                Pages.createSpotlight,
                                              );
                                            }
                                          });
                                        },
                                        child: Text(
                                          "Create A Spotlight Video",
                                          style: context.textTheme.titleSmall!
                                              .copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: theme,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else if (currentTab == 2) {
                          context.router.pushNamed(Pages.createProject);
                        }
                      },
                      child: Container(
                        height: 65.r,
                        width: 65.r,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentTab == 1
                              ? primary
                              : (darkTheme ? midPrimary : primary),
                        ),
                        child: Icon(
                          Icons.add_rounded,
                          size: 32.r,
                          color: currentTab == 1 ? appRed : offWhite,
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
                                            .watch(
                                                dashboardIndexProvider.notifier)
                                            .state = 0;
                                        ref
                                            .watch(spotlightsPlayStatusProvider
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
                                            .watch(
                                                dashboardIndexProvider.notifier)
                                            .state = 1;
                                        ref
                                            .watch(spotlightsPlayStatusProvider
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
                                    activeSVG: "assets/Community.svg",
                                    inactiveSVG: "assets/Community.svg",
                                    onSelect: () {
                                      unFocus();
                                      ref
                                          .watch(spotlightsPlayStatusProvider
                                              .notifier)
                                          .state = false;
                                      context.router
                                          .pushNamed(Pages.communityPractice)
                                          .then((resp) {
                                        if (currentTab == 1) {
                                          ref
                                              .watch(
                                                  spotlightsPlayStatusProvider
                                                      .notifier)
                                              .state = true;
                                        }
                                      });
                                    },
                                  ),
                                  BottomNavItem(
                                    selected: currentTab == 3,
                                    color: currentTab == 1 ? offWhite : null,
                                    height: 70.h,
                                    text: "Notification",
                                    activeSVG: "assets/Notification Active.svg",
                                    inactiveSVG:
                                        "assets/Notification Inactive.svg",
                                    onSelect: () {
                                      unFocus();
                                      if (currentTab != 3) {
                                        ref
                                            .watch(
                                                dashboardIndexProvider.notifier)
                                            .state = 3;
                                        ref
                                            .watch(spotlightsPlayStatusProvider
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
  }
}

class BottomNavItem extends StatelessWidget {
  final String activeSVG;
  final String inactiveSVG;
  final String text;
  final Color? color;
  final bool invertColor;
  final bool selected;
  final double height;
  final VoidCallback onSelect;

  const BottomNavItem({
    super.key,
    this.color,
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
                width: 20.r,
                height: 20.r,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              text,
              style: context.textTheme.bodyMedium!.copyWith(
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

class PostObjectContainer extends ConsumerStatefulWidget {
  final PostObject postObject;
  final VoidCallback onCommentClicked;

  const PostObjectContainer({
    super.key,
    required this.postObject,
    required this.onCommentClicked,
  });

  @override
  ConsumerState<PostObjectContainer> createState() =>
      _PostObjectContainerState();
}

class _PostObjectContainerState extends ConsumerState<PostObjectContainer> {
  int length = 0;
  bool liked = false;
  bool bookmarked = false;
  bool expandText = false;
  late String currentUserID;
  late Future<int> commentsFuture;

  late bool isPost, mediaAndText;

  @override
  void initState() {
    super.initState();
    if (widget.postObject is Post) {
      Post post = widget.postObject as Post;
      length = post.media.length;
      isPost = true;
      mediaAndText = post.type == MediaType.imageAndText;
    } else {
      isPost = false;
      mediaAndText = false;
    }

    User user = ref.read(userProvider);
    currentUserID = user.id;
    liked = widget.postObject.likes.contains(currentUserID);
    bookmarked = user.savedPosts.contains(widget.postObject.id);
    commentsFuture = _getCommentsCount();
  }

  Future<int> _getCommentsCount() async {
    int value = (await getComments(widget.postObject.id)).payload.length;
    return value;
  }

  void showExtension() {
    bool darkTheme = context.isDark;
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 360.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.h),
            SvgPicture.asset("assets/Modal Line.svg",
                color: darkTheme ? Colors.white : null),
            SizedBox(height: 30.h),
            ListTile(
              leading: SvgPicture.asset("assets/Link Red.svg"),
              title: Text(
                "Copy Link",
                style: context.textTheme.bodyLarge,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: SvgPicture.asset("assets/Unfollow Red.svg"),
              title: Text(
                "Unfollow",
                style: context.textTheme.bodyLarge,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: SvgPicture.asset("assets/Not Interested Red.svg"),
              title: Text(
                "Not Interested",
                style: context.textTheme.bodyLarge,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: SvgPicture.asset("assets/Block Red.svg"),
              title: Text(
                "Block User",
                style: context.textTheme.bodyLarge,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: SvgPicture.asset("assets/Report Red.svg"),
              title: Text(
                "Report Post",
                style: context.textTheme.bodyLarge,
              ),
              onTap: () {},
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  void onLike() {
    setState(() => liked = !liked);
    likePost(widget.postObject.id).then((response) {
      if (response.status == Status.success) {
        showToast(response.message);
        if (response.payload.contains(currentUserID) &&
            !widget.postObject.likes.contains(currentUserID)) {
          widget.postObject.likes.add(currentUserID);
        } else if (!response.payload.contains(currentUserID) &&
            widget.postObject.likes.contains(currentUserID)) {
          widget.postObject.likes.remove(currentUserID);
        }
        setState(() {});
      } else {
        setState(() => liked = !liked);
        showToast("Something went wrong");
      }
    });
  }

  void onBookmark() {
    setState(() => bookmarked = !bookmarked);
    savePost(widget.postObject.id).then((value) {
      if (value.status == Status.success) {
        showToast(value.message);
        compute(
          (_) {
            List<String> postsID =
                ref.watch(userProvider.select((value) => value.savedPosts));
            postsID.clear();
            postsID.addAll(value.payload);
          },
          "",
        );
      } else {
        setState(() => bookmarked = !bookmarked);
        showToast("Something went wrong");
      }
    });
  }

  bool get shouldFollow {
    User currentUser = ref.watch(userProvider);
    if (widget.postObject.poster == currentUser) return false;
    if (widget.postObject.poster.followers.contains(currentUserID) ||
        currentUser.following.contains(widget.postObject.poster.id)) {
      return false;
    }
    return true;
  }

  void goToProfile() {
    User currentUser = ref.watch(userProvider);
    if (widget.postObject.poster == currentUser) {
      context.router.pushNamed(Pages.profile);
    } else {
      context.router.pushNamed(
        Pages.otherProfile,
        extra: widget.postObject.poster,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;

    return Container(
      width: 390.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: darkTheme ? neutral : border),
        color: Colors.transparent,
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PostHeader(
            object: widget.postObject,
            goToProfile: goToProfile,
            shouldFollow: shouldFollow,
            showExtension: showExtension,
          ),
          SizedBox(height: 20.h),
          GestureDetector(
            onTap: () => setState(() => expandText = !expandText),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "${widget.postObject.text.substring(0, expandText ? null : (widget.postObject.text.length >= 150 ? 150 : widget.postObject.text.length))}"
                        "${widget.postObject.text.length >= 150 && !expandText ? "..." : ""}",
                    style: context.textTheme.bodyMedium,
                  ),
                  if (widget.postObject.text.length > 150)
                    TextSpan(
                      text: expandText ? " Read Less" : " Read More",
                      style:
                          context.textTheme.bodyMedium!.copyWith(color: appRed),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
          if (isPost && mediaAndText)
            _PostContainer(post: widget.postObject as Post),
          if (!isPost) _PollContainer(poll: widget.postObject as PollData),
          _PostFooter(
            object: widget.postObject,
            liked: liked,
            bookmarked: bookmarked,
            onBookmark: onBookmark,
            onLike: onLike,
            commentsFuture: commentsFuture,
            onCommentClicked: widget.onCommentClicked,
          ),
        ],
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  final PostObject object;
  final bool shouldFollow;
  final VoidCallback goToProfile, showExtension;

  const _PostHeader({
    super.key,
    required this.object,
    required this.shouldFollow,
    required this.goToProfile,
    required this.showExtension,
  });

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;

    return SizedBox(
      height: 40.r,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: object.poster.profilePicture,
            errorWidget: (context, url, error) => CircleAvatar(
              backgroundColor: neutral2,
              radius: 20.r,
              child: Icon(
                Icons.person_outline_rounded,
                color: Colors.black,
                size: 16.r,
              ),
            ),
            progressIndicatorBuilder: (context, url, download) {
              return Container(
                width: 40.r,
                height: 40.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: neutral2,
                ),
              );
            },
            imageBuilder: (context, provider) {
              return GestureDetector(
                onTap: goToProfile,
                child: CircleAvatar(
                  backgroundImage: provider,
                  radius: 20.r,
                ),
              );
            },
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 18.r,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: !shouldFollow ? 180.w : 140.w,
                      child: GestureDetector(
                        onTap: goToProfile,
                        child: Text(
                          object.poster.username,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    if (shouldFollow)
                      Skeleton.ignore(
                        ignore: true,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 10.w),
                            SizedBox(
                              height: 18.r,
                              width: 1.2.w,
                              child: ColoredBox(
                                color: darkTheme ? neutral : primary1,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            GestureDetector(
                              onTap: () async {
                                await followUser(object.poster.id);
                              },
                              child: Container(
                                height: 18.r,
                                width: 18.r,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: darkTheme ? appRed : primary,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Icon(
                                  Icons.add_rounded,
                                  color: theme,
                                  size: 16.r,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                "@${object.poster.nickname}",
                style: context.textTheme.labelMedium,
              ),
            ],
          ),
          SizedBox(width: 20.w),
          SizedBox(
            width: 80.w,
            height: 18.r,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time.format(object.timestamp),
                  style: context.textTheme.labelMedium!.copyWith(color: gray),
                ),
                GestureDetector(
                  onTap: showExtension,
                  child: Icon(
                    Icons.more_horiz,
                    color: Colors.grey,
                    size: 26.r,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PostFooter extends StatelessWidget {
  final PostObject object;
  final bool liked, bookmarked;
  final VoidCallback onLike, onBookmark, onCommentClicked;
  final Future commentsFuture;

  const _PostFooter({
    super.key,
    required this.object,
    required this.liked,
    required this.bookmarked,
    required this.onLike,
    required this.onBookmark,
    required this.onCommentClicked,
    required this.commentsFuture,
  });

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcherZoom.zoomIn(
              duration: const Duration(milliseconds: 200),
              child: IconButton(
                key: ValueKey<bool>(liked),
                splashRadius: 0.01,
                onPressed: onLike,
                iconSize: 20.r,
                icon: Icon(liked ? Boxicons.bxs_like : Boxicons.bx_like,
                    color: liked ? appRed : null),
              ),
            ),
            SizedBox(width: 5.w),
            Text(
              "${object.likes.length}",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Skeleton.ignore(
              ignore: true,
              child: IconButton(
                icon: SvgPicture.asset(
                  "assets/Comment Post.svg",
                  color: darkTheme ? Colors.white : null,
                ),
                onPressed: onCommentClicked,
                splashRadius: 0.01,
              ),
            ),
            SizedBox(width: 5.w),
            FutureBuilder(
              future: commentsFuture,
              builder: (context, snapshot) {
                String text = "";
                if (snapshot.connectionState == ConnectionState.waiting) {
                  text = "...";
                } else if (snapshot.connectionState == ConnectionState.done) {
                  text = "${snapshot.data as int}";
                }
                return Text(
                  text,
                  style: context.textTheme.bodyMedium,
                );
              },
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Skeleton.ignore(
              ignore: true,
              child: IconButton(
                icon: SvgPicture.asset(
                  "assets/Reply.svg",
                  color: darkTheme ? Colors.white : null,
                ),
                onPressed: () {},
                splashRadius: 0.01,
              ),
            ),
            SizedBox(width: 5.w),
            Text(
              "${object.shares}",
              style: context.textTheme.bodyMedium,
            )
          ],
        ),
        AnimatedSwitcherZoom.zoomIn(
          duration: const Duration(milliseconds: 200),
          child: IconButton(
            key: ValueKey<bool>(bookmarked),
            icon: Icon(
                bookmarked ? Boxicons.bxs_bookmark : Boxicons.bx_bookmark,
                color: bookmarked ? appRed : null),
            iconSize: 20.r,
            splashRadius: 0.01,
            onPressed: onBookmark,
          ),
        ),
      ],
    );
  }
}

class _PostContainer extends StatelessWidget {
  final Post post;

  const _PostContainer({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 370.w,
      height: 230.h,
      child: PageView.builder(
        itemCount: post.media.length,
        itemBuilder: (context, index) => CachedNetworkImage(
          imageUrl: post.media[index],
          errorWidget: (context, url, error) => Container(
            width: 364.w,
            height: 230.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: neutral2,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.broken_image_rounded,
              color: Colors.white,
              size: 36.r,
            ),
          ),
          progressIndicatorBuilder: (context, url, download) => Container(
            width: 364.w,
            height: 230.h,
            decoration: BoxDecoration(
              color: neutral2,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: const Center(
              child: loader,
            ),
          ),
          imageBuilder: (context, provider) => GestureDetector(
            onTap: () => context.router.pushNamed(
              Pages.viewMedia,
              extra: PreviewData(
                images: post.media,
                current: index,
                displayType: DisplayType.network,
              ),
            ),
            child: Container(
              width: 364.w,
              height: 230.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                image: DecorationImage(image: provider, fit: BoxFit.cover),
              ),
              child: post.media.length > 1
                  ? Padding(
                      padding: EdgeInsets.only(top: 10.h, left: 10.w),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 20.h,
                          width: 55.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(10.h),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 2.h),
                          child: Text(
                            "${index + 1} of ${post.media.length}",
                            style: context.textTheme.bodySmall!
                                .copyWith(color: theme),
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _PollContainer extends ConsumerStatefulWidget {
  final PollData poll;

  const _PollContainer({
    super.key,
    required this.poll,
  });

  @override
  ConsumerState<_PollContainer> createState() => _PollContainerState();
}

class _PollContainerState extends ConsumerState<_PollContainer> {
  int pollIndex = -1;
  bool hasVoted = false;

  late String currentUserID;

  late int totalVotes;

  @override
  void initState() {
    super.initState();

    currentUserID = ref.read(userProvider).id;

    for (int i = 0; i < widget.poll.polls.length; ++i) {
      PollChoice choice = widget.poll.polls[i];
      List<String> voters = choice.voters;
      if (!hasVoted && voters.contains(currentUserID)) {
        hasVoted = true;
        pollIndex = i;
        break;
      }
    }

    totalVotes = widget.poll.totalVotes;
  }

  void vote(String id, int index) {
    setState(() {
      hasVoted = true;
      pollIndex = index;
      totalVotes += 1;
    });
    votePoll(id).then((response) {
      if (response.status == Status.success) {
        showToast(response.message);
        widget.poll.polls[index].voters.add(currentUserID);
        setState(() {});
      } else {
        setState(() {
          hasVoted = false;
          pollIndex = -1;
          totalVotes -= 1;
        });
        showToast("Something went wrong");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: List.generate(
            widget.poll.polls.length,
            (index) {
              PollChoice choice = widget.poll.polls[index];
              double percentage = 0.0;
              if (widget.poll.totalVotes > 0) {
                percentage = choice.voters.length / totalVotes;
              }

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // if (!hasVoted) {
                          vote(choice.id, index);
                          // }
                        },
                        child: Row(
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border.all(color: appRed, width: 2.0),
                                color: (hasVoted && pollIndex == index)
                                    ? appRed
                                    : null,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: SizedBox(
                                width: 16.r,
                                height: 16.r,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              choice.name,
                              style: context.textTheme.bodyLarge,
                            )
                          ],
                        ),
                      ),
                      Text(
                        percentage == 0
                            ? "0"
                            : "${(percentage * 100).toStringAsFixed(0)}%",
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.r + 5.w),
                    child: LinearProgressIndicator(
                      color: appRed,
                      backgroundColor: gray3,
                      minHeight: 10.h,
                      borderRadius: BorderRadius.circular(5.h),
                      value: percentage,
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              );
            },
          ),
        ),
        SizedBox(height: 5.h),
        Padding(
          padding: EdgeInsets.only(left: 20.r + 5.w),
          child: Text(
            "${formatRawAmount(widget.poll.totalVotes)} votes",
            style: context.textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
