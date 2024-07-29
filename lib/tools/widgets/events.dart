import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:intl/intl.dart';
import 'package:rediones/components/event_data.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/providers.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:timeago/timeago.dart' as time;

class EventContainer extends ConsumerStatefulWidget {
  final EventData data;

  const EventContainer({super.key, required this.data});

  @override
  ConsumerState<EventContainer> createState() => _EventContainerState();
}

class _EventContainerState extends ConsumerState<EventContainer> {
  int status = 0;
  bool expanded = false;
  late bool past;
  double stars = 0.0;

  String truncate() {
    if (!expanded) {
      if (widget.data.description.length > 150) {
        return widget.data.description.substring(0, 150);
      }
    }
    return widget.data.description;
  }

  @override
  void initState() {
    super.initState();
    past = DateTime.now().millisecondsSinceEpoch >=
        widget.data.date.millisecondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;

    return Container(
      width: 390.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: darkTheme ? neutral : fadedPrimary),
        color: Colors.transparent,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 8.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserHeader(event: widget.data),
          SizedBox(height: 10.h),
          Text(
            widget.data.header,
            style: context.textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.w700,
              color: midPrimary,
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: 390.w,
            height: 200.h,
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.data.cover,
                  errorWidget: (context, url, error) => Container(
                    width: 390.w,
                    height: 200.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: neutral2,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.broken_image_outlined,
                      size: 32.r,
                      color: appRed,
                    ),
                  ),
                  progressIndicatorBuilder: (context, url, download) =>
                      Container(
                    width: 390.w,
                    height: 200.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: neutral2,
                    ),
                  ),
                  imageBuilder: (context, provider) => Container(
                    width: 390.w,
                    height: 200.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      image: DecorationImage(
                        image: provider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20.h,
                  left: 20.w,
                  right: 20.w,
                  child: GlassmorphicContainer(
                    width: 350.w,
                    height: 36.h,
                    borderRadius: 15.h,
                    blur: 5,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    linearGradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.black26,
                        Colors.black26,
                      ],
                      stops: [0.1, 1],
                    ),
                    borderGradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.black26,
                        Colors.black26,
                      ],
                    ),
                    border: 0,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          width: 75.w,
                          child: Center(
                            child: Text(
                              widget.data.location,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: theme,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          color: appRed,
                          width: 0.5.w,
                          height: 20.h,
                        ),
                        SizedBox(width: 10.w),
                        SizedBox(
                          width: 75.w,
                          child: Center(
                            child: Text(
                              formatDate(
                                DateFormat("dd/MM/yyyy")
                                    .format(widget.data.date),
                                shorten: true,
                              ),
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodyMedium!
                                  .copyWith(color: theme),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Container(
                          color: appRed,
                          width: 0.5.w,
                          height: 20.h,
                        ),
                        SizedBox(width: 10.w),
                        SizedBox(
                          width: 75.w,
                          child: Center(
                            child: Text(
                              widget.data.time.format(context),
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodyMedium!
                                  .copyWith(color: theme),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 10.w,
                  top: 10.h,
                  child: past
                      ? GlassmorphicContainer(
                          borderRadius: 9.h,
                          border: 0,
                          blur: 10,
                          width: 45.w,
                          height: 22.h,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 2.h,
                          ),
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
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Boxicons.bxs_star,
                                  color: appRed, size: 14.r),
                              SizedBox(width: 2.w),
                              Text(
                                widget.data.rating.toStringAsFixed(1),
                                style: context.textTheme.labelMedium!.copyWith(
                                  color: theme,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                )
              ],
            ),
          ),
          SizedBox(height: 10.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: truncate(),
                  style: context.textTheme.bodyLarge,
                ),
                TextSpan(
                  text: expanded ? " Read Less" : " Read More",
                  style: context.textTheme.bodyLarge!.copyWith(color: appRed),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => setState(() => expanded = !expanded),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          past
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rate",
                      style: context.textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    RatingStars(
                      value: stars,
                      onValueChanged: (val) => setState(() => stars = val),
                      starBuilder: (_, color) =>
                          Icon(Boxicons.bxs_star, color: color, size: 16.r),
                      starCount: 5,
                      starSize: 20.r,
                      starColor: appRed,
                      starOffColor: neutral,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "Helping us rate this event will help other users decide whether to attend "
                      "future events hosted by the creator",
                      style: context.textTheme.bodyLarge,
                    )
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    3,
                    (index) => GestureDetector(
                      onTap: () => setState(() => status = index),
                      child: Container(
                        width: 105.w,
                        height: 35.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.h),
                          color:
                              (index == status) ? appRed : Colors.transparent,
                          border: Border.all(
                            color: (index == status)
                                ? Colors.transparent
                                : (darkTheme ? neutral3 : fadedPrimary),
                          ),
                        ),
                        child: Text(
                          index == 0
                              ? "Interested"
                              : (index == 1 ? "Going" : "Not Interested"),
                          style: context.textTheme.bodyLarge!.copyWith(
                            color: (index == status)
                                ? theme
                                : (darkTheme ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}

class UserHeader extends ConsumerWidget {
  final EventData event;

  const UserHeader({super.key, required this.event});

  void goToProfile(WidgetRef ref, BuildContext context) {
    User currentUser = ref.watch(userProvider);
    if (event.author.uuid == currentUser.uuid) {
      context.router.pushNamed(Pages.profile);
    } else {
      context.router.pushNamed(
        Pages.otherProfile,
        pathParameters: {
          "id": event.author.uuid,
        },
      );
    }
  }

  bool shouldFollow(WidgetRef ref) {
    User currentUser = ref.watch(userProvider);
    if (event.author.uuid == currentUser.uuid) return false;
    if (currentUser.following.contains(event.author.uuid)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool darkTheme = context.isDark;

    return SizedBox(
      height: 40.r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: event.author.profilePicture,
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
                    onTap: () => goToProfile(ref, context),
                    child: CircleAvatar(
                      backgroundImage: provider,
                      radius: 20.r,
                    ),
                  );
                },
              ),
              SizedBox(width: 10.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 18.r,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: !shouldFollow(ref) ? 180.w : 140.w,
                          ),
                          child: GestureDetector(
                            onTap: () => goToProfile(ref, context),
                            child: Text(
                              event.author.username,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodyLarge!
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        if (shouldFollow(ref))
                          Skeleton.ignore(
                            ignore: true,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 10.w),
                                SizedBox(
                                  height: 15.r,
                                  width: 1.5.w,
                                  child: ColoredBox(
                                    color: darkTheme ? neutral : primary1,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                GestureDetector(
                                  onTap: () async {
                                    // await followUser(object.posterID);
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
                    "@${event.author.nickname}",
                    style: context.textTheme.labelMedium,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: 80.w,
            height: 18.r,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time.format(event.date),
                  style: context.textTheme.labelMedium!.copyWith(color: gray),
                ),
                GestureDetector(
                  onTap: () {},
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
