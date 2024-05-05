import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/components/community_data.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/tools/constants.dart';


import 'package:rediones/tools/widgets.dart';

class CommunityChatPage extends ConsumerStatefulWidget {
  final CommunityData data;

  const CommunityChatPage({super.key, required this.data});

  @override
  ConsumerState<CommunityChatPage> createState() => _CommunityChatPageState();
}

class _CommunityChatPageState extends ConsumerState<CommunityChatPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  bool expanded = false;

  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<CommunityChatData> communityChats = ref.watch(communityChatProvider);
    bool darkTheme = context.isDark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 26.r,
          splashRadius: 0.01,
          icon: const Icon(Icons.chevron_left),
          onPressed: () => context.router.pop(),
        ),
        elevation: 0.0,
        centerTitle: true,
        title: GestureDetector(
          onTap: () => setState(() {
            expanded = !expanded;
            if (expanded) {
              controller.forward();
            } else {
              controller.reverse();
            }
          }),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.data.name,
                style: context.textTheme.titleLarge,
              ),
              SizedBox(width: 5.w),
              Icon(Icons.keyboard_arrow_down_rounded, size: 26.r)
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: ListView.separated(
                itemBuilder: (_, index) {
                  if (index == communityChats.length) {
                    return SizedBox(height: 50.h);
                  }

                  return _CommunityChatContainer(data: communityChats[index]);
                },
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemCount: communityChats.length + 1,
              ),
            ),
            SizeTransition(
              sizeFactor: animation,
              child: Container(
                width: 390.w,
                height: 800.h,
                color: darkTheme ? Colors.black : Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10.h),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Announcement (7)",
                        style: context.textTheme.bodyLarge!.copyWith(
                            color: darkTheme ? neutral3 : midPrimary),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () => setState(() {
                        expanded = false;
                        controller.reverse().then((_) => context.router
                            .pushNamed(Pages.communityParticipants,
                                extra: widget.data));
                      }),
                      child: Text(
                        "Participants (500)",
                        style: context.textTheme.bodyLarge!.copyWith(
                            color: darkTheme ? neutral3 : midPrimary),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () => setState(() {
                        expanded = false;
                        controller.reverse().then((_) => context.router
                            .pushNamed(Pages.communityLibrary,
                                extra: widget.data));
                      }),
                      child: Text(
                        "Library (15)",
                        style: context.textTheme.bodyLarge!.copyWith(
                            color: darkTheme ? neutral3 : midPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 500),
        child: SizedBox(
          height: 60.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.add_circle,
                    size: 36.r,
                  ),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.mic_rounded,
                    size: 28.r,
                  ),
                ),
                SizedBox(width: 8.w),
                SpecialForm(
                  controller: textController,
                  fillColor: Colors.transparent,
                  borderColor: neutral,
                  width: 250.w,
                  height: 40.h,
                  hint: "Type your message",
                  maxLines: 1,
                  prefix: Icon(Icons.emoji_emotions_rounded, size: 26.r),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.send_rounded,
                    size: 28.r,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CommunityChatContainer extends ConsumerWidget {
  final CommunityChatData data;

  const _CommunityChatContainer({
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String currentUserID = ref.watch(userProvider).id;
    bool darkTheme = context.isDark;
    bool isCurrentUser = currentUserID == data.userId;

    return Row(
      crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (!isCurrentUser)
          CircleAvatar(
            radius: 18.r,
            backgroundImage: AssetImage(data.image),
          ),
        if (!isCurrentUser) SizedBox(width: 10.w),
        SizedBox(
          width: isCurrentUser ? 365.w : null,
          child: Column(
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    if (isCurrentUser)
                      TextSpan(
                        text: "7:44 am  ",
                        style: context.textTheme.bodySmall!.copyWith(
                            fontSize: 10,
                            color: darkTheme ? offWhite : midPrimary),
                      ),
                    TextSpan(
                      text: data.username,
                      style: context.textTheme.bodySmall!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    if (!isCurrentUser)
                      TextSpan(
                        text: "  7:44 am",
                        style: context.textTheme.bodySmall!.copyWith(
                            fontSize: 10,
                            color: darkTheme ? offWhite : midPrimary),
                      )
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 320.w,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: isCurrentUser
                            ? appRed.withOpacity(0.6)
                            : darkTheme
                                ? neutral
                                : fadedPrimary),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Text(data.message),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
