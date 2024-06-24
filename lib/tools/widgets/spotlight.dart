import 'dart:typed_data';

import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:rediones/api/spotlight_service.dart';
import 'package:rediones/components/spotlight_data.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/providers.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:timeago/timeago.dart' as time;

class SpotlightToolbar extends StatefulWidget {
  final SpotlightData spotlight;

  const SpotlightToolbar({
    super.key,
    required this.spotlight,
  });

  @override
  State<SpotlightToolbar> createState() => _SpotlightToolbarState();
}

class _SpotlightToolbarState extends State<SpotlightToolbar> {
  bool liked = false;
  bool bookmarked = false;

  late Future commentsFuture;

  @override
  void initState() {
    super.initState();

    commentsFuture = getComments();
  }

  Future<int> getComments() async {
    await Future.delayed(const Duration(seconds: 2));
    return 0;
  }

  void onLike() {
    setState(() => liked = !liked);
    likeSpotlight(widget.spotlight.id).then((response) {
      if (response.status == Status.success) {
        showToast(response.message, context);
        if (response.payload.contains(currentUserID) &&
            !widget.spotlight.likes.contains(currentUserID)) {
          widget.spotlight.likes.add(currentUserID);
        } else if (!response.payload.contains(currentUserID) &&
            widget.spotlight.likes.contains(currentUserID)) {
          widget.spotlight.likes.remove(currentUserID);
        }
        setState(() {});
      } else {
        setState(() => liked = !liked);
        showToast("Something went wrong liking your spotlight", context);
      }
    });
  }

  void onBookmark() {
    setState(() => bookmarked = !bookmarked);
    // savePost(widget.postObject.id).then((value) {
    //   if (value.status == Status.success) {
    //     showToast(value.message, context);
    //     List<String> postsID =
    //     ref.watch(userProvider.select((value) => value.savedPosts));
    //     postsID.clear();
    //     postsID.addAll(value.payload);
    //   } else {
    //     setState(() => bookmarked = !bookmarked);
    //     showToast("Something went wrong", context);
    //   }
    // });
  }

  void onCommentClicked() {}

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Skeleton.ignore(
                ignore: true,
                child: AnimatedSwitcherZoom.zoomIn(
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                    key: ValueKey<bool>(liked),
                    splashRadius: 0.01,
                    onPressed: onLike,
                    icon: SvgPicture.asset(
                      "assets/Like Filled.svg",
                      color: liked ? appRed : Colors.white,
                      width: 27.r,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                "${widget.spotlight.likes.length}",
                style: context.textTheme.titleSmall!.copyWith(
                  color: Colors.white,
                ),
              )
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Skeleton.ignore(
                ignore: true,
                child: IconButton(
                  icon: SvgPicture.asset(
                    "assets/Comments Filled.svg",
                    width: 26.r,
                  ),
                  onPressed: onCommentClicked,
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
                    style: context.textTheme.titleSmall!.copyWith(
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
          AnimatedSwitcherZoom.zoomIn(
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              key: ValueKey<bool>(bookmarked),
              icon: SvgPicture.asset(
                "assets/Bookmark${bookmarked ? " Filled" : ""}.svg",
                width: bookmarked ? 32.r : 25.r,
                color: !bookmarked ? Colors.white : null,
              ),
              onPressed: onBookmark,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.more_horiz_rounded,
              color: Colors.white,
            ),
            iconSize: 32.r,
            splashRadius: 0.01,
            onPressed: onBookmark,
          ),
        ],
      ),
    );
  }
}

class SpotlightUserData extends ConsumerStatefulWidget {
  final SpotlightData spotlight;

  const SpotlightUserData({
    super.key,
    required this.spotlight,
  });

  @override
  ConsumerState<SpotlightUserData> createState() => _SpotlightUserDataState();
}

class _SpotlightUserDataState extends ConsumerState<SpotlightUserData> {
  bool expandText = false;
  late bool follow;
  late String _time;

