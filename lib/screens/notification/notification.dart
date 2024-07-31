import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rediones/api/notification_service.dart';
import 'package:rediones/components/notification_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/tools/widgets.dart';
import 'package:timeago/timeago.dart' as time;

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage>
    with SingleTickerProviderStateMixin {
  final List<NotificationData> filtered = [];
  late TabController controller;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    fetch();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void fetch() => getNotifications().then(
        (response) {
          if (mounted) {
            ref.watch(notificationsProvider).clear();
            ref.watch(notificationsProvider).addAll(response.payload);
            setState(() => loading = false);
          }
        },
      );

  Future<void> refresh() async {
    setState(() => loading = true);
    fetch();
  }

  void checkForChanges() {
    ref.listen(isLoggedInProvider, (oldVal, newVal) {
      if (!oldVal! && newVal) {
        refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    checkForChanges();
    List<NotificationData> notifications = ref.watch(notificationsProvider);
    String username = ref.watch(userProvider).username;

    return NestedScrollView(
      headerSliverBuilder: (context, isScrolled) => [
        SliverPadding(
          padding: EdgeInsets.only(left: 15.w, top: 10.h),
          sliver: SliverToBoxAdapter(
            child: Text(
              "Notifications",
              style: context.textTheme.titleLarge,
            ),
          ),
        ),
        SliverPersistentHeader(
          delegate: TabHeaderDelegate(
            tabBar: TabBar(
              controller: controller,
              indicatorColor: appRed,
              dividerColor: context.isDark ? Colors.white12 : Colors.black12,
              labelColor: appRed,
              labelPadding: EdgeInsets.symmetric(horizontal: 5.w),
              labelStyle: context.textTheme.titleSmall!
                  .copyWith(fontWeight: FontWeight.w600),
              unselectedLabelStyle: context.textTheme.titleSmall!
                  .copyWith(fontWeight: FontWeight.w500),
              tabs: const [
                Tab(text: "All"),
                Tab(text: "Verified"),
                Tab(text: "Tags & Mention")
              ],
            ),
          ),
          pinned: true,
        ),
      ],
      body: TabBarView(
        controller: controller,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Expanded(
                  child: loading
                      ? const CenteredPopup()
                      : (notifications.isEmpty)
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
                                    "There are no notifications available",
                                    style:
                                        context.textTheme.titleSmall!.copyWith(
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
                          : RefreshIndicator(
                              onRefresh: refresh,
                              child: ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemCount: notifications.length + 1,
                                itemBuilder: (_, index) =>
                                    (index == notifications.length)
                                        ? SizedBox(height: 100.h)
                                        : NotificationHeader(
                                            notifications[index],
                                            username: username,
                                          ),
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 20.h),
                              ),
                            ),
                ),
              ],
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
                  "There are no verified notifications available",
                  style: context.textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: refresh,
                  child: Text(
                    "Refresh",
                    style: context.textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: appRed,
                    ),
                  ),
                ),
              ],
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
                  "There are no tags and mentions available",
                  style: context.textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: refresh,
                  child: Text(
                    "Refresh",
                    style: context.textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: appRed,
                    ),
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

class NotificationHeader extends StatefulWidget {
  final NotificationData notification;
  final String username;

  const NotificationHeader(this.notification, {super.key, this.username = ""});

  @override
  State<NotificationHeader> createState() => _NotificationHeaderState();
}

class _NotificationHeaderState extends State<NotificationHeader> {
  void showExtra() => showModalBottomSheet(
        context: context,
        showDragHandle: true,
        builder: (context) => SizedBox(
          height: 270.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                leading: SvgPicture.asset("assets/Less Often.svg"),
                title: Text(
                  "See this notification less often",
                  style: context.textTheme.bodyLarge,
                ),
                onTap: () {},
              ),
              ListTile(
                leading: SvgPicture.asset("assets/Unfollow User.svg"),
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Unfollow ",
                        style: context.textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: "@${widget.notification.postedBy.nickname}",
                        style: context.textTheme.bodyMedium!
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: SvgPicture.asset("assets/Block User.svg"),
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Block ",
                        style: context.textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: "@${widget.notification.postedBy.nickname}",
                        style: context.textTheme.bodyMedium!
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: SvgPicture.asset("assets/Mute User.svg"),
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Mute ",
                        style: context.textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: "@${widget.notification.postedBy.nickname}",
                        style: context.textTheme.bodyMedium!
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      );

  void read() {
    bool currentState = widget.notification.opened;
    if (currentState) return;

    setState(() => widget.notification.opened = !currentState);
    readNotification(widget.notification.id).then((resp) {
      if (resp.status == Status.failed) {
        setState(() => widget.notification.opened = currentState);
        showToast(resp.message, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: read,
      child: SizedBox(
        width: 390.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: widget.notification.postedBy.profilePicture,
              errorWidget: (context, url, error) => CircleAvatar(
                backgroundColor: neutral2,
                radius: 20.r,
                child: Icon(Icons.person_outline_rounded,
                    color: Colors.black, size: 16.r),
              ),
              progressIndicatorBuilder: (context, url, download) => Container(
                width: 40.r,
                height: 40.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: neutral2,
                ),
              ),
              imageBuilder: (context, provider) => CircleAvatar(
                backgroundImage: provider,
                radius: 20.r,
              ),
            ),
            SizedBox(
              width: 270.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 270.w,
                    child: Row(
                      children: [
                        if (!widget.notification.opened)
                          Container(
                            width: 6.r,
                            height: 6.r,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: appRed,
                            ),
                          ),
                        if (!widget.notification.opened) SizedBox(width: 5.w),
                        SizedBox(
                          width: widget.notification.opened ? 270.w : 250.w,
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "@${widget.notification.postedBy.nickname}",
                                  style: context.textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: " ${widget.notification.header}",
                                  style: context.textTheme.bodyLarge,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 270.w,
                    child: Text(
                      widget.notification.content,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyLarge,
                    ),
                  ),
                  Text(
                    time.format(widget.notification.date),
                    style: context.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert_rounded),
              iconSize: 26.r,
              splashRadius: 20.r,
              onPressed: showExtra,
            ),
          ],
        ),
      ),
    );
  }
}
