import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:intl/intl.dart';
import 'package:rediones/components/event_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';



class EventContainer extends StatefulWidget {
  final EventData data;

  const EventContainer({super.key, required this.data});

  @override
  State<EventContainer> createState() => _EventContainerState();
}

class _EventContainerState extends State<EventContainer> {
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
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      width: 390.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: darkTheme ? neutral : fadedPrimary),
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Text(
              widget.data.header,
              style: context.textTheme.bodyLarge!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: 390.w,
            height: 200.h,
            child: Stack(children: [
              CachedNetworkImage(
                imageUrl: widget.data.cover,
                errorWidget: (context, url, error) => Container(
                  width: 390.w,
                  height: 200.h,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/error.jpeg"),
                        fit: BoxFit.fill),
                  ),
                ),
                progressIndicatorBuilder: (context, url, download) => Center(
                  child: CircularProgressIndicator(
                      color: appRed, value: download.progress),
                ),
                imageBuilder: (context, provider) => Container(
                  width: 390.w,
                  height: 200.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: provider, fit: BoxFit.cover),
                  ),
                ),
              ),
              Positioned(
                bottom: 20.h,
                left: 45.w,
                right: 45.w,
                child: GlassmorphicContainer(
                  width: 300.w,
                  height: 50.h,
                  borderRadius: 15.r,
                  blur: 10,
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
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 75.w,
                        child: Center(
                          child: Text(widget.data.location,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodySmall!
                                  .copyWith(color: theme)),
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
                                shorten: true),
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmall!
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
                            style: context.textTheme.bodySmall!
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
                  height: 18.h,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                      horizontal: 5.w, vertical: 2.h),
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
                      Icon(Boxicons.bxs_star, color: appRed, size: 14.r),
                      SizedBox(width: 2.w),
                      Text(
                        widget.data.rating.toStringAsFixed(1),
                        style: context.textTheme.labelSmall!.copyWith(
                            color: theme, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                )
                    : const SizedBox(),
              )
            ]),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 5.w,
                  children: [
                    Text(truncate(), style: context.textTheme.bodyMedium),
                    GestureDetector(
                      onTap: () => setState(() => expanded = !expanded),
                      child: Text(
                        expanded ? "Read Less" : "Read More",
                        style: context.textTheme.bodyMedium!
                            .copyWith(color: appRed),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                SizedBox(height: 10.h),
                past
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Rate",
                        style: context.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.w700)),
                    SizedBox(height: 5.h),
                    RatingStars(
                      value: stars,
                      onValueChanged: (val) =>
                          setState(() => stars = val),
                      starBuilder: (_, color) => Icon(Boxicons.bxs_star,
                          color: color, size: 16.r),
                      starCount: 5,
                      starSize: 20.r,
                      starColor: appRed,
                      starOffColor: neutral,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "Helping us rate this event will help other users decide whether to attend "
                          "future events hosted by the creator",
                      style: context.textTheme.bodySmall,
                    )
                  ],
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    3,
                        (index) => GestureDetector(
                      onTap: () => setState(() => status = index),
                      child: Container(
                        width: 100.w,
                        height: 40.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.h),
                          color: (index == status)
                              ? appRed
                              : Colors.transparent,
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
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: (index == status)
                                ? theme
                                : (darkTheme
                                ? Colors.white
                                : Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}