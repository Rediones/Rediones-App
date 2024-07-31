import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rediones/api/message_service.dart';
import 'package:rediones/api/post_service.dart';
import 'package:rediones/api/user_service.dart';
import 'package:rediones/components/message_data.dart';
import 'package:rediones/components/postable.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/tools/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OtherProfilePage extends ConsumerStatefulWidget {
  final String id;

  const OtherProfilePage({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends ConsumerState<OtherProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  late Future getUserDetails;
  bool refreshDetails = false;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    getUserDetails = getUserFuture();
  }

  void showMessage(String message) => showToast(message, context);

  Future<User?> getUserFuture() async {
    RedionesResponse<User?> response = await getUser(widget.id);
    if (response.status == Status.failed) {
      showMessage(response.message);
    }
    setState(() => refreshDetails = false);
    return response.payload;
  }

  void onFollow(String id) {
    List<String> following = ref.watch(userProvider.select((u) => u.following));
    bool followedInitially = !shouldFollow(id);

    if (followedInitially) {
      following.remove(id);
    } else {
      following.add(id);
    }

    setState(() {});

    followUser(id).then((resp) {
      if (resp.status == Status.failed) {
        if (followedInitially) {
          following.add(id);
        } else {
          following.remove(id);
        }
        showToast(resp.message, context);
      }

      setState(() {});
    });
  }

  bool shouldFollow(String id) {
    User currentUser = ref.watch(userProvider);
    if (currentUser.following.contains(id)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;
    return Scaffold(
      body: FutureBuilder(
        future: refreshDetails ? getUserFuture() : getUserDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: loader);
          } else {
            User? user = snapshot.data as User?;
            if (user == null) {
              return Center(
                child: ElevatedButton(
                  onPressed: () => setState(() => refreshDetails = true),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: appRed,
                      fixedSize: Size(90.w, 35.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.5.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      )),
                  child: Text(
                    "Retry",
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }

            return SafeArea(
              child: NestedScrollView(
                headerSliverBuilder: (_, __) => [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 17.w),
                    sliver: SliverToBoxAdapter(
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
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      width: 90.w,
                                      height: 130.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        image: const DecorationImage(
                                            image:
                                                AssetImage("images/home.jpeg"),
                                            fit: BoxFit.contain),
                                      ),
                                    ),
                                    progressIndicatorBuilder:
                                        (context, url, download) => Center(
                                      child: CircularProgressIndicator(
                                          color: appRed,
                                          value: download.progress),
                                    ),
                                    imageBuilder: (context, provider) =>
                                        Container(
                                      width: 90.w,
                                      height: 130.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        image: DecorationImage(
                                            image: provider, fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 210.w,
                                  height: 130.h,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 190.w,
                                        child: Text(
                                          user.username,
                                          overflow: TextOverflow.fade,
                                          style: context
                                              .textTheme.headlineSmall!
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
                                            width: 180.w,
                                            child: Text(
                                              user.school,
                                              overflow: TextOverflow.ellipsis,
                                              style: context
                                                  .textTheme.bodyMedium!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                            width: 180.w,
                                            child: Text(
                                              user.address,
                                              overflow: TextOverflow.ellipsis,
                                              style: context
                                                  .textTheme.bodyMedium!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500),
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
                                              style: context
                                                  .textTheme.bodyLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500),
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
                                              style: context
                                                  .textTheme.bodyLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  child:
                                      Icon(Icons.more_vert_rounded, size: 26.r),
                                ),
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
                              color: darkTheme ? midPrimary : neutral,
                            ),
                            child: Text(
                              user.description,
                              style: context.textTheme.bodyLarge,
                            ),
                          ),
                          SizedBox(height: 25.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () => onFollow(user.uuid),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: appRed,
                                  elevation: 1.0,
                                  fixedSize: Size(168.w, 32.h),
                                ),
                                child: Text(
                                  shouldFollow(user.uuid)
                                      ? "Follow"
                                      : "Unfollow",
                                  style: context.textTheme.titleSmall!.copyWith(
                                    color: theme,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  void navigate(Conversation resp) =>
                                      context.router
                                          .pushNamed(Pages.inbox, extra: resp);

                                  showDialog(
                                    context: context,
                                    useSafeArea: true,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return FutureBuilder<
                                          RedionesResponse<Conversation?>>(
                                        future: createConversation(user.uuid),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Popup();
                                          } else if (snapshot.hasError) {
                                            showToast(
                                                "An error occurred. Please try again",
                                                context);
                                            return const SizedBox.shrink();
                                          } else {
                                            Conversation? resp =
                                                snapshot.data?.payload;
                                            if (resp == null) {
                                              showToast(
                                                  "An error occurred. Please try again.",
                                                  context);
                                            } else {
                                              Future.delayed(Duration.zero,
                                                  () => navigate(resp));
                                            }
                                            Navigator.of(context).pop();
                                            return const SizedBox.shrink();
                                          }
                                        },
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  elevation: 1.0,
                                  fixedSize: Size(168.w, 40.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.h),
                                    side: BorderSide(
                                        color: darkTheme ? neutral : neutral2),
                                  ),
                                ),
                                child: Text(
                                  "Send Message",
                                  style: context.textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 25.h),
                        ],
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
                        ],
                      ),
                    ),
                    pinned: true,
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 17.w),
                      child: Column(
                        children: [
                          SizedBox(height: 10.h),
                          GestureDetector(
                            onTap: () => context.router.pushNamed(
                              Pages.yourSpotlight,
                              extra: user.uuid,
                            ),
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
                                "View Spotlights",
                                style: context.textTheme.bodyLarge,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  )
                ],
                body: TabBarView(
                  controller: controller,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      child: FutureBuilder<RedionesResponse<List<PostObject>>>(
                        future: getUserPosts(user.uuid),
                        builder: (_, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Skeletonizer(
                              enabled: true,
                              child: ListView.separated(
                                itemCount: dummyPosts.length,
                                itemBuilder: (_, index) => PostObjectContainer(
                                  postObject: dummyPosts[index],
                                  onCommentClicked: () {},
                                ),
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 20.h),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return GestureDetector(
                              onTap: () => setState(() {}),
                              child: Center(
                                child: Text(
                                  "No posts available. Tap to refresh",
                                  style: context.textTheme.bodyLarge,
                                ),
                              ),
                            );
                          } else {
                            List<PostObject> posts = snapshot.data!.payload;

                            return AnimationLimiter(
                              child: RefreshIndicator(
                                onRefresh: () async => setState(() {}),
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
                                      duration:
                                          const Duration(milliseconds: 750),
                                      child: SlideAnimation(
                                        verticalOffset: 25.h,
                                        child: FadeInAnimation(
                                            child: PostObjectContainer(
                                          postObject: post,
                                          onCommentClicked: () {},
                                        )),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(),
                    const SizedBox(),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
