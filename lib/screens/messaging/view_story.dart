import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/components/media_data.dart';
import 'package:rediones/components/message_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/widgets.dart';
import 'package:story_view/story_view.dart';
import 'package:timeago/timeago.dart';

class ViewStoryPage extends StatefulWidget {
  final StoryData story;

  const ViewStoryPage({Key? key, required this.story}) : super(key: key);

  @override
  State<ViewStoryPage> createState() => _ViewStoryPageState();
}

class _ViewStoryPageState extends State<ViewStoryPage> {
  final TextEditingController comment = TextEditingController();
  final StoryController storyController = StoryController();
  late List<StoryItem> storyItems;
  int index = 0;

  @override
  void initState() {
    super.initState();

    storyItems = List.generate(widget.story.stories.length, (index) => getStory(index));
  }

  StoryItem getStory(int index) {
    MediaData data = widget.story.stories[index];
    if (data.type == MediaType.textOnly) {
      return StoryItem.text(title: data.caption,
          duration: const Duration(seconds: 5),
          textStyle: TextStyle(color: theme, fontSize: 18.sp, fontWeight: FontWeight.w600, fontFamily: "Nunito"),
          backgroundColor: niceBlue);
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        foregroundColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            AssetImage(widget.story.postedBy.profilePicture),
                        radius: 18.r,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.story.postedBy.username,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.w700)),
                          SizedBox(height: 4.h),
                          Wrap(
                            spacing: 5.w,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text("@${widget.story.postedBy.nickname}",
                                  style: context.textTheme.bodySmall),
                              Container(
                                color: appRed,
                                width: 2.w,
                                height: 10.h,
                              ),
                              Text(
                                  format(widget.story.stories[index].timestamp),
                                  style: context.textTheme.bodySmall)
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.more_horiz_rounded, size: 26.r),
                    onPressed: () {},
                    splashRadius: 0.01,
                  )
                ],
              ),
              SizedBox(height: 20.h),
              SizedBox(
                height: 670.h,
                width: 390.w,
                child: StoryView(
                  storyItems: storyItems,
                  controller: storyController,
                  indicatorColor: appRed,
                  onComplete: () => context.router.pop(),
                  onStoryShow: (item, storyIndex) {
                    setState(() => index = storyIndex);
                  },
                ),
              ),
              SizedBox(height: 5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SpecialForm(
                    controller: comment,
                    action: TextInputAction.send,
                    width: 318.w,
                    hint: "Reply",
                    height: 40.h,
                    prefix: IconButton(
                        icon:
                            Icon(Boxicons.bx_smile, color: appRed, size: 22.r),
                        onPressed: () {}),
                  ),
                  Icon(Icons.send_rounded, size: 26.r),
                  //Text("Send", style: context.textTheme.bodyMedium)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
