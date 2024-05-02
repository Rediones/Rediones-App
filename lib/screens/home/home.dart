import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:rediones/api/post_service.dart';
import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/repositories/post_repository.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart' show showToast, unFocus;
import 'package:rediones/tools/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:rediones/screens/home/comments.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final FocusNode searchFocus = FocusNode();
  bool fetched = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void refreshPosts() {}

  void fetchPosts() => getPosts().then((response) {
        if (!mounted) return;
        
        List<Post> p = response.payload;
        if (response.status == Status.failed) {
          showToast(response.message);
        }

        log("Assigning new posts");

        ref.watch(postsProvider.notifier).state.addAll(p);

        final PostRepository repository = GetIt.I.get();
        repository.clearAll();
        repository.addPosts(p);

        setState(() => fetched = true);
      });

  @override
  void initState() {
    super.initState();
    searchFocus.addListener(() {
      if (searchFocus.hasFocus) {
        unFocus();
        context.router.pushNamed(Pages.search);
      }
    });




    fetchPosts();
  }

  Future<void> _assignInitialPosts(String value) async {
    final PostRepository repository = GetIt.I.get();
    List<Post> posts = await repository.getAllPosts();
    ref.watch(postsProvider.notifier).state.addAll(posts);
  }


  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void onCommentClicked(String postID, Future future) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => PostComments(
        future: future,
        postID: postID,
        parentContext: context,
      ),
    );
  }

  Future<void> refresh() async {
    setState(() => fetched = false);
    ref.watch(postsProvider).clear();
    fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    List<Post> posts = ref.watch(postsProvider);
    String profilePicture =
        ref.watch(userProvider.select((value) => value.profilePicture));
    String username = ref.watch(userProvider.select((value) => value.username));
    String nickname = ref.watch(userProvider.select((value) => value.nickname));

    bool darkTheme = context.isDark;

    return Scaffold(
      key: _scaffoldKey,
      drawer: SizedBox(
        width: 250.w,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    context.router.pushNamed(Pages.profile);
                  },
                  child: SizedBox(
                    height: 50.h,
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: profilePicture,
                          errorWidget: (context, url, error) => CircleAvatar(
                            backgroundColor: neutral2,
                            radius: 32.r,
                            child:
                                Icon(Icons.person_outline_rounded, size: 24.r),
                          ),
                          progressIndicatorBuilder: (context, url, download) =>
                              Container(
                            width: 40.r,
                            height: 40.r,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: neutral2,
                            ),
                          ),
                          imageBuilder: (context, provider) => CircleAvatar(
                            backgroundImage: provider,
                            radius: 32.r,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 140.w,
                              child: Text(
                                username,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.titleLarge!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text("@$nickname",
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.bodyMedium)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                leading: SvgPicture.asset("assets/Groups.svg",
                    color: !darkTheme ? Colors.black : null),
                title: Text("Groups", style: context.textTheme.bodyMedium),
                onTap: () {
                  Navigator.pop(context);
                  context.router.pushNamed(Pages.groups);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                leading: SvgPicture.asset("assets/Community.svg",
                    color: !darkTheme ? Colors.black : null),
                title: Text("Community Practice",
                    style: context.textTheme.bodyMedium),
                onTap: () {
                  Navigator.pop(context);
                  context.router.pushNamed(Pages.communityPractice);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                leading: SvgPicture.asset("assets/Events.svg",
                    color: !darkTheme ? Colors.black : null),
                title: Text("Events", style: context.textTheme.bodyMedium),
                onTap: () {
                  Navigator.pop(context);
                  context.router.pushNamed(Pages.events);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                onTap: () {
                  Navigator.pop(context);
                  logout(ref);
                  context.router.goNamed(Pages.splash);
                },
                leading: SvgPicture.asset("assets/Logout.svg",
                    color: !darkTheme ? Colors.black : null),
                title: Text("Log Out", style: context.textTheme.bodyMedium),
              ),
            ],
          ),
        ),
      ),
      onDrawerChanged: (change) =>
          ref.watch(hideBottomProvider.notifier).state = change,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: GestureDetector(
                  onTap: () => _scaffoldKey.currentState!.openDrawer(),
                  child: CachedNetworkImage(
                    imageUrl: profilePicture,
                    errorWidget: (context, url, error) => CircleAvatar(
                      backgroundColor: neutral2,
                      radius: 20.r,
                      child: Icon(Icons.person_outline_rounded, size: 16.r),
                    ),
                    progressIndicatorBuilder: (context, url, download) =>
                        Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: neutral2,
                      ),
                    ),
                    imageBuilder: (context, provider) => CircleAvatar(
                      backgroundImage: provider,
                      radius: 16.r,
                    ),
                  ),
                ),
              ),
            ),
            elevation: 1.0,
            automaticallyImplyLeading: false,
            title: GestureDetector(
              onTap: () => scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeIn,
              ),
              child: Text(
                "REDIONES",
                style: context.textTheme.titleSmall,
              ),
            ),
            centerTitle: true,
            // expandedHeight: 100.h,
            pinned: true,
            floating: true,
            collapsedHeight: kToolbarHeight,
            actions: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      darkTheme
                          ? "assets/Message Dark.svg"
                          : "assets/Message.svg",
                      width: 22.r,
                      height: 22.r,
                    ),
                    onPressed: () => context.router.pushNamed(Pages.message),
                    splashRadius: 0.01,
                  ),
                ),
              )
            ],
            // flexibleSpace: FlexibleSpaceBar(
            //   background: SizedBox(
            //     height: 120.h,
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(horizontal: 10.w),
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.end,
            //         children: [
            //           SpecialForm(
            //               controller: searchController,
            //               focus: searchFocus,
            //               borderColor: Colors.transparent,
            //               fillColor: neutral2,
            //               width: 390.w,
            //               height: 40.h,
            //               hint: "What are you looking for?",
            //               prefix: SizedBox(
            //                 height: 40.h,
            //                 width: 40.h,
            //                 child: SvgPicture.asset(
            //                   "assets/Search Icon.svg",
            //                   width: 20.h,
            //                   height: 20.h,
            //                   color:
            //                       darkTheme ? Colors.white54 : Colors.black45,
            //                   fit: BoxFit.scaleDown,
            //                 ),
            //               )),
            //           SizedBox(height: 10.h)
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            sliver: (!fetched || posts.isEmpty)
                ? SliverFillRemaining(
                    child: !fetched
                        ? Skeletonizer(
                            enabled: true,
                            child: ListView.separated(
                              itemCount: dummyPosts.length,
                              itemBuilder: (_, index) => PostContainer(
                                post: dummyPosts[index],
                                onCommentClicked: () {},
                              ),
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: 20.h),
                            ),
                          )
                        : GestureDetector(
                            onTap: refresh,
                            child: Center(
                              child: Text(
                                "No posts available. Tap to refresh",
                                style: context.textTheme.bodyLarge,
                              ),
                            ),
                          ),
                  )
                : SliverFillRemaining(
                    child: AnimationLimiter(
                      child: RefreshIndicator(
                        onRefresh: refresh,
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          controller: scrollController,
                          itemCount: posts.length + 1,
                          separatorBuilder: (_, __) => SizedBox(height: 20.h),
                          itemBuilder: (_, index) {
                            if (index == posts.length) {
                              return SizedBox(height: 100.h);
                            }

                            Post post = posts[index];

                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 750),
                              child: SlideAnimation(
                                verticalOffset: 25.h,
                                child: FadeInAnimation(
                                  child: PostContainer(
                                    post: post,
                                    onCommentClicked: () => onCommentClicked(
                                      post.id,
                                      getComments(post.id),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}

