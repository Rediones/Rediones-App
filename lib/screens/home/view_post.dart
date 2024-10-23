import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:rediones/api/post_service.dart';
import 'package:rediones/api/user_service.dart';
import 'package:rediones/components/comment_data.dart';
import 'package:rediones/components/poll_data.dart';
import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/postable.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/tools/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'comments.dart';

class ViewPostData {
  final String id;
  final PostObject? object;

  const ViewPostData({
    this.id = "",
    this.object,
  });
}

class ViewPostObjectPage extends ConsumerStatefulWidget {
  final ViewPostData info;

  const ViewPostObjectPage({
    super.key,
    required this.info,
  });

  @override
  ConsumerState<ViewPostObjectPage> createState() => _ViewPostObjectPageState();
}

class _ViewPostObjectPageState extends ConsumerState<ViewPostObjectPage> {
  int length = 0, totalComments = 0;
  bool liked = false;
  bool bookmarked = false;
  bool expandText = false;
  late String currentUserID;
  final List<CommentData> comments = [];
  late bool isPost, mediaAndText;

  final TextEditingController controller = TextEditingController();

  PostObject? object;
  bool loading = false, loadingComments = true;

  @override
  void initState() {
    super.initState();
    User user = ref.read(userProvider);
    currentUserID = user.uuid;

    if (widget.info.object != null) {
      initPost();
    } else {
      loading = true;
      Future.delayed(Duration.zero, () => getPost());
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void initPost() {
    object = widget.info.object;

    if (object! is Post) {
      Post post = object! as Post;
      length = post.media.length;
      isPost = true;
      mediaAndText = post.type == MediaType.imageAndText;
    } else {
      isPost = false;
      mediaAndText = false;
    }

    User user = ref.read(userProvider);
    liked = object!.likes.contains(currentUserID);
    bookmarked = object!.saved.contains(user.uuid);
    totalComments = object!.comments;
    getPostComments(object!.uuid);
  }

  void getPost() {
    getPostById(widget.info.id).then((resp) {
      if (!mounted) return;

      if (resp.status == Status.failed) {
        setState(() => loading = false);
        return;
      }

      object = resp.payload;
      loading = false;

      setState(() {});

      if (object == null) return;

      assign(object!);
    });
  }

  void assign(PostObject object) {
    if (object is Post) {
      Post post = object;
      length = post.media.length;
      isPost = true;
      mediaAndText = post.type == MediaType.imageAndText;
    } else {
      isPost = false;
      mediaAndText = false;
    }

    User user = ref.watch(userProvider);
    liked = object.likes.contains(currentUserID);
    bookmarked = object.saved.contains(user.uuid);
    totalComments = object.comments;
    getPostComments(object.uuid);
  }

  Future<void> getPostComments(String id) async {
    var response = await getComments(id);
    if (response != null) {
      comments.clear();
      comments.addAll(response);
    }

    setState(() {
      loadingComments = false;
      totalComments = response?.length ?? totalComments;
    });
  }

  void showExtension() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => SizedBox(
        height: 310.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              leading: SvgPicture.asset("assets/Link Red.svg"),
              title: Text(
                "Copy Link",
                style: context.textTheme.bodyLarge,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: SvgPicture.asset("assets/Unfollow Red.svg"),
              title: Text(
                "Unfollow",
                style: context.textTheme.bodyLarge,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: SvgPicture.asset("assets/Not Interested Red.svg"),
              title: Text(
                "Not Interested",
                style: context.textTheme.bodyLarge,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: SvgPicture.asset("assets/Block Red.svg"),
              title: Text(
                "Block User",
                style: context.textTheme.bodyLarge,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: SvgPicture.asset("assets/Report Red.svg"),
              title: Text(
                "Report Post",
                style: context.textTheme.bodyLarge,
              ),
              onTap: () {},
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  void onLike() {
    List<String> likes = object!.likes;
    bool hasPostAsLiked = likes.contains(currentUserID);

    setState(() {
      liked = !liked;
      if (liked && !hasPostAsLiked) {
        likes.add(currentUserID);
      } else if (!liked && hasPostAsLiked) {
        likes.remove(currentUserID);
      }
    });

    likePost(object!.uuid).then((response) {
      if (response.status == Status.success) {
        updateDatabase(object!);
        if (!mounted) return;
        setState(() {});
      } else {
        liked = !liked;
        hasPostAsLiked = likes.contains(currentUserID);

        if (liked && !hasPostAsLiked) {
          likes.add(currentUserID);
        } else if (!liked && hasPostAsLiked) {
          likes.remove(currentUserID);
        }

        if (!mounted) return;
        setState(() {});
        showMessage("Unable to ${liked ? "like" : "unlike"} your post");
      }
    });
  }

  Future<void> updateComment(int count) async {
    List<PostObject> objects = ref.watch(postsProvider);
    int index = objects.indexWhere((e) => e.uuid == object!.uuid);
    if (index != -1) {
      PostObject obj = object!.copyWith(newComments: count);
      Isar isar = GetIt.I.get();
      if (obj is Post) {
        Post post = obj;
        await isar.writeTxn(() async {
          await isar.posts.put(post);
        });
      } else if (obj is Poll) {
        Poll poll = obj;
        await isar.writeTxn(() async {
          await isar.polls.put(poll);
        });
      }
    }
  }

  Future<void> updateDatabase(PostObject object) async {
    Isar isar = GetIt.I.get();
    if (object is Post) {
      Post post = object;

      await isar.writeTxn(() async {
        await isar.posts.put(post);
      });
    } else if (object is Poll) {
      Poll poll = object;

      await isar.writeTxn(() async {
        await isar.polls.put(poll);
      });
    }
  }

  void onBookmark() {
    List<String> saves = object!.saved;
    bool hasPostAsSaved = saves.contains(currentUserID);

    setState(() {
      bookmarked = !bookmarked;
      if (bookmarked && !hasPostAsSaved) {
        saves.add(currentUserID);
      } else if (!bookmarked && hasPostAsSaved) {
        saves.remove(currentUserID);
      }
    });

    savePost(object!.uuid).then((value) {
      if (value.status == Status.success) {
        updateDatabase(object!);
        if (!mounted) return;
        setState(() {});
      } else {
        bookmarked = !bookmarked;
        hasPostAsSaved = saves.contains(currentUserID);

        if (bookmarked && !hasPostAsSaved) {
          saves.add(currentUserID);
        } else if (!bookmarked && hasPostAsSaved) {
          saves.remove(currentUserID);
        }

        if (!mounted) return;
        setState(() {});

        showMessage("Unable to ${bookmarked ? "save" : "un-save"} your post");
      }
    });
  }

  void showMessage(String message) => showToast(message, context);

  void onFollow() {
    List<String> following = ref.watch(userProvider.select((u) => u.following));
    following.add(object!.posterID);
    setState(() {});

    followUser(object!.posterID).then((resp) {
      if (resp.status == Status.failed) {
        following.remove(object!.posterID);
        showMessage(resp.message);
      }

      setState(() {});
    });
  }

  bool get shouldFollow {
    User currentUser = ref.watch(userProvider);
    if (object!.posterID == currentUser.uuid) return false;
    if (currentUser.following.contains(object!.posterID)) {
      return false;
    }
    return true;
  }

  void goToProfile() {
    User currentUser = ref.watch(userProvider);
    if (object!.posterID == currentUser.uuid) {
      context.router.pushNamed(Pages.profile);
    } else {
      context.router.pushNamed(Pages.otherProfile, pathParameters: {
        "id": object!.posterID,
      });
    }
  }

  void exitPage() {
    if (context.mounted) {
      int? count;
      if (object != null) {
        count = loadingComments ? object!.comments : comments.length;
      }
      context.router.pop([count]);
    }
  }

  void onSend(String text) async {
    controller.clear();
    unFocus();

    RedionesResponse<CommentInfo?> resp =
        await createComment(object!.uuid, text);
    if (resp.status == Status.success) {
      comments.add(resp.payload!.data);
      updateComment(resp.payload!.count);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: () async {
        exitPage();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  if (loading)
                    const SliverFillRemaining(
                      child: Center(child: loader),
                    ),
                  if (!loading)
                    SliverAppBar(
                      pinned: true,
                      leading: IconButton(
                        iconSize: 26.r,
                        splashRadius: 0.01,
                        icon: const Icon(Icons.chevron_left),
                        onPressed: exitPage,
                      ),
                      elevation: 0.0,
                      leadingWidth: 30.w,
                      title: Text(
                        "Post",
                        style: context.textTheme.titleLarge,
                      ),
                      // actions: [
                      //   Padding(
                      //     padding: EdgeInsets.only(right: 0.w),
                      //     child: IconButton(
                      //       onPressed: showExtension,
                      //       icon: const Icon(Icons.more_vert_rounded),
                      //       iconSize: 26.r,
                      //     ),
                      //   )
                      // ],
                    ),
                  if (!loading && object == null)
                    SliverFillRemaining(
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
                              "Oops. Something went wrong somewhere.",
                              style: context.textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            GestureDetector(
                              onTap: () {
                                setState(() => loading = true);
                                getPost();
                              },
                              child: Text(
                                "Retry",
                                style: context.textTheme.titleSmall!.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: appRed,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (!loading && object != null)
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      sliver: SliverToBoxAdapter(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.h),
                              PostHeader(
                                object: object!,
                                onFollow: onFollow,
                                shouldFollow: shouldFollow,
                                goToProfile: goToProfile,
                                showExtension: showExtension,
                                hideMore: true,
                              ),
                              SizedBox(height: 20.h),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "${object!.text.substring(0, expandText ? null : (object!.text.length >= 150 ? 150 : object!.text.length))}"
                                          "${object!.text.length >= 150 && !expandText ? "..." : ""}",
                                      style: context.textTheme.bodyMedium,
                                    ),
                                    if (object!.text.length > 150)
                                      TextSpan(
                                        text: expandText
                                            ? " Read Less"
                                            : " Read More",
                                        style: context.textTheme.bodyMedium!
                                            .copyWith(color: appRed),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => setState(
                                              () => expandText = !expandText),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.h),
                              if (isPost && mediaAndText)
                                PostContainer(post: object! as Post),
                              if (!isPost)
                                PollContainer(
                                  poll: object! as Poll,
                                ),
                              ViewPostFooter(
                                object: object!,
                                liked: liked,
                                bookmarked: bookmarked,
                                onBookmark: onBookmark,
                                onLike: onLike,
                                length: loadingComments
                                    ? object!.comments
                                    : comments.length,
                              ),
                              SizedBox(height: 20.h),
                              if (comments.isNotEmpty)
                                Column(
                                  children: [
                                    Text(
                                      "${comments.length} comment${comments.length == 1 ? "" : "s"}",
                                      style: context.textTheme.titleSmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 20.h),
                                  ],
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (loadingComments && object != null)
                    SliverToBoxAdapter(
                      child: SizedBox(
                        width: 390.w,
                        height: 400.h,
                        child: loader,
                      ),
                    ),
                  if (!loadingComments && object != null)
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      sliver: SliverList.separated(
                        itemCount: comments.length + 1,
                        itemBuilder: (_, index) {
                          if (index == comments.length) {
                            return SizedBox(height: 80.h);
                          }
                          return CommentDataContainer(data: comments[index]);
                        },
                        separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      ),
                    ),
                ],
              ),
              if (!loadingComments && object != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 60.h,
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    color: !context.isDark
                        ? Colors.white
                        : const Color(0xFF121212),
                    child: SpecialForm(
                      controller: controller,
                      suffix: IconButton(
                        icon: Icon(
                          Icons.send_rounded,
                          size: 26.r,
                          color: appRed,
                        ),
                        onPressed: () => onSend(controller.text),
                        splashRadius: 0.01,
                      ),
                      action: TextInputAction.send,
                      borderColor: Colors.transparent,
                      width: 380.w,
                      height: 40.h,
                      hint: "Type your comment here",
                      onActionPressed: onSend,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ViewPostFooter extends StatelessWidget {
  final PostObject object;
  final bool liked, bookmarked;
  final VoidCallback onLike, onBookmark;
  final int length;

  const ViewPostFooter({
    super.key,
    required this.object,
    required this.liked,
    required this.length,
    required this.bookmarked,
    required this.onLike,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Skeleton.ignore(
              ignore: true,
              child: AnimatedSwitcherZoom.zoomIn(
                duration: const Duration(milliseconds: 200),
                child: IconButton(
                  key: ValueKey<bool>(liked),
                  splashRadius: 0.01,
                  onPressed: onLike,
                  icon: SvgPicture.asset(
                    "assets/Like ${liked ? "F" : "Unf"}illed.svg",
                    color: darkTheme && !liked ? Colors.white : null,
                    width: 22.r,
                  ),
                ),
              ),
            ),
            SizedBox(width: 5.w),
            Text(
              "${object.likes.length}",
              style: context.textTheme.bodyLarge,
            )
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Skeleton.ignore(
              ignore: true,
              child: IconButton(
                icon: SvgPicture.asset(
                  "assets/Comment Post.svg",
                  color: darkTheme ? Colors.white : null,
                  width: 22.r,
                ),
                onPressed: () {},
              ),
            ),
            SizedBox(width: 5.w),
            Text(
              "$length",
              style: context.textTheme.bodyLarge,
            )
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Skeleton.ignore(
              ignore: true,
              child: IconButton(
                icon: SvgPicture.asset(
                  "assets/Reply.svg",
                  color: darkTheme ? Colors.white : null,
                  width: 22.r,
                ),
                onPressed: () {},
                splashRadius: 0.01,
              ),
            ),
            SizedBox(width: 5.w),
            Text(
              "${object.shares}",
              style: context.textTheme.bodyLarge,
            )
          ],
        ),
        Skeleton.ignore(
          ignore: true,
          child: AnimatedSwitcherZoom.zoomIn(
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              key: ValueKey<bool>(bookmarked),
              icon: SvgPicture.asset(
                "assets/Bookmark${bookmarked ? " Filled" : ""}.svg",
                color: darkTheme && !bookmarked ? Colors.white : null,
                width: bookmarked ? 24.r : 18.r,
              ),
              onPressed: onBookmark,
            ),
          ),
        ),
      ],
    );
  }
}
