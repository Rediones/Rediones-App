import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/api/group_service.dart';
import 'package:rediones/tools/functions.dart';
import 'package:timeago/timeago.dart' as time;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:rediones/components/group_data.dart';
import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/screens/groups/group_home.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/widgets.dart';

class GroupsPage extends ConsumerStatefulWidget {
  const GroupsPage({
    super.key,
  });

  @override
  ConsumerState<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends ConsumerState<GroupsPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  late TabController tabController;

  bool loaded = false;

  List<GroupData> forYou = [];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    fetchGroups();
  }

  void fetchGroups() {
    getGroups().then((result) {
      if (result.status == Status.failed) {
        showError(result.message);
        return;
      }
      if (!mounted) return;
      setState(() => loaded = true);
      ref.watch(groupsProvider).clear();
      ref.watch(groupsProvider).addAll(result.payload);
    });
  }

  Future<void> refreshGroups() async {
    setState(() => loaded = false);
    fetchGroups();
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;
    List<GroupData> groups = ref.watch(groupsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 26.r,
          splashRadius: 0.01,
          icon: const Icon(Icons.chevron_left),
          onPressed: () => context.router.pop(),
        ),
        elevation: 0.0,
        title: Text("Groups", style: context.textTheme.titleMedium),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () =>
                    context.router.pushNamed(Pages.createGroup).then((resp) {
                  if (resp != null && resp == true) {
                    refreshGroups();
                  }
                }),
                child: Container(
                  height: 35.h,
                  width: 90.w,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(6.r),
                    border:
                        Border.all(color: darkTheme ? neutral3 : fadedPrimary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 18.r,
                        height: 18.r,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: appRed),
                        child: Center(
                            child: Icon(Icons.add_rounded,
                                color: theme, size: 14.r)),
                      ),
                      Text("Create", style: context.textTheme.bodyLarge)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              SpecialForm(
                width: 390.w,
                height: 40.h,
                controller: searchController,
                hint: "Search",
                fillColor: neutral2,
                borderColor: Colors.transparent,
                action: TextInputAction.go,
                onActionPressed: (value) {},
                prefix: Icon(Icons.search_rounded, size: 20.r, color: appRed),
              ),
              SizedBox(height: 20.h),
              TabBar(
                controller: tabController,
                dividerColor: neutral2,
                tabs: [
                  Tab(
                    child:
                        Text("Your Groups", style: context.textTheme.bodyLarge),
                  ),
                  Tab(
                    child: Text("For You", style: context.textTheme.bodyLarge),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    !loaded
                        ? const CenteredPopup()
                        : groups.isEmpty
                            ? Center(
                                child: Text("No Groups Available",
                                    style: context.textTheme.bodyLarge),
                              )
                            : RefreshIndicator(
                                onRefresh: refreshGroups,
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 10.h,
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10.h,
                                  ),
                                  itemCount: groups.length,
                                  itemBuilder: (_, index) =>
                                      _GroupDataContainer(
                                    data: groups[index],
                                  ),
                                ),
                              ),
                    ListView.separated(
                      separatorBuilder: (_, __) => SizedBox(height: 25.h),
                      itemCount: forYou.length,
                      itemBuilder: (_, index) => _ForYouContainer(
                        data: forYou[index],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupDataContainer extends StatefulWidget {
  final GroupData data;

  const _GroupDataContainer({super.key, required this.data});

  @override
  State<_GroupDataContainer> createState() => _GroupDataContainerState();
}

class _GroupDataContainerState extends State<_GroupDataContainer> {
  final List<String> memberImages = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.data.groupUsers.length; ++i) {
      String image = widget.data.groupUsers[i].profilePicture;
      memberImages.add(image);

      if (i == 2) break;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;

    return GestureDetector(
      onTap: () =>
          Navigator.push(context, FadeRoute(GroupHome(data: widget.data))),
      child: Container(
        width: 170.w,
        height: 250.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Colors.transparent,
          border: Border.all(color: darkTheme ? neutral3 : fadedPrimary),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  topRight: Radius.circular(10.r)),
              child: CachedNetworkImage(
                imageUrl: widget.data.groupCoverImage,
                errorWidget: (context, url, error) => Container(
                  height: 40.h,
                  width: 170.w,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/error.jpeg"),
                        fit: BoxFit.fill),
                  ),
                ),
                progressIndicatorBuilder: (context, url, download) => SizedBox(
                  height: 40.h,
                  width: 170.w,
                  child: const Center(
                    child: CenteredPopup(),
                  ),
                ),
                imageBuilder: (context, provider) => Container(
                  height: 40.h,
                  width: 170.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: provider, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              widget.data.groupName,
              style: context.textTheme.headlineSmall!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10.h),
            MultiMemberImage(
              images: memberImages,
              size: 16.r,
              border: goodYellow,
              total: widget.data.groupUsers.length,
            )
          ],
        ),
      ),
    );
  }
}

class _ForYouContainer extends StatelessWidget {
  final GroupData data;

  const _ForYouContainer({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      width: 390.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r)),
          color: Colors.transparent,
          border: Border.all(color: darkTheme ? neutral3 : fadedPrimary)),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      foregroundColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(data.groupCoverImage),
                      radius: 18.r,
                    ),
                    SizedBox(
                      width: 11.w,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.groupName,
                          style: context.textTheme.labelMedium!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: 5.w),
                  child: IconButton(
                    splashRadius: 20.r,
                    iconSize: 26.r,
                    icon: Icon(Icons.more_horiz,
                        color: darkTheme ? neutral : midPrimary),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Positioned(
                bottom: 0,
                left: -10.w,
                child: ClipPath(
                  clipper: _ForYouClipper(),
                  child: Container(
                    width: 30.w,
                    height: 75.h,
                    color: darkTheme ? neutral3 : fadedPrimary,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 40.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          foregroundColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage(
                              data.groupPosts.last.poster.profilePicture),
                          radius: 18.r,
                        ),
                        SizedBox(
                          width: 11.w,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.groupPosts.last.poster.username,
                                style: context.textTheme.labelMedium!
                                    .copyWith(fontWeight: FontWeight.w700)),
                            Wrap(
                              spacing: 5.w,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text("@${data.groupPosts.last.poster.nickname}",
                                    style: context.textTheme.labelSmall),
                                Container(
                                  color: appRed,
                                  width: 2.w,
                                  height: 10.h,
                                ),
                                Text(
                                    time.format(data.groupPosts.last.timestamp),
                                    style: context.textTheme.labelSmall),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Text(data.groupPosts.last.text,
                        style: context.textTheme.bodyMedium),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Boxicons.bx_like),
                              onPressed: () {},
                              splashRadius: 0.01,
                            ),
                            SizedBox(width: 5.w),
                            Text("${data.groupPosts.last.likes.length}",
                                style: context.textTheme.labelMedium)
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Boxicons.bx_comment),
                              onPressed: () {},
                              splashRadius: 0.01,
                            ),
                            SizedBox(width: 5.w),
                            Text("0", style: context.textTheme.labelMedium)
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Boxicons.bx_share),
                              onPressed: () {},
                              splashRadius: 0.01,
                            ),
                            SizedBox(width: 5.w),
                            Text("${data.groupPosts.last.shares}",
                                style: context.textTheme.labelMedium)
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Boxicons.bx_bookmark),
                          onPressed: () {},
                          splashRadius: 0.01,
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _ForYouClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
