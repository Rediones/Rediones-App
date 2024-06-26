import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rediones/api/post_service.dart';
import 'package:rediones/components/postable.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
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

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    loadingEvents = loadingPosts = loadingSaved = true;
    getPosts();
    getSavedPosts();
  }

  void getPosts() {
    getUsersPosts(currentUser: ref.read(userProvider)).then((resp) {
      if (!mounted) return;
      if (resp.status == Status.failed) {
        showToast(resp.message, context);
        return;
      }

      posts.clear();
      posts.addAll(resp.payload);
      loadingPosts = false;

      setState(() {});
    });
  }

  void getSavedPosts() {
    getUsersSavedPosts().then((resp) {
      if (!mounted) return;
      if (resp.status == Status.failed) {
        showToast(resp.message, context);
        return;
      }

      savedPosts.clear();
      savedPosts.addAll(resp.payload);
      loadingSaved = false;

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
                        height: 130.h,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: CachedNetworkImage(
                                imageUrl: user.profilePicture,
                                errorWidget: (context, url, error) => Container(
                                  width: 90.w,
                                  height: 130.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    image: const DecorationImage(
                                        image: AssetImage("images/home.jpeg"),
                                        fit: BoxFit.contain),
                                  ),
                                ),
                                progressIndicatorBuilder:
                                    (context, url, download) => Center(
                                  child: CircularProgressIndicator(
                                      color: appRed, value: download.progress),
                                ),
                                imageBuilder: (context, provider) => Container(
                                  width: 90.w,
                                  height: 130.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    image: DecorationImage(
                                        image: provider, fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 220.w,
                              height: 130.h,
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
                              onTap: () =>
                                  context.router.pushNamed(Pages.editProfile),
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
                            horizontal: 10.w, vertical: 10.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: darkTheme ? midPrimary : neutral),
                        child: Text(
                          user.description,
                          style: context.textTheme.bodyMedium,
                        ),
                      ),
                      SizedBox(height: 25.h),
                      GestureDetector(
                        onTap: () => Permission.storage.request().then((resp) {
                          if (resp.isGranted) {
                            context.router.pushNamed(Pages.yourSpotlight);
                          }
                        }),
                        child: Container(
                          width: 390.w,
                          height: 35.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: darkTheme ? neutral3 : fadedPrimary),
                            borderRadius: BorderRadius.circular(6.r),
                            color: Colors.transparent,
                          ),
                          child: Text(
                            "Your Spotlights",
                            style: context.textTheme.bodyMedium,
                          ),
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
                  labelColor: appRed,
                  labelStyle: context.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                  unselectedLabelStyle: context.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.w500),
                  tabs: const [
                    Tab(text: "Posts"),
                    Tab(text: "Saved"),
                    Tab(text: "Events"),
                  ],
                ),
              ),
              pinned: true,
            )
          ],
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
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
                            onCommentClicked: () {},
                          ),
                          separatorBuilder: (_, __) => SizedBox(height: 20.h),
                        ),
                      )
                    : (posts.isEmpty)
                        ? GestureDetector(
                            onTap: retryPosts,
                            child: Center(
                              child: Text(
                                "No posts available. Tap to refresh",
                                style: context.textTheme.bodyLarge,
                              ),
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
                                          onCommentClicked: () {},
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
                            onCommentClicked: () {},
                          ),
                          separatorBuilder: (_, __) => SizedBox(height: 20.h),
                        ),
                      )
                    : (savedPosts.isEmpty)
                        ? GestureDetector(
                            onTap: retrySaved,
                            child: Center(
                              child: Text(
                                "No saved posts available. Tap to refresh",
                                style: context.textTheme.bodyLarge,
                              ),
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
                                          onCommentClicked: () {},
                                        )
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
