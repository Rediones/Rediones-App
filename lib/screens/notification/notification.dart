import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rediones/api/notification_service.dart';
import 'package:rediones/components/notification_data.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/widgets.dart';
import 'package:timeago/timeago.dart' as time;

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage>
    with SingleTickerProviderStateMixin {
  final List<NotificationData> filtered = [];
  late TabController controller;
  bool loaded = false;

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
            ref.watch(notificationsProvider).addAll(response.payload);
            setState(() => loaded = true);
          }
        },
      );

  Future<void> refresh() async {
    setState(() => loaded = false);
    ref.watch(notificationsProvider).clear();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    List<NotificationData> notifications = ref.watch(notificationsProvider);
    String username = ref.watch(userProvider).username;

    return NestedScrollView(
      headerSliverBuilder: (context, isScrolled) => [
        SliverPadding(
          padding: EdgeInsets.only(left: 15.w, top: 10.h),
          sliver: SliverToBoxAdapter(
            child: Text("Notifications", style: context.textTheme.titleMedium,),
          )
        ),
        SliverPersistentHeader(
          delegate: TabHeaderDelegate(
              color: context.isDark ? Colors.black12 : Colors.white12,
              tabBar: TabBar(
                controller: controller,
                indicatorColor: appRed,
                labelColor: appRed,
                labelStyle: context.textTheme.bodyMedium!
                    .copyWith(fontWeight: FontWeight.w500),
                unselectedLabelStyle: context.textTheme.bodyMedium!
                    .copyWith(fontWeight: FontWeight.w500),
                tabs: const [
                  Tab(text: "All"),
                  Tab(text: "Verified"),
                  Tab(text: "Tags & Mention")
                ],
              )
          ),
          pinned: true,
        ),
      ],
      body: TabBarView(
        controller: controller,
        children: [
          Column(children: [
            SizedBox(height: 10.h),
            Expanded(
              child: !loaded
                  ? const CenteredPopup()
                  : (notifications.isEmpty)
                      ? GestureDetector(
                          onTap: refresh,
                          child: Center(
                            child: Text(
                              "No notifications available. Tap to refresh",
                              style: context.textTheme.bodyLarge,
                            ),
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
                            separatorBuilder: (_, __) => SizedBox(height: 20.h),
                          ),
                        ),
            ),
          ]),
          Column(children: [
            SizedBox(height: 10.h),
            Expanded(
              child: !loaded
                  ? const CenteredPopup()
                  : (notifications.isEmpty)
                      ? GestureDetector(
                          onTap: refresh,
                          child: Center(
                            child: Text(
                              "No notifications available. Tap to refresh",
                              style: context.textTheme.bodyLarge,
                            ),
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
                            separatorBuilder: (_, __) => SizedBox(height: 20.h),
                          ),
                        ),
            ),
          ]),
          Column(
            children: [
              SizedBox(height: 10.h),
              Expanded(
                child: !loaded
                    ? const CenteredPopup()
                    : (notifications.isEmpty)
                        ? GestureDetector(
                            onTap: refresh,
                            child: Center(
                              child: Text(
                                "No notifications available. Tap to refresh",
                                style: context.textTheme.bodyLarge,
                              ),
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
        ],
      ),
    );
  }
}

class NotificationHeader extends StatefulWidget {
  final NotificationData notification;
  final String username;

  const NotificationHeader(this.notification, {Key? key, this.username = ""})
      : super(key: key);

  @override
  State<NotificationHeader> createState() => _NotificationHeaderState();
}

class _NotificationHeaderState extends State<NotificationHeader> {
  void showExtra() => showModalBottomSheet(
        context: context,
        builder: (context) => SizedBox(
          height: 300.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              SvgPicture.asset("assets/Modal Line.svg"),
              SizedBox(height: 30.h),
              ListTile(
                leading: SvgPicture.asset("assets/Less Often.svg"),
                title: Text(
                  "See this notification less often",
                  style: context.textTheme.bodyMedium,
                ),
                onTap: () {},
              ),
              ListTile(
                leading: SvgPicture.asset("assets/Unfollow User.svg"),
                title: Text("Unfollow @${widget.username}",
                    style: context.textTheme.bodyMedium),
                onTap: () {},
              ),
              ListTile(
                leading: SvgPicture.asset("assets/Block User.svg"),
                title: Text("Block @${widget.username}",
                    style: context.textTheme.bodyMedium),
                onTap: () {},
              ),
              ListTile(
                leading: SvgPicture.asset("assets/Mute User.svg"),
                title: Text("Mute @${widget.username}",
                    style: context.textTheme.bodyMedium),
                onTap: () {},
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => widget.notification.opened = true),
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
                          width: 250.w,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: widget.notification.postedBy.username,
                                  style: context.textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: " ${widget.notification.header}",
                                  style: context.textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.notification.content,
                    overflow: TextOverflow.visible,
                    style: context.textTheme.bodyMedium,
                  ),
                  Text(
                    time.format(widget.notification.date),
                    style: context.textTheme.bodySmall,
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
