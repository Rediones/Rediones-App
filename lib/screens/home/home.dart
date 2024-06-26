import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:rediones/api/post_service.dart';
import 'package:rediones/components/postable.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/screens/home/comments.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart' show showToast, unFocus;
import 'package:rediones/tools/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final FocusNode searchFocus = FocusNode();
  bool loading = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void refreshPosts() {}

  Future<void> fetchPosts() async {
    var response = await getPosts();
    if (!mounted) return;

    if (ref.watch(createdProfileProvider)) {
      ref.watch(createdProfileProvider.notifier).state = false;
    }

    List<PostObject> p = response.payload;
    if (response.status == Status.failed) {
      showToast(response.message, context);
      setState(() => loading = false);
      return;
    }

    List<PostObject> posts = ref.watch(postsProvider.notifier).state;
    posts.clear();
    posts.addAll(p);

    // final PostObjectRepository repository = GetIt.I.get();
    // repository.clearAllAndAddAll(p);

    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    searchFocus.addListener(() {
      if (searchFocus.hasFocus) {
        unFocus();
        context.router.pushNamed(Pages.search);
      }
    });

    if (ref.read(createdProfileProvider)) {
      fetchPosts();
    }

    Future.delayed(Duration.zero, getLocalPosts);
  }

  Future<void> getLocalPosts() async {
    // final PostObjectRepository repository = GetIt.I.get();
    // List<PostObject> posts = await repository.getAll();
    // if (posts.isEmpty) {
    //   fetchPosts();
    // } else {
    //   ref.watch(postsProvider.notifier).state.addAll(posts);
    //   setState(() => loading = false);
    // }
    await fetchPosts();
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
    setState(() => loading = true);
    ref.watch(postsProvider).clear();
    fetchPosts();
  }

  void checkForChanges() {
      ref.listen(userProvider, (oldUser, newUser) {
          if(oldUser == dummyUser && newUser != dummyUser && ref.watch(postsProvider).isEmpty) {
            refresh();
          }
      });
  }

  @override
  Widget build(BuildContext context) {
    checkForChanges();
    List<PostObject> posts = ref.watch(postsProvider);
    String profilePicture =
        ref.watch(userProvider.select((value) => value.profilePicture));
    String username = ref.watch(userProvider.select((value) => value.username));
    String nickname = ref.watch(userProvider.select((value) => value.nickname));

    bool darkTheme = context.isDark;

    bool isLoggedIn = ref.watch(userProvider) != dummyUser;

    return Scaffold(
      key: _scaffoldKey,
      drawer: SizedBox(
        width: 290.w,
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
                                style: context.textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32.sp),
                              ),
                            ),
                            Text(
                              "@$nickname",
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodyLarge,
                            )
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
                leading: SvgPicture.asset(
                  "assets/Groups.svg",
                  color: appRed,
                ),
                title: Text("Groups", style: context.textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                  context.router.pushNamed(Pages.groups);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                leading: SvgPicture.asset(
                  "assets/Community.svg",
                  color: appRed,
                ),
                title: Text("Projects", style: context.textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                  context.router.pushNamed(Pages.communityPractice);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                leading: SvgPicture.asset(
                  "assets/Events.svg",
                  color: appRed,
                ),
                title: Text("Events", style: context.textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                  context.router.pushNamed(Pages.events);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                onTap: () {
                  logout(ref);
                  context.router.goNamed(Pages.login);
                },
                leading: SvgPicture.asset(
                  "assets/Logout.svg",
                  color: appRed,
                ),
                title: Text("Log Out", style: context.textTheme.bodyLarge),
              ),
            ],
          ),
        ),
      ),
      onDrawerChanged: (change) =>
          ref.watch(hideBottomProvider.notifier).state = change,
      appBar: AppBar(
        leading: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: GestureDetector(
              onTap: () {
                if(isLoggedIn) {
                  _scaffoldKey.currentState!.openDrawer();
                }
              },
              child: CachedNetworkImage(
                imageUrl: profilePicture,
                errorWidget: (context, url, error) => CircleAvatar(
                  backgroundColor: neutral2,
                  radius: 20.r,
                  child: Icon(Icons.person_outline_rounded, size: 16.r),
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
                  radius: 16.r,
                ),
              ),
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {
            if (posts.length < 4) {
              setState(() => loading = true);
              fetchPosts();
            } else {
              scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeIn,
              );
            }
          },
          child: Text(
            "REDIONES",
            style: context.textTheme.titleMedium,
          ),
        ),
        centerTitle: true,
        actions: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: IconButton(
                icon: SvgPicture.asset(
                  darkTheme ? "assets/Message Dark.svg" : "assets/Message.svg",
                  width: 22.r,
                  height: 22.r,
                ),
                onPressed: () => context.router.pushNamed(Pages.message),
                splashRadius: 0.01,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          child: loading
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
              : (!loading && posts.isEmpty)
                  ? Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "No posts available.",
                              style: context.textTheme.bodyLarge,
                            ),
                            TextSpan(
                                text: " Tap to refresh",
                                style: context.textTheme.bodyLarge!
                                    .copyWith(color: appRed),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = refresh),
                          ],
                        ),
                      ),
                    )
                  : AnimationLimiter(
                      child: RefreshIndicator(
                        color: appRed,
                        onRefresh: refresh,
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          controller: scrollController,
                          itemCount: posts.length + 2,
                          separatorBuilder: (_, __) => SizedBox(height: 20.h),
                          itemBuilder: (_, index) {
                            if (index == 0) {
                              return SizedBox(
                                height: 50.h,
                                child: Center(
                                  child: SpecialForm(
                                    controller: searchController,
                                    focus: searchFocus,
                                    borderColor: Colors.transparent,
                                    fillColor: neutral2,
                                    width: 390.w,
                                    height: 40.h,
                                    hint: "What are you looking for?",
                                    prefix: SizedBox(
                                      height: 40.h,
                                      width: 40.h,
                                      child: SvgPicture.asset(
                                        "assets/Search Icon.svg",
                                        width: 20.h,
                                        height: 20.h,
                                        color: darkTheme
                                            ? Colors.white54
                                            : Colors.black45,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }

                            if (index == posts.length + 1) {
                              return SizedBox(height: 100.h);
                            }

                            PostObject post = posts[index - 1];

                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 750),
                              child: SlideAnimation(
                                verticalOffset: 25.h,
                                child: FadeInAnimation(
                                  child: PostObjectContainer(
                                    postObject: post,
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
      ),
    );
  }
}
