import 'package:badges/badges.dart' as bg;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rediones/components/media_data.dart';
import 'package:rediones/components/message_data.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:timeago/timeago.dart' as time;

import 'package:rediones/api/message_service.dart';

class MessagePage extends ConsumerStatefulWidget {
  const MessagePage({super.key});

  @override
  ConsumerState<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends ConsumerState<MessagePage>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  bool isSearchOpen = false;
  final TextEditingController search = TextEditingController();
  bool loadingConversations = true;

  late List<Conversation> dummyConversations;
  late String userID;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    dummyConversations = List.generate(
      5,
      (index) => Conversation(
        users: [dummyUser, dummyUser],
        lastMessage: loremIpsum.substring(50),
        timestamp: DateTime.now(),
      ),
    );

    userID = ref.read(userProvider).id;

    initConversations(ref)
        .then((value) => setState(() => loadingConversations = false));
  }

  Future<void> refresh() async {
    setState(() => loadingConversations = true);
    initConversations(ref)
        .then((value) => setState(() => loadingConversations = false));
  }

  void openInbox(Conversation conversation) =>
      context.router.pushNamed(Pages.inbox, extra: conversation);

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;
    List<StoryData> stories = ref.watch(storiesProvider);
    List<Conversation> lastMessages = ref.watch(conversationsProvider);
    List<LastMessageData> requests = [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 26.r,
          splashRadius: 0.01,
          icon: const Icon(Icons.chevron_left),
          onPressed: () => context.router.pop(),
        ),
        elevation: 0.0,
        title: Text(
          "Inbox",
          style: context.textTheme.titleLarge,
        ),
        actions: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: SizedBox(height: 40.h,
                width: 40.h,
                child: SvgPicture.asset("assets/Search Icon.svg",
                  width: 20.h,
                  height: 20.h,
                  color: darkTheme ? Colors.white54 : Colors.black45,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 120.r,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) => index == 0
                      ? const _AddStory()
                      : StoryContainer(
                          data: stories[index - 1],
                          onClick: () {
                            unFocus();
                            context.router.pushNamed(Pages.viewStory,
                                extra: stories[index - 1]);
                          },
                        ),
                  separatorBuilder: (_, __) => SizedBox(width: 15.w),
                  itemCount: stories.length + 1,
                ),
              ),
            ),
            SizedBox(height: 25.h),
            Container(
              width: 390.w,
              height: 5.h,
              color: darkTheme ? Colors.white12 : Colors.black12,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                children: [
                  TabBar(
                    controller: controller,
                    tabs: [
                      Tab(
                        child:
                            Text("Chats", style: context.textTheme.bodyLarge),
                      ),
                      Tab(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Requests (",
                                style: context.textTheme.bodyMedium,
                              ),
                              TextSpan(
                                text: "${requests.length}",
                                style: context.textTheme.bodyMedium!
                                    .copyWith(color: appRed),
                              ),
                              TextSpan(
                                text: ")",
                                style: context.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  GestureDetector(
                    onTap: () => context.router.pushNamed(Pages.messagePocket),
                    child: Container(
                      width: 390.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: darkTheme ? neutral3 : fadedPrimary),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          "Pocket",
                          style: context.textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    height: 465.h,
                    child: loadingConversations
                        ? Skeletonizer(
                          enabled: true,
                          child: ListView.separated(
                            itemCount: dummyConversations.length,
                            itemBuilder: (_, index) => LastMessageContainer(
                              data: dummyConversations[index],
                              currentID: userID,
                              onOpen: () {},
                            ),
                            separatorBuilder: (_, __) =>
                                SizedBox(height: 20.h),
                          ),
                        )
                        : TabBarView(
                            controller: controller,
                            children: [
                              lastMessages.isEmpty
                                  ? GestureDetector(
                                onTap: refresh,
                                child: Center(
                                  child: Text(
                                    "No conversations available. Tap to refresh",
                                    style: context.textTheme.bodyLarge,
                                  ),
                                ),
                              )
                                  : AnimationLimiter(
                                child: RefreshIndicator(
                                  onRefresh: refresh,
                                  child: ListView.separated(
                                    itemBuilder: (_, index) =>
                                        AnimationConfiguration
                                            .staggeredList(
                                          position: index,
                                          duration: const Duration(
                                              milliseconds: 750),
                                          child: SlideAnimation(
                                            verticalOffset: 25.h,
                                            child: FadeInAnimation(
                                              child: LastMessageContainer(
                                                currentID: userID,
                                                onOpen: () => openInbox(
                                                    lastMessages[index]),
                                                data: lastMessages[index],
                                              ),
                                            ),
                                          ),
                                        ),
                                    separatorBuilder: (_, __) =>
                                        SizedBox(height: 15.h),
                                    itemCount: lastMessages.length,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 470.h,
                                child: ListView.separated(
                                  itemBuilder: (_, index) =>
                                      LastMessageContainer(
                                    onOpen: () {},
                                    currentID: userID,
                                    data: lastMessages[index],
                                  ),
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: 15.h),
                                  itemCount: requests.length,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StoryContainer extends StatelessWidget {
  final StoryData data;
  final VoidCallback onClick;
  final bool addStory;

  const StoryContainer({
    super.key,
    required this.data,
    required this.onClick,
    this.addStory = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: 90.r,
        height: 120.r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          image: DecorationImage(
            image: AssetImage(data.stories.last.mediaUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          width: 90.r,
          height: 120.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.black45,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 55.r,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: 90.r,
                        height: 35.r,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 15.r),
                            SizedBox(
                              height: 20.r,
                              child: Text(
                                data.postedBy.username,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.bodyMedium!.copyWith(
                                    color: theme, fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5.h,
                      left: 29.r,
                      child: CircleAvatar(
                        radius: 15.r,
                        backgroundColor: appRed,
                        child: CircleAvatar(
                          radius: 13.r,
                          backgroundImage:
                              NetworkImage(data.postedBy.profilePicture),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// CachedNetworkImage(
// imageUrl: widget.post.poster.profilePicture,
// errorWidget: (context, url, error) =>
// CircleAvatar(
// backgroundColor: neutral2,
// radius: 18.r,
// child: Icon(Icons.person_outline_rounded,
// color: Colors.black, size: 12.r),
// ),
// progressIndicatorBuilder: (context, url, download) {
// return Container(
// width: 35.r,
// height: 35.r,
// decoration: const BoxDecoration(
// shape: BoxShape.circle,
// color: neutral2,
// ),
// );
// },
// imageBuilder: (context, provider) {
// return CircleAvatar(
// backgroundImage: provider,
// radius: 20.r,
// );
// },
// ),

class _AddStory extends ConsumerWidget {
  const _AddStory();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String image = ref.read(userProvider).profilePicture;

    return GestureDetector(
      onTap: () => context.router.pushNamed(Pages.createStory),
      child: Container(
        width: 90.r,
        height: 120.r,
        decoration: BoxDecoration(
          border: Border.all(color: context.isDark ? neutral3 : fadedPrimary),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 20.r,
              width: 20.r,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Center(
                child: Icon(Icons.add_rounded, color: theme, size: 16.r),
              ),
            ),
            SizedBox(
              height: 55.r,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipPath(
                      clipper: BottomNavBarClipper(
                          borderRadius: 10.r, cutoutRadius: 16.r),
                      child: SizedBox(
                        width: 90.r,
                        height: 35.r,
                        child: ColoredBox(
                          color: appRed,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 15.r),
                              Text(
                                "Add Story",
                                style: context.textTheme.bodyMedium!.copyWith(
                                    color: theme, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5.h,
                    left: 29.r,
                    child: CircleAvatar(
                      radius: 15.r,
                      backgroundColor: appRed,
                      child: CircleAvatar(
                        radius: 13.r,
                        backgroundImage: NetworkImage(image),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LastMessageContainer extends StatelessWidget {
  final Conversation data;
  final String currentID;
  final VoidCallback onOpen;

  const LastMessageContainer({
    super.key,
    required this.data,
    required this.currentID,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    late User? sender;
    sender = data.users.firstWhere((element) => element.id != currentID,
        orElse: () => dummyUser);

    return GestureDetector(
      onTap: onOpen,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: sender.profilePicture,
            errorWidget: (context, url, error) => CircleAvatar(
              backgroundColor: neutral2,
              radius: 22.r,
              child: Icon(Icons.person_outline_rounded,
                  color: Colors.black, size: 16.r),
            ),
            progressIndicatorBuilder: (context, url, download) {
              return Container(
                width: 35.r,
                height: 35.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: neutral2,
                ),
              );
            },
            imageBuilder: (context, provider) {
              return CircleAvatar(
                backgroundImage: provider,
                foregroundColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                radius: 22.r,
                child: Align(
                  alignment: Alignment.topRight,
                  child: SvgPicture.asset("assets/Green Dot.svg"),
                ),
              );
            },
          ),
          SizedBox(width: 10.w),
          SizedBox(
            width: 250.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  sender.username,
                  style: context.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 5.h),
                Text(
                  data.lastMessage,
                  style: context.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5.h),
                Text(
                  time.format(data.timestamp!),
                  style: context.textTheme.bodySmall,
                )
              ],
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Skeleton.ignore(
              ignore: true,
              child: bg.Badge(
                badgeStyle: const bg.BadgeStyle(
                  badgeColor: appRed,
                  elevation: 1.0,
                ),
                showBadge: true,
                badgeContent: Text("0",
                    style: context.textTheme.bodySmall!.copyWith(color: theme)),
              ),
            )
          )
        ],
      ),
    );
  }
}
