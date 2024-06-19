import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rediones/api/post_service.dart';
import 'package:rediones/components/message_data.dart';
import 'package:rediones/components/poll_data.dart';
import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/postable.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/api/message_service.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OtherProfilePage extends StatefulWidget {
  final User data;

  const OtherProfilePage({super.key, required this.data});

  @override
  State<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;
    return Scaffold(
      body: SafeArea(
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
                              imageUrl: widget.data.profilePicture,
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
                            width: 210.w,
                            height: 130.h,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 190.w,
                                  child: Text(
                                    widget.data.username,
                                    overflow: TextOverflow.fade,
                                    style: context.textTheme.headlineSmall!
                                        .copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        "assets/Profile School.svg"),
                                    SizedBox(width: 10.w),
                                    SizedBox(
                                      width: 180.w,
                                      child: Text(
                                        widget.data.school,
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        "assets/Profile Location.svg"),
                                    SizedBox(width: 10.w),
                                    SizedBox(
                                      width: 180.w,
                                      child: Text(
                                        widget.data.address,
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
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        "${widget.data.followers.length} followers",
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
                                        "${widget.data.following.length} following",
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
                            child: Icon(Icons.more_vert_rounded, size: 26.r),
                          ),
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
                        widget.data.description,
                        style: context.textTheme.bodyMedium,
                      ),
                    ),
                    SizedBox(height: 25.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appRed,
                            elevation: 1.0,
                            fixedSize: Size(168.w, 32.h),
                          ),
                          child: Text(
                            "Follow",
                            style: context.textTheme.bodyMedium!
                                .copyWith(color: theme),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            void navigate(Conversation resp) => context.router
                                .pushNamed(Pages.inbox, extra: resp);

                            showDialog(
                              context: context,
                              useSafeArea: true,
                              barrierDismissible: true,
                              builder: (context) {
                                return FutureBuilder<Conversation?>(
                                  future: createConversation(widget.data.id),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Popup();
                                    } else if (snapshot.hasError) {
                                      showToast(
                                          "An error occurred. Please try again", context);
                                      return const SizedBox.shrink();
                                    } else {
                                      Conversation? resp = snapshot.data;
                                      if (resp == null) {
                                        showToast(
                                            "An error occurred. Please try again.", context);
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
                              side: const BorderSide(color: neutral2),
                            ),
                          ),
                          child: Text("Send Message",
                              style: context.textTheme.bodyMedium),
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
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 17.w),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
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
                          "View Spotlights",
                          style: context.textTheme.bodyMedium,
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
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                child: FutureBuilder<RedionesResponse<List<PostObject>>>(
                  future: getUsersPosts(id: widget.data.id),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Skeletonizer(
                        enabled: true,
                        child: ListView.separated(
                          itemCount: dummyPosts.length,
                          itemBuilder: (_, index) => PostObjectContainer(
                            postObject: dummyPosts[index],
                            onCommentClicked: () {},
                          ),
                          separatorBuilder: (_, __) => SizedBox(height: 20.h),
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
                            separatorBuilder: (_, __) => SizedBox(height: 20.h),
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
                                    )
                                  ),
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
      ),
    );
  }
}
