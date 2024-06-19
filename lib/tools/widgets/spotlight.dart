import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rediones/components/spotlight_data.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SpotlightToolbar extends StatelessWidget {
  final SpotlightData data;
  final bool liked, bookmarked;
  final VoidCallback onLike, onBookmark, onCommentClicked;
  final Future commentsFuture;

  const SpotlightToolbar({
    super.key,
    required this.data,
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
                "${data.likes.length}",
                style: context.textTheme.titleSmall,
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
                    style: context.textTheme.titleSmall,
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

class SpotlightUserData extends StatefulWidget {
  final User postedBy;
  final String text;

  const SpotlightUserData({
    super.key,
    required this.postedBy,
    required this.text,
  });

  @override
  State<SpotlightUserData> createState() => _SpotlightUserDataState();
}

class _SpotlightUserDataState extends State<SpotlightUserData> {

  bool expandText = false;

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
                  "${widget.text.substring(0, expandText ? null : (widget.text.length >= 150 ? 150 : widget.text.length))}"
                      "${widget.text.length >= 150 && !expandText ? "..." : ""}",
                  style: context.textTheme.bodyLarge!.copyWith(color: Colors.white),
                ),
                if (widget.text.length > 150)
                  TextSpan(
                    text: expandText ? " Read Less" : " Read More",
                    style:
                    context.textTheme.bodyLarge!.copyWith(color: appRed),
                    recognizer: TapGestureRecognizer()..onTap = () => setState(() => expandText = !expandText),
                  ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 40.r,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.postedBy.profilePicture,
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
                      onTap: () {},
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
                    Text(
                      widget.postedBy.username,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyLarge!
                          .copyWith(fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    Text(
                      "@${widget.postedBy.nickname}",
                      style: context.textTheme.labelMedium!.copyWith(color: neutral),
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
                        "2m",
                        style: context.textTheme.labelMedium!.copyWith(color: gray),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