  void goToProfile() {
    User current = ref.watch(userProvider);
    ref.watch(spotlightsPlayStatusProvider.notifier).state = false;
    context.router
        .pushNamed(
          current == widget.spotlight.postedBy
              ? Pages.profile
              : Pages.otherProfile,
          extra: current != widget.spotlight.postedBy
              ? widget.spotlight.postedBy
              : null,
        )
        .then((res) =>
            ref.watch(spotlightsPlayStatusProvider.notifier).state = true);
  }

  bool get shouldFollow {
    User currentUser = ref.read(userProvider);
    if (widget.spotlight.postedBy == currentUser) return false;
    if (widget.spotlight.postedBy.followers.contains(currentUserID) ||
        currentUser.following.contains(widget.spotlight.postedBy.id)) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    follow = shouldFollow;
    _time = time.format(widget.spotlight.createdAt);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280.w,
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      "${widget.spotlight.caption.substring(0, expandText ? null : (widget.spotlight.caption.length >= 150 ? 150 : widget.spotlight.caption.length))}"
                      "${widget.spotlight.caption.length >= 150 && !expandText ? "..." : ""}",
                  style: context.textTheme.bodyLarge!
                      .copyWith(color: Colors.white),
                ),
                if (widget.spotlight.caption.length > 150)
                  TextSpan(
                    text: expandText ? " Read Less" : " Read More",
                    style: context.textTheme.bodyLarge!.copyWith(color: appRed),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => setState(() => expandText = !expandText),
                  ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          GestureDetector(
            onTap: goToProfile,
            child: SizedBox(
              height: 40.r,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.spotlight.postedBy.profilePicture,
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
                      return CircleAvatar(
                        backgroundImage: provider,
                        radius: 20.r,
                      );
                    },
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.spotlight.postedBy.username,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          if (follow)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: 10.w),
                                SizedBox(
                                  height: 18.r,
                                  width: 1.2.w,
                                  child: const ColoredBox(
                                    color: appRed,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                GestureDetector(
                                  onTap: () async {
                                    //await followUser(object.poster.id);
                                  },
                                  child: Container(
                                    height: 18.r,
                                    width: 18.r,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: appRed,
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
                        ],
                      ),
                      Text(
                        "@${widget.spotlight.postedBy.nickname}  -  ${_time == "now" ? "now" : "$_time ago"}",
                        style: context.textTheme.labelSmall!
                            .copyWith(color: Colors.white70),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SpotlightMediaList extends StatelessWidget {
  final List<Album> allAlbums;
  final Animation<double> animation;
  final Function(int) onSelect;

  const SpotlightMediaList({
    super.key,
    required this.allAlbums,
    required this.animation,
    required this.onSelect,
  });

  Future<List<dynamic>?> getAlbumData(int index) async {
    Album album = allAlbums[index];
    if (album.name == null) return null;

    List<int> bytes = await album.getThumbnail();
    MediaPage page = await album.listMedia();
    return [album.name!, Uint8List.fromList(bytes), page.items.length];
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;

    return SizeTransition(
      sizeFactor: animation,
      child: Container(
        width: 390.w,
        height: 800.h,
        color: darkTheme ? Colors.black : Colors.white,
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          bottom: 20.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.separated(
                itemBuilder: (_, index) {
                  return FutureBuilder(
                      future: getAlbumData(index),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Skeletonizer(
                            child: Row(
                              children: [
                                ColoredBox(
                                  color: neutral2,
                                  child: SizedBox(
                                    height: 100.h,
                                    width: 85.w,
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                Column(
                                  children: [
                                    Text(
                                      "Album Name",
                                      style: context.textTheme.bodyLarge,
                                    ),
                                    Text(
                                      "Album Items",
                                      style: context.textTheme.bodyMedium,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          List<dynamic>? resp = snapshot.data;
                          if (resp == null) return const SizedBox();

                          return GestureDetector(
                            onTap: () => onSelect(index),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 100.h,
                                  width: 85.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    image: DecorationImage(
                                      image: MemoryImage(
                                        Uint8List.fromList(resp[1]),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                SizedBox(
                                  width: 240.w,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        resp[0],
                                        style: context.textTheme.bodyLarge!
                                            .copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      Text(
                                        "${resp[2]} video${resp[2] == 1 ? "" : "s"}",
                                        style: context.textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      });
                },
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemCount: allAlbums.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
