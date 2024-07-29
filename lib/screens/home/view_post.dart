import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:rediones/api/post_service.dart';
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

class ViewPostObjectPage extends ConsumerStatefulWidget {
  final String id;

  const ViewPostObjectPage({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<ViewPostObjectPage> createState() => _ViewPostObjectPageState();
}

class _ViewPostObjectPageState extends ConsumerState<ViewPostObjectPage> {
  int length = 0;
  bool liked = false;
  bool bookmarked = false;
  bool expandText = false;
  late String currentUserID;
  final List<CommentData> comments = [];
  late bool isPost, mediaAndText;

  final TextEditingController controller = TextEditingController();

  PostObject? object;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loading = true;
    getPost();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void getPost() {
    getPostById(widget.id).then((resp) {
      if (!mounted) return;

      if (resp.status == Status.failed) {
        showToast(resp.message, context);
        return;
      }

      object = resp.payload;
      loading = false;

      setState(() {});

      if (object == null) return;

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
      currentUserID = user.uuid;
      liked = object!.likes.contains(currentUserID);
      bookmarked = user.savedPosts.contains(object!.uuid);
      getPostComments(object!.uuid);
    });
  }

  Future<void> getPostComments(String id) async {
    var response = await getComments(id);
    comments.clear();
    comments.addAll(response);
    setState(() {});
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
    setState(() => liked = !liked);
    likePost(object!.uuid).then((response) {
      if (response.status == Status.success) {
        showToast(response.message, context);
        bool add = false;
        if (response.payload.contains(currentUserID) &&
            !object!.likes.contains(currentUserID)) {
          object!.likes.add(currentUserID);
          add = true;
        } else if (!response.payload.contains(currentUserID) &&
            object!.likes.contains(currentUserID)) {
          object!.likes.remove(currentUserID);
        }
        updateDatabaseForLikes(object!, currentUserID, add);
        setState(() {});
      } else {
        setState(() => liked = !liked);
        showToast("Something went wrong liking your post", context);
      }
    });
  }

  Future<void> updateDatabaseForLikes(
      PostObject object, String id, bool add) async {
    Isar isar = GetIt.I.get();
    if (object is Post) {
      Post post = object;
      if (add) {
        post.likes.add(id);
      } else {
        post.likes.remove(id);
      }
      await isar.writeTxn(() async {
        await isar.posts.put(post);
      });
    } else if (object is Poll) {
      Poll poll = object;
      if (add) {
        poll.likes.add(id);
      } else {
        poll.likes.remove(id);
      }
      await isar.writeTxn(() async {
        await isar.polls.put(poll);
      });
    }
  }

  Future<void> updateDatabaseForSaved(List<String> saved) async {
    Isar isar = GetIt.I.get();
    int id = ref.watch(userProvider.select((value) => value.isarId));
    User? user = await isar.users.get(id);
    if (user != null) {
      user.savedPosts.clear();
      user.savedPosts.addAll(saved);
      await isar.writeTxn(() async {
        await isar.users.put(user);
      });
    }
  }

  void onBookmark() {
    setState(() => bookmarked = !bookmarked);
    savePost(object!.uuid).then((value) {
      if (value.status == Status.success) {
        showToast(value.message, context);
        List<String> postsID =
            ref.watch(userProvider.select((value) => value.savedPosts));
        postsID.clear();
        postsID.addAll(value.payload);
        updateDatabaseForSaved(value.payload);
      } else {
        setState(() => bookmarked = !bookmarked);
        showToast("Something went wrong", context);
      }
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
      context.router.pushNamed(
        Pages.otherProfile,
        pathParameters: {
          "id": object!.posterID,
        }
      );
    }
  }

  void onSend(String text) async {
    controller.clear();
    unFocus();

    RedionesResponse<CommentData?> resp =
        await createComment(object!.uuid, text);
    if (resp.status == Status.success) {
      comments.add(resp.payload!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      onPressed: () => context.router.pop(),
                    ),
                    elevation: 0.0,
                    leadingWidth: 30.w,
                    title: Text(
                      "Post",
                      style: context.textTheme.titleLarge,
                    ),
                    actions: [
                      Padding(
                        padding: EdgeInsets.only(right: 0.w),
                        child: IconButton(
                          onPressed: showExtension,
                          icon: const Icon(Icons.more_vert_rounded),
                          iconSize: 26.r,
                        ),
                      )
                    ],
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
                            if (!isPost) PollContainer(poll: object! as Poll),
                            ViewPostFooter(
                              object: object!,
                              liked: liked,
                              bookmarked: bookmarked,
                              onBookmark: onBookmark,
                              onLike: onLike,
                              length: comments.length,
                            ),
                            SizedBox(height: 20.h),
                            if (comments.isNotEmpty)
                              Column(
                                children: [
                                  Text(
                                    "${comments.length} comment${comments.length == 1 ? "" : "s"}",
                                    style: context.textTheme.titleSmall!
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 20.h),
                                ],
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                if (!loading && object != null && comments.isNotEmpty)
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
            if (!loading && object != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60.h,
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  color: !context.isDark ? Colors.white : primary,
                  child: SpecialForm(
                    controller: controller,
                    suffix: IconButton(
                      icon:
                          Icon(Icons.send_rounded, size: 18.r, color: appRed),
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
