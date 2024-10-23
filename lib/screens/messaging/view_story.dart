import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/api/message_service.dart';
import 'package:rediones/components/media_data.dart';
import 'package:rediones/components/message_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/tools/widgets.dart';
import 'package:story_view/story_view.dart';
import 'package:timeago/timeago.dart';

class ViewStoryPage extends ConsumerStatefulWidget {
  final StoryData story;

  const ViewStoryPage({super.key, required this.story});

  @override
  ConsumerState<ViewStoryPage> createState() => _ViewStoryPageState();
}

class _ViewStoryPageState extends ConsumerState<ViewStoryPage> {
  final TextEditingController comment = TextEditingController();
  final StoryController storyController = StoryController();
  late List<StoryItem> storyItems;
  int index = 0;

  @override
  void initState() {
    super.initState();

    storyItems = List.generate(
      widget.story.stories.length,
      (index) => getStory(index),
    );
  }

  StoryItem getStory(int index) {
    MediaData data = widget.story.stories[index];
    if (data.type == MediaType.textOnly) {
      return StoryItem.text(
        title: data.caption,
        duration: const Duration(seconds: 5),
        textStyle: TextStyle(
          color: theme,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          fontFamily: "Nunito",
        ),
        backgroundColor: niceBlue,
      );
    } else if (data.type == MediaType.imageAndText) {
      return StoryItem.pageImage(
        url: data.mediaUrl,
        controller: storyController,
        duration: const Duration(seconds: 10),
        caption: Text(data.caption),
      );
    } else {
      return StoryItem.pageVideo(
        data.mediaUrl,
        controller: storyController,
        duration: const Duration(seconds: 30),
        caption: Text(data.caption),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentID = ref.watch(userProvider.select((u) => u.uuid));

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: 820.h,
              width: 390.w,
              child: StoryView(
                // color: Colors.black,
                storyItems: storyItems,
                controller: storyController,
                indicatorColor: neutral2,
                indicatorForegroundColor: appRed,
                progressPosition: ProgressPosition.top,
                onComplete: () => context.router.pop(),
                onStoryShow: (item, storyIndex) {
                  Future.delayed(Duration.zero, () {
                    if (widget.story.postedBy.id != currentID) {
                      viewStory(widget.story.stories[storyIndex].id);
                    }
                    setState(() => index = storyIndex);
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 10.w,
                right: 0.w,
                bottom: 10.h,
                top: 20.h,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          bool isCurrent =
                              currentID == widget.story.postedBy.id;
                          storyController.pause();
                          context.router.pushNamed(
                            isCurrent ? Pages.profile : Pages.otherProfile,
                            pathParameters: {"id": widget.story.postedBy.id},
                          ).then((resp) {
                            storyController.play();
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CachedNetworkImage(
                              imageUrl: widget.story.postedBy.profilePicture,
                              errorWidget: (_, __, val) => CircleAvatar(
                                radius: 18.r,
                                backgroundColor: appRed,
                              ),
                              progressIndicatorBuilder: (_, __, val) =>
                                  CircleAvatar(
                                radius: 18.r,
                                backgroundColor: appRed.withOpacity(0.6),
                              ),
                              imageBuilder: (_, provider) => CircleAvatar(
                                radius: 18.r,
                                backgroundImage: provider,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.story.postedBy.username,
                                  style: context.textTheme.titleSmall!.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Wrap(
                                  spacing: 5.w,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      "@${widget.story.postedBy.username}",
                                      style: context.textTheme.bodyMedium!
                                          .copyWith(
                                        color: theme.withOpacity(0.7),
                                      ),
                                    ),
                                    Container(
                                      width: 2.5.r,
                                      height: 2.5.r,
                                      decoration: const BoxDecoration(
                                        color: theme,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Text(
                                      format(widget
                                          .story.stories[index].timestamp),
                                      style: context.textTheme.bodyMedium!
                                          .copyWith(
                                        color: theme.withOpacity(0.7),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(0),
                        icon: Icon(
                          Icons.more_vert_rounded,
                          size: 26.r,
                          color: theme,
                        ),
                        onPressed: () {},
                        splashRadius: 0.01,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SpecialForm(
                        controller: comment,
                        action: TextInputAction.send,
                        width: 318.w,
                        hint: "Reply...",
                        height: 40.h,
                        style: context.textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                        ),
                        fillColor: Colors.transparent,
                        borderColor: theme,
                        hintStyle: context.textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Icon(
                        Icons.send_rounded,
                        size: 26.r,
                        color: appRed,
                      ),
                      //Text("Send", style: context.textTheme.bodyMedium)
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
