import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:rediones/api/group_service.dart';
import 'package:rediones/components/community_data.dart';
import 'package:rediones/components/group_data.dart';
import 'package:rediones/components/postable.dart';
import 'package:rediones/screens/other/media_view.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/tools/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GroupHome extends StatefulWidget {
  final GroupData data;

  const GroupHome({super.key, required this.data});

  @override
  State<GroupHome> createState() => _GroupHomeState();
}

class _GroupHomeState extends State<GroupHome> {
  bool fetching = false, isCollapsed = false;
  final List<PostObject> posts = [];

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetching = true;
    getPosts();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void getPosts() {
    getGroupPosts(widget.data.id).then((resp) {
      if (!mounted) return;

      if (resp.status == Status.failed) {
        showToast(resp.message, context);
        return;
      }

      posts.clear();
      posts.addAll(resp.payload);

      setState(() => fetching = false);
    });
  }

  Future<void> refresh() async {
    setState(() => fetching = true);
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;

    return Scaffold(
      body: AnimationLimiter(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: refresh,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) {
                    if (!scrollController.hasClients) return;
                    if (scrollController.offset > 300.h && !isCollapsed) {
                      setState(() => isCollapsed = true);
                    } else if (scrollController.offset < 300.h && isCollapsed) {
                      setState(() => isCollapsed = false);
                    }
                  },
                );

                return true;
              },
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverAppBar(
                    expandedHeight: 290.h,
                    title: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isCollapsed ? 1 : 0,
                      child: Text(
                        widget.data.groupName,
                        style: context.textTheme.titleLarge,
                      ),
                    ),
                    centerTitle: true,
                    pinned: true,
                    automaticallyImplyLeading: isCollapsed,
                    flexibleSpace: FlexibleSpaceBar(
                      background: SizedBox(
                        width: 390.w,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => context.router.pushNamed(
                                Pages.viewMedia,
                                extra: PreviewData(
                                  displayType: DisplayType.network,
                                  images: [widget.data.groupCoverImage],
                                ),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: widget.data.groupCoverImage,
                                errorWidget: (context, url, error) => Container(
                                  width: 390.w,
                                  height: 124.h,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.broken_image_outlined,
                                    color: appRed,
                                    size: 36,
                                  ),
                                ),
                                progressIndicatorBuilder:
                                    (context, url, download) => SizedBox(
                                  width: 390.w,
                                  height: 124.h,
                                  child: const Center(
                                    child: CenteredPopup(),
                                  ),
                                ),
                                imageBuilder: (context, provider) => Container(
                                  width: 390.w,
                                  height: 124.h,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: provider, fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 180.w,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.data.groupName,
                                              style: context
                                                  .textTheme.headlineSmall,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                    minWidth: 0.w,
                                                    maxWidth: 14.5.r * 4,
                                                  ),
                                                  child: MultiMemberImage(
                                                    alignment: ImageAlign.start,
                                                    total: widget
                                                        .data.groupUsers.length,
                                                    images: widget
                                                        .data.groupUsers
                                                        .map((u) =>
                                                            u.profilePicture)
                                                        .toList(),
                                                    size: 14.r,
                                                    border: goodYellow,
                                                  ),
                                                ),
                                                SizedBox(width: 5.w),
                                                Text(
                                                  "${widget.data.groupUsers.length} member${widget.data.groupUsers.length == 1 ? "" : "s"}",
                                                  style: context
                                                      .textTheme.bodyLarge,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () => context.router
                                                .pushNamed(
                                              Pages.createPosts,
                                              extra: widget.data.id,
                                            )
                                                .then((value) {
                                              if (value == null) return;
                                              if (value == true) refresh();
                                            }),
                                            child: Container(
                                              height: 40.h,
                                              width: 120.w,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(20.h),
                                                border: Border.all(
                                                    color: darkTheme
                                                        ? neutral3
                                                        : fadedPrimary),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 16.r,
                                                    height: 16.r,
                                                    alignment: Alignment.center,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: appRed,
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.add_rounded,
                                                        color: theme,
                                                        size: 14.r,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "Make a Post",
                                                    style: context
                                                        .textTheme.titleSmall!
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14.sp,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          GestureDetector(
                                            onTap: () =>
                                                context.router.pushNamed(
                                              Pages.communityChat,
                                              extra:
                                                  CommunityData.fromGroupData(
                                                      widget.data),
                                            ),
                                            child: Container(
                                              height: 40.h,
                                              width: 40.h,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: darkTheme
                                                        ? neutral3
                                                        : fadedPrimary),
                                              ),
                                              child: const Icon(
                                                Boxicons.bx_message_alt_detail,
                                                color: appRed,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 10.h),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        color:
                                            darkTheme ? midPrimary : neutral),
                                    child: Text(
                                      widget.data.groupDescription.substring(
                                        0,
                                        (widget.data.groupDescription.length >=
                                                250
                                            ? 250
                                            : widget
                                                .data.groupDescription.length),
                                      ),
                                      style: context.textTheme.bodyLarge,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    sliver: fetching
                        ? SliverFillRemaining(
                            child: Skeletonizer(
                              enabled: true,
                              child: ListView.separated(
                                itemCount: dummyPosts.length,
                                itemBuilder: (_, index) => PostObjectContainer(
                                  postObject: dummyPosts[index],
                                ),
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 20.h),
                              ),
                            ),
                          )
                        : (posts.isEmpty)
                            ? SliverToBoxAdapter(
                                child: SizedBox(
                                  height: 350.h,
                                  width: 390.w,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/No Data.png",
                                          width: 150.r,
                                          height: 150.r,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(height: 20.h),
                                        Text(
                                          "There are no posts available",
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
                                  ),
                                ),
                              )
                            : SliverList.separated(
                                itemBuilder: (_, index) {
                                  if (index == posts.length) {
                                    return SizedBox(height: 50.h);
                                  }

                                  PostObject post = posts[index];

                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 750),
                                    child: SlideAnimation(
                                      verticalOffset: 25.h,
                                      child: FadeInAnimation(
                                        child: PostObjectContainer(
                                          key: ValueKey<String>(post.uuid),
                                          postObject: post,
                                          index: index - 1,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 25.h),
                                itemCount: posts.length + 1,
                              ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
