import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rediones/api/event_service.dart';
import 'package:rediones/api/post_service.dart';
import 'package:rediones/components/event_data.dart';
import 'package:rediones/components/postable.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/screens/spotlight/your_spotlights.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/tools/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyProfilePage extends ConsumerStatefulWidget {
  const MyProfilePage({super.key});

  @override
  ConsumerState<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends ConsumerState<MyProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  bool loadingPosts = false, loadingSaved = false, loadingEvents = false;
  final List<PostObject> posts = [], savedPosts = [];
  final List<EventData> events = [];

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
    loadingEvents = loadingPosts = loadingSaved = true;
    getPosts();
    getSavedPosts();
    getInterestedEvents();
  }

  void getPosts() {
    getUserPosts(ref.read(userProvider).uuid).then((resp) {
      if (!mounted) return;
      if (resp.status == Status.failed) {
        showToast(resp.message, context);
        setState(() => loadingPosts = false);
        return;
      }

      posts.clear();
      posts.addAll(resp.payload);
      loadingPosts = false;

      setState(() {});
    });
  }

  void getSavedPosts() {
    getUserSavedPosts().then((resp) {
      if (!mounted) return;
      if (resp.status == Status.failed) {
        showToast(resp.message, context);
        setState(() => loadingSaved = false);
        return;
      }

      savedPosts.clear();
      savedPosts.addAll(resp.payload);
      loadingSaved = false;

      setState(() {});
    });
  }

  void getInterestedEvents() {
    getAllInterestedEvents(ref.read(userProvider).uuid).then((resp) {
      if (!mounted) return;
      if (resp.status == Status.failed) {
        showToast(resp.message, context);
        setState(() => loadingEvents = false);
        return;
      }

      events.clear();
      events.addAll(resp.payload);
      loadingEvents = false;
      setState(() {});
    });
  }

  Future<void> retryPosts() async {
    setState(() => loadingPosts = true);
    getPosts();
  }

  Future<void> retrySaved() async {
    setState(() => loadingSaved = true);
    getSavedPosts();
  }

  Future<void> retryEvents() async {
    setState(() => loadingEvents = true);
    getInterestedEvents();
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;
    User user = ref.watch(userProvider);

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 17.w),
                  child: Column(
                    children: [
                      SizedBox(height: 15.h),
                      SizedBox(
                        width: 390.w,
                        height: 100.h,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CachedNetworkImage(
                              imageUrl: user.profilePicture,
                              errorWidget: (context, url, error) => Container(
                                width: 90.w,
                                height: 130.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: appRed.withOpacity(0.5),
                                ),
                              ),
                              progressIndicatorBuilder:
                                  (context, url, download) => Container(
                                width: 90.w,
                                height: 130.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: neutral2,
                                ),
                              ),
                              imageBuilder: (context, provider) => Container(
                                width: 90.w,
                                height: 130.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  image: DecorationImage(
                                    image: provider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 220.w,
                              height: 100.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 200.w,
                                    child: Text(
                                      user.username,
                                      overflow: TextOverflow.fade,
                                      style: context.textTheme.headlineSmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          "assets/Profile School.svg"),
                                      SizedBox(width: 10.w),
                                      SizedBox(
                                        width: 190.w,
                                        child: Text(
                                          user.school,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.textTheme.bodyMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.h),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          "assets/Profile Location.svg"),
                                      SizedBox(width: 10.w),
                                      SizedBox(
                                        width: 190.w,
                                        child: Text(
                                          user.address,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.textTheme.bodyMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 5.h),
                                  Wrap(
                                    spacing: 12.w,
                                    alignment: WrapAlignment.start,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Text(
                                          "${user.followers.length} followers",
                                          style: context.textTheme.bodyLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        color: appRed,
                                        width: 2.w,
                                        height: 10.h,
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Text(
                                          "${user.following.length} following",
                                          style: context.textTheme.bodyLarge!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.router
                                  .pushNamed(Pages.editProfile)
                                  .then((resp) {
                                if (resp == null) return;
                                retrySaved();
                                retryPosts();
                                retryEvents();
                              }),
                              child:
                                  SvgPicture.asset("assets/Edit Profile.svg"),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          color: neutral2,
                        ),
                        child: Text(
                          user.description,
                          style: context.textTheme.bodyLarge,
                        ),
                      ),
                      SizedBox(height: 25.h),
                    ],
                  ),
                ),
              ),
            ),
            SliverPersistentHeader(
              delegate: TabHeaderDelegate(
                tabBar: TabBar(
                  controller: controller,
                  indicatorColor: appRed,
                  dividerColor:
                      context.isDark ? Colors.white12 : Colors.black12,
                  labelColor: appRed,
                  labelPadding: EdgeInsets.symmetric(horizontal: 5.w),
                  labelStyle: context.textTheme.titleSmall!
                      .copyWith(fontWeight: FontWeight.w600),
                  unselectedLabelStyle: context.textTheme.titleSmall!
                      .copyWith(fontWeight: FontWeight.w500),
                  tabs: const [
                    Tab(text: "Posts"),
                    Tab(text: "Saved"),
                    Tab(text: "Events"),
                    Tab(text: "Spotlights"),
                  ],
                ),
              ),
              pinned: true,
            )
          ],
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: TabBarView(
              controller: controller,
              children: [
                loadingPosts
                    ? Skeletonizer(
                        enabled: true,
                        child: ListView.separated(
                          itemCount: dummyPosts.length,
                          itemBuilder: (_, index) => PostObjectContainer(
                            postObject: dummyPosts[index],
                          ),
                          separatorBuilder: (_, __) => SizedBox(height: 20.h),
                        ),
                      )
                    : (posts.isEmpty)
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
                                  "There are no posts available",
                                  style: context.textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                GestureDetector(
                                  onTap: retryPosts,
                                  child: Text(
                                    "Refresh",
                                    style:
                                        context.textTheme.titleSmall!.copyWith(
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
                              onRefresh: retryPosts,
                              child: ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemCount: posts.length + 1,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 20.h),
                                itemBuilder: (_, index) {
                                  if (index == posts.length) {
                                    return SizedBox(height: 100.h);
                                  }

                                  PostObject post = posts[index];

                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 750),
                                    child: SlideAnimation(
                                      verticalOffset: 25.h,
                                      child: FadeInAnimation(
                                        child: PostObjectContainer(
                                          postObject: post,
                                          key: ValueKey<String>(post.uuid),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                loadingSaved
                    ? Skeletonizer(
                        enabled: true,
                        child: ListView.separated(
                          itemCount: dummyPosts.length,
                          itemBuilder: (_, index) => PostObjectContainer(
                            postObject: dummyPosts[index],

                          ),
                          separatorBuilder: (_, __) => SizedBox(height: 20.h),
                        ),
                      )
                    : (savedPosts.isEmpty)
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
                                  "There are no saved posts available",
                                  style: context.textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                GestureDetector(
                                  onTap: retrySaved,
                                  child: Text(
                                    "Refresh",
                                    style:
                                        context.textTheme.titleSmall!.copyWith(
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
                              onRefresh: retrySaved,
                              child: ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemCount: savedPosts.length + 1,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 20.h),
                                itemBuilder: (_, index) {
                                  if (index == savedPosts.length) {
                                    return SizedBox(height: 100.h);
                                  }

                                  PostObject post = savedPosts[index];

                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 750),
                                    child: SlideAnimation(
                                      verticalOffset: 25.h,
                                      child: FadeInAnimation(
                                        child: PostObjectContainer(
                                          postObject: post,
                                          key: ValueKey<String>(post.uuid),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                loadingEvents
                    ? Skeletonizer(
                        enabled: true,
                        child: ListView.separated(
                          itemCount: dummyEvents.length,
                          itemBuilder: (_, index) => EventContainer(
                            data: dummyEvents[index],
                          ),
                          separatorBuilder: (_, __) => SizedBox(height: 20.h),
                        ),
                      )
                    : (events.isEmpty)
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
                                  "There are no interested events available",
                                  style: context.textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                GestureDetector(
                                  onTap: retryEvents,
                                  child: Text(
                                    "Refresh",
                                    style:
                                        context.textTheme.titleSmall!.copyWith(
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
                              onRefresh: retryEvents,
                              child: ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemCount: events.length + 1,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 20.h),
                                itemBuilder: (_, index) {
                                  if (index == events.length) {
                                    return SizedBox(height: 100.h);
                                  }

                                  EventData event = events[index];

                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 750),
                                    child: SlideAnimation(
                                      verticalOffset: 25.h,
                                      child: FadeInAnimation(
                                        child: EventContainer(
                                          data: event,
                                          key: ValueKey<String>(event.id),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                YourSpotlightsPage(id: user.uuid),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
