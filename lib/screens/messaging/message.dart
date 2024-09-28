import 'package:badges/badges.dart' as bg;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rediones/api/file_handler.dart';
import 'package:rediones/api/message_service.dart';
import 'package:rediones/components/media_data.dart';
import 'package:rediones/components/message_data.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/tools/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:timeago/timeago.dart' as time;

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
  bool loadingConversations = true, loadingStories = true;

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

    userID = ref.read(userProvider).uuid;

    // getLocalConversations();
    Future.delayed(Duration.zero, () {
      fetchStories();
      fetchConversations();
    });
  }

  Future<void> fetchConversations() async {
    var response = await getConversations();
    if (!mounted) return;

    List<Conversation> p = response.payload;
    if (response.status == Status.failed) {
      showToast(response.message, context);
      setState(() => loadingConversations = false);
      return;
    }

    List<Conversation> con = ref.watch(conversationsProvider);
    con.clear();
    con.addAll(p);

    setState(() => loadingConversations = false);
  }

  void showMessage(String msg) => showToast(msg, context);

  Future<void> fetchStories() async {
    var resp = await getStories(ref.watch(userProvider).uuid);
    if (!mounted) return;

    if (resp.status == Status.failed) {
      showMessage(resp.message);
      return;
    }

    List<StoryData> stories = ref.watch(storiesProvider);
    stories.clear();
    stories.addAll(resp.payload.otherStories);

    ref.watch(currentUserStory.notifier).state = resp.payload.currentUserStory;

    setState(() => loadingStories = false);
  }

  Future<void> refresh() async {
    setState(() => loadingConversations = true);
    fetchConversations();
  }

  void openInbox(Conversation conversation) {
    context.router.pushNamed(
      Pages.inbox,
      extra: conversation,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;
    List<StoryData> stories = ref.watch(storiesProvider);
    List<Conversation> lastMessages = ref.watch(conversationsProvider);
    List<Conversation> requests = [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 26.r,
          splashRadius: 0.01,
          icon: const Icon(Icons.chevron_left),
          onPressed: () => context.router.pop(),
        ),
        leadingWidth: 30.w,
        elevation: 0.0,
        title: Text(
          "Inbox",
          style: context.textTheme.titleLarge,
        ),
        // actions: [
        //   Align(
        //     alignment: Alignment.centerRight,
        //     child: Padding(
        //       padding: EdgeInsets.only(right: 10.w),
        //       child: SizedBox(
        //         height: 40.h,
        //         width: 40.h,
        //         child: SvgPicture.asset(
        //           "assets/Search Icon.svg",
        //           width: 20.h,
        //           height: 20.h,
        //           color: darkTheme ? Colors.white54 : Colors.black45,
        //           fit: BoxFit.scaleDown,
        //         ),
        //       ),
        //     ),
        //   )
        // ],
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
                  itemBuilder: (_, index) {
                    if (index == 0) {
                      return const _AddStory();
                    }

                    if (loadingStories) {
                      return Skeletonizer(
                        enabled: true,
                        child: StoryContainer(
                          data: StoryData(
                            postedBy: const UserSubData(),
                            stories: [
                              MediaData(
                                mediaUrl: "mediaUrl",
                                type: MediaType.videoAndText,
                                views: 12,
                                timestamp: DateTime.now(),
                              ),
                            ],
                          ),
                          onClick: () {},
                        ),
                      );
                    }

                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 750),
                      child: SlideAnimation(
                        horizontalOffset: 25.w,
                        child: FadeInAnimation(
                          child: StoryContainer(
                            key: ValueKey<String>(stories[index - 1].id),
                            data: stories[index - 1],
                            onClick: () {
                              unFocus();
                              context.router.pushNamed(
                                Pages.viewStory,
                                extra: stories[index - 1],
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => SizedBox(width: 15.w),
                  itemCount: loadingStories ? 5 : stories.length + 1,
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
                    indicatorColor: appRed,
                    labelStyle: context.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.w700),
                    unselectedLabelStyle:
                        context.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                    tabs: [
                      const Tab(
                        text: "Chats",
                      ),
                      Tab(
                        text: "Requests (${requests.length})",
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
                          color: darkTheme ? neutral3 : fadedPrimary,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          "Pocket",
                          style: context.textTheme.titleSmall!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                ],
              ),
            ),
            Expanded(
              child: loadingConversations
                  ? Skeletonizer(
                      enabled: true,
                      child: ListView.builder(
                        itemCount: dummyConversations.length,
                        itemBuilder: (_, index) => LastMessageContainer(
                          data: dummyConversations[index],
                          currentID: userID,
                          onOpen: () {},
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                      ),
                    )
                  : TabBarView(
                      controller: controller,
                      children: [
                        lastMessages.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/No Data.png",
                                      width: 150.r,
                                      height: 150.r,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(height: 20.h),
                                    Text(
                                      "There are no messages available",
                                      style: context.textTheme.titleSmall!
                                          .copyWith(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    GestureDetector(
                                      onTap: refresh,
                                      child: Text(
                                        "Refresh",
                                        style: context.textTheme.titleSmall!
                                            .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: appRed,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : AnimationLimiter(
                                child: RefreshIndicator(
                                  onRefresh: refresh,
                                  child: ListView.builder(
                                    itemBuilder: (_, index) =>
                                        AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration: const Duration(
                                        milliseconds: 750,
                                      ),
                                      child: SlideAnimation(
                                        verticalOffset: 25.h,
                                        child: FadeInAnimation(
                                          child: LastMessageContainer(
                                            key: ValueKey<String>(lastMessages[index].id),
                                            currentID: userID,
                                            onOpen: () =>
                                                openInbox(lastMessages[index]),
                                            data: lastMessages[index],
                                          ),
                                        ),
                                      ),
                                    ),
                                    itemCount: lastMessages.length,
                                  ),
                                ),
                              ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/No Data.png",
                                width: 150.r,
                                height: 150.r,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                "There are no message requests available",
                                style: context.textTheme.titleSmall!.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
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
      child: CachedNetworkImage(
        imageUrl: data.stories.last.mediaUrl,
        errorWidget: (_, __, ___) {
          return Container(
            width: 90.r,
            height: 120.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: neutral2,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.broken_image_outlined,
              color: appRed,
              size: 26.r,
            ),
          );
        },
        progressIndicatorBuilder: (_, __, ___) {
          return Container(
            width: 90.r,
            height: 120.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: neutral2,
            ),
          );
        },
        imageBuilder: (_, provider) {
          return Container(
            width: 90.r,
            height: 120.r,
            padding: EdgeInsets.symmetric(horizontal: 5.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              image: DecorationImage(
                image: provider,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Skeleton.ignore(
              ignore: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Skeleton.ignore(
                    ignore: true,
                    child: CircleAvatar(
                      radius: 15.r,
                      backgroundColor: appRed,
                      child: CachedNetworkImage(
                        imageUrl: data.postedBy.profilePicture,
                        errorWidget: (_, __, val) => CircleAvatar(
                          radius: 13.5.r,
                          backgroundColor: appRed,
                        ),
                        progressIndicatorBuilder: (_, __, val) => CircleAvatar(
                          radius: 13.5.r,
                          backgroundColor: appRed.withOpacity(0.6),
                        ),
                        imageBuilder: (_, provider) => CircleAvatar(
                          radius: 13.5.r,
                          backgroundImage: provider,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.r),
                  SizedBox(
                    height: 20.r,
                    child: Text(
                      data.postedBy.username,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyMedium!.copyWith(
                        color: theme,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AddStory extends ConsumerStatefulWidget {
  const _AddStory();

  @override
  ConsumerState<_AddStory> createState() => _AddStoryState();
}

class _AddStoryState extends ConsumerState<_AddStory> {
  void navigate(SingleFileResponse resp) =>
      context.router.pushNamed(Pages.createStory, extra: resp);

  void showMedia() => FileHandler.single(type: FileType.media).then((resp) {
        if (resp == null) return;
        navigate(resp);
      });

  void selectStory() {
    List<MediaData> stories =
        ref.watch(currentUserStory.select((u) => u.stories));
    bool hasStory = stories.isNotEmpty;

    if (hasStory) {
      showModalBottomSheet(
        context: context,
        builder: (ctx) => SizedBox(
          height: 180.h,
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.add_rounded,
                  size: 26.r,
                  color: appRed,
                ),
                title: Text(
                  "Add Story",
                  style: context.textTheme.titleSmall,
                ),
                subtitle: Text(
                  "Add a new story",
                  style: context.textTheme.bodyMedium,
                ),
                onTap: () {
                  Navigator.of(ctx).pop();
                  showMedia();
                },
              ),
              ListTile(
                onTap: () {
                  Navigator.of(ctx).pop();
                  context.router.pushNamed(
                    Pages.viewStory,
                    extra: ref.watch(currentUserStory),
                  );
                },
                leading: Icon(
                  Icons.image_outlined,
                  size: 26.r,
                  color: appRed,
                ),
                title: Text(
                  "View Story",
                  style: context.textTheme.titleSmall,
                ),
                subtitle: Text(
                  "View all the stories you uploaded",
                  style: context.textTheme.bodyMedium,
                ),
              )
            ],
          ),
        ),
        showDragHandle: true,
      );
    } else {
      showMedia();
    }
  }

  @override
  Widget build(BuildContext context) {
    String image = ref.read(userProvider).profilePicture;
    List<MediaData> stories =
        ref.watch(currentUserStory.select((u) => u.stories));
    bool hasStory = stories.isNotEmpty;

    Stack content = Stack(
      children: [
        Column(
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
              alignment: Alignment.center,
              child: Icon(
                Icons.add_rounded,
                color: theme,
                size: 16.r,
              ),
            ),
            SizedBox(height: 25.r),
            ClipPath(
              clipper: StoryClipper(
                borderRadius: 3.r,
                cutoutRadius: 17.r,
                containerRadius: 10.r,
              ),
              child: SizedBox(
                width: 90.r,
                height: 40.r,
                child: const ColoredBox(
                  color: appRed,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: 90.r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 15.r,
                backgroundColor: appRed,
                child: CachedNetworkImage(
                  imageUrl: image,
                  errorWidget: (_, __, val) => CircleAvatar(
                    radius: 13.5.r,
                    backgroundColor: neutral2,
                  ),
                  progressIndicatorBuilder: (_, __, val) => CircleAvatar(
                    radius: 13.5.r,
                    backgroundColor: neutral2,
                  ),
                  imageBuilder: (_, provider) => CircleAvatar(
                    radius: 13.5.r,
                    backgroundImage: provider,
                  ),
                ),
              ),
              SizedBox(height: 5.r),
              SizedBox(
                height: 20.r,
                child: Text(
                  "Add Story",
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: theme,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: selectStory,
      child: CachedNetworkImage(
        imageUrl: hasStory ? stories.last.mediaUrl : "",
        errorWidget: (_, __, ___) {
          return Container(
            width: 90.r,
            height: 120.r,
            decoration: BoxDecoration(
              border:
                  Border.all(color: context.isDark ? neutral3 : fadedPrimary),
              borderRadius: BorderRadius.circular(10.r),
              color: hasStory ? appRed : null,
            ),
            alignment: Alignment.center,
            child: hasStory
                ? Icon(
                    Icons.broken_image_outlined,
                    color: theme,
                    size: 26.r,
                  )
                : content,
          );
        },
        progressIndicatorBuilder: (_, __, ___) {
          return Container(
            width: 90.r,
            height: 120.r,
            decoration: BoxDecoration(
              color: neutral2,
              borderRadius: BorderRadius.circular(10.r),
            ),
          );
        },
        imageBuilder: (_, provider) {
          return Container(
            width: 90.r,
            height: 120.r,
            decoration: BoxDecoration(
              border:
                  Border.all(color: context.isDark ? neutral3 : fadedPrimary),
              borderRadius: BorderRadius.circular(10.r),
              image: DecorationImage(
                image: provider,
                fit: BoxFit.cover,
              ),
            ),
            child: content,
          );
        },
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
    sender = data.users.firstWhere(
      (element) => element.uuid != currentID,
      orElse: () => dummyUser,
    );

    return ListTile(
      onTap: onOpen,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 15.w,
        vertical: 0.h,
      ),
      leading: CachedNetworkImage(
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
      title: Text(
        sender.username,
        style: context.textTheme.titleSmall!.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.lastMessage,
            style: context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Text(
            time.format(data.timestamp!),
            style: context.textTheme.bodySmall,
          ),
        ],
      ),
      trailing: Skeleton.ignore(
        ignore: true,
        child: bg.Badge(
          badgeStyle: const bg.BadgeStyle(
            badgeColor: appRed,
            elevation: 1.0,
          ),
          showBadge: true,
          badgeContent: Text(
            "0",
            style: context.textTheme.bodySmall!.copyWith(color: theme),
          ),
        ),
      ),
    );
  }
}
