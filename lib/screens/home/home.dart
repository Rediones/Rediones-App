import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:rediones/api/post_service.dart';
import 'package:rediones/components/poll_data.dart';
import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/postable.dart';
import 'package:rediones/screens/home/comments.dart';
import 'package:rediones/screens/home/home_drawer.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart' show showToast, unFocus;
import 'package:rediones/tools/providers.dart';
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
  bool loadingServer = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

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
  }

  void showMessage(String message) => showToast(message, context);

  Future<void> fetchPosts() async {
    if (loadingServer) return;
    setState(() => loadingServer = true);
    showMessage("Refreshing");

    var response = await getPosts();
    if (!mounted) return;

    if (ref.watch(createdProfileProvider)) {
      ref.watch(createdProfileProvider.notifier).state = false;
    }

    List<PostObject> p = response.payload;
    if (response.status == Status.failed) {
      showToast(response.message, context);
      setState(() => loadingServer = false);
      return;
    }

    List<PostObject> posts = ref.watch(postsProvider.notifier).state;
    posts.insertAll(0, p);
    setState(() => loadingServer = false);

    Isar isar = GetIt.I.get();
    await isar.writeTxn(() async {
      List<Post> serverPosts = p.whereType<Post>().toList();
      List<Poll> serverPolls = p.whereType<Poll>().toList();

      await isar.posts.putAll(serverPosts);
      await isar.polls.putAll(serverPolls);
    });
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

  void checkForChanges() {
    ref.listen(isLoggedInProvider, (oldVal, newVal) {
      if (!oldVal! && newVal) {
        fetchPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    checkForChanges();
    List<PostObject> posts = ref.watch(postsProvider);

    String profilePicture =
        ref.watch(userProvider.select((value) => value.profilePicture));

    bool darkTheme = context.isDark;
    bool isLoggedIn = ref.watch(userProvider) != dummyUser;
    bool loadingLocal = ref.watch(loadingLocalPostsProvider);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const HomeDrawer(),
      onDrawerChanged: (change) =>
          ref.watch(hideBottomProvider.notifier).state = change,
      appBar: AppBar(
        leading: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: GestureDetector(
              onTap: () {
                if (isLoggedIn) {
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
          child: loadingLocal
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
                  ? SizedBox(
                      height: 650.h,
                      width: 390.w,
                      child: Center(
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
                              onTap: fetchPosts,
                              child: Text(
                                "Refresh",
                                style: context.textTheme.titleSmall!.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: appRed,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : AnimationLimiter(
                      child: RefreshIndicator(
                        color: appRed,
                        onRefresh: fetchPosts,
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
                                      post.uuid,
                                      getComments(post.uuid),
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
