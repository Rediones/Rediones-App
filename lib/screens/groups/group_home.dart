import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/api/group_service.dart';
import 'package:rediones/components/group_data.dart';
import 'package:rediones/components/post_data.dart';
import 'package:rediones/screens/other/media_view.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/widgets.dart';

class GroupHome extends StatefulWidget {
  final GroupData data;

  const GroupHome({super.key, required this.data});

  @override
  State<GroupHome> createState() => _GroupHomeState();
}

class _GroupHomeState extends State<GroupHome> {
  bool fetching = false, isCollapsed = false;
  final List<Post> posts = [];

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
        showError(resp.message);
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
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  if(!scrollController.hasClients) return;
                  if(scrollController.offset > 300.h && !isCollapsed) {
                    setState(() => isCollapsed = true);
                  } else if(scrollController.offset < 300.h && isCollapsed) {
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
                  expandedHeight: 320.h,
                  title: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isCollapsed ? 1 : 0,
                    child: Text("Group", style: context.textTheme.titleMedium),
                  ),
                  pinned: true,
                  leading: IconButton(
                    splashRadius: 0.01,
                    icon: Icon(Icons.chevron_left, size: 26.r),
                    onPressed: () => context.router.pop(),
                  ),
                  actions: [
                    IconButton(
                      splashRadius: 0.01,
                      iconSize: 26.r,
                      icon: const Icon(Icons.more_horiz_rounded),
                      onPressed: () {},
                    )
                  ],
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
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/error.jpeg"),
                                    fit: BoxFit.fill,
                                  ),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 200.w,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.data.groupName,
                                            style:
                                                context.textTheme.headlineSmall,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 170.w,
                                                // child: MultiMemberImage(
                                                //   images: const [
                                                //     "images/hotel.jpg",
                                                //     "images/street.jpg",
                                                //     "images/watch man.jpg"
                                                //   ],
                                                //   size: 16.r,
                                                //   border: goodYellow,
                                                // ),
                                              ),
                                              // Text(
                                              //   "${widget.data.groupUsers.length} member${widget.data.groupUsers.length == 1 ? "" : "s"}",
                                              //   style: context.textTheme.bodyLarge,
                                              // ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
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
                                        width: 130.w,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(6.r),
                                          border: Border.all(
                                            color: darkTheme
                                                ? neutral3
                                                : fadedPrimary,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 18.r,
                                              height: 18.r,
                                              alignment: Alignment.center,
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: appRed),
                                              child: Icon(Icons.add_rounded,
                                                  color: theme, size: 14.r),
                                            ),
                                            Text(
                                              "Make A Post",
                                              style: context
                                                  .textTheme.bodyLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 5.h),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: darkTheme ? midPrimary : neutral),
                                  child: Text(widget.data.groupDescription.substring(0, (widget.data.groupDescription.length >= 250 ? 250 : widget.data.groupDescription.length)),
                                      style: context.textTheme.bodyMedium),
                                ),
                                SizedBox(height: 30.h),
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
                      ? const SliverFillRemaining(
                          child: Center(child: loader),
                        )
                      : SliverList.separated(
                          itemBuilder: (_, index) {
                            if (index == posts.length) {
                              return SizedBox(height: 50.h);
                            }

                            return PostContainer(
                              post: posts[index],
                              onCommentClicked: () {},
                            );
                          },
                          separatorBuilder: (_, __) => SizedBox(height: 25.h),
                          itemCount: posts.length + 1,
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
