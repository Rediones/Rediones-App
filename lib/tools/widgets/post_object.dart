import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:rediones/api/file_handler.dart';
import 'package:rediones/api/post_service.dart';
import 'package:rediones/api/user_service.dart';
import 'package:rediones/components/poll_data.dart';
import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/postable.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/screens/home/comments.dart';
import 'package:rediones/screens/other/media_view.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/providers.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:timeago/timeago.dart' as time;

import 'common.dart' show loader;

class PostObjectContainer extends ConsumerStatefulWidget {
  final PostObject postObject;
  final int? index;

  const PostObjectContainer({
    super.key,
    this.index,
    required this.postObject,
  });

  @override
  ConsumerState<PostObjectContainer> createState() =>
      _PostObjectContainerState();
}

class _PostObjectContainerState extends ConsumerState<PostObjectContainer> {
  int length = 0, comments = 0;
  bool liked = false;
  bool bookmarked = false;
  bool expandText = false;
  late String currentUserID;
  late Future<List<dynamic>?> commentsFuture;

  late bool isPost, mediaAndText;

  @override
  void initState() {
    super.initState();
    if (widget.postObject is Post) {
      Post post = widget.postObject as Post;
      length = post.media.length;
      isPost = true;
      mediaAndText = post.media.isNotEmpty;
    } else {
      isPost = false;
      mediaAndText = false;
    }

    User user = ref.read(userProvider);
    currentUserID = user.uuid;
    liked = widget.postObject.likes.contains(currentUserID);
    bookmarked = widget.postObject.saved.contains(currentUserID);
    comments = widget.postObject.comments;
    commentsFuture = getComments(widget.postObject.uuid);
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

  void refresh(List<dynamic> updatedData) {
    List<String> likes = widget.postObject.likes;
    List<String> saves = widget.postObject.saved;
    bool hasPostAsLiked = likes.contains(currentUserID);
    bool hasPostAsBookmarked = saves.contains(currentUserID);
    PostObject postObject = widget.postObject;
    liked = hasPostAsLiked;
    bookmarked = hasPostAsBookmarked;

    if (updatedData[0] != null) {
      postObject = postObject.copyWith(newComments: updatedData[0] as int);
      comments = updatedData[0] as int;
    }

    if (postObject is Poll && updatedData[1] != null) {
      Poll p = postObject;
      postObject = p.copyWith(newTotalVotes: updatedData[1] as int);
      // totalVotes = updatedData[1] as int;
    }

    updateDatabase(postObject);
    setState(() {});
  }

  void onLike() {
    List<String> likes = widget.postObject.likes;
    bool hasPostAsLiked = likes.contains(currentUserID);

    setState(() {
      liked = !liked;
      if (liked && !hasPostAsLiked) {
        likes.add(currentUserID);
      } else if (!liked && hasPostAsLiked) {
        likes.remove(currentUserID);
      }
    });

    likePost(widget.postObject.uuid).then((response) {
      if (response.status == Status.success) {
        updateDatabase(widget.postObject);
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
    List<String> saves = widget.postObject.saved;
    bool hasPostAsSaved = saves.contains(currentUserID);

    setState(() {
      bookmarked = !bookmarked;
      if (bookmarked && !hasPostAsSaved) {
        saves.add(currentUserID);
      } else if (!bookmarked && hasPostAsSaved) {
        saves.remove(currentUserID);
      }
    });

    savePost(widget.postObject.uuid).then((value) {
      if (value.status == Status.success) {
        updateDatabase(widget.postObject);
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

  bool get shouldFollow {
    User currentUser = ref.watch(userProvider);
    if (widget.postObject.posterID == currentUser.uuid) return false;
    if (currentUser.following.contains(widget.postObject.posterID)) {
      return false;
    }
    return true;
  }

  void onFollow() {
    List<String> following = ref.watch(userProvider.select((u) => u.following));
    following.add(widget.postObject.posterID);
    setState(() {});

    followUser(widget.postObject.posterID).then((resp) {
      if (resp.status == Status.failed) {
        following.remove(widget.postObject.posterID);
        showMessage(resp.message);
      }

      setState(() {});
    });
  }

  void updateCommentsCount(int newCount) {
    setState(() => comments = newCount);
  }

  void goToProfile() {
    User currentUser = ref.watch(userProvider);
    if (widget.postObject.posterID == currentUser.uuid) {
      context.router.pushNamed(Pages.profile);
    } else {
      context.router.pushNamed(Pages.otherProfile, pathParameters: {
        "id": widget.postObject.posterID,
      });
    }
  }

  void showMessage(String message) => showToast(message, context);

  Future<void> navigate() async {
    context.router
        .pushNamed(
      Pages.viewPost,
      pathParameters: {
        "id": widget.postObject.uuid,
      },
      extra: widget.postObject,
    )
        .then((data) {
      if (data == null) return;
      refresh(data as List<dynamic>);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;

    return GestureDetector(
      onTap: navigate,
      child: Container(
        width: 390.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: darkTheme ? neutral : border),
          color: Colors.transparent,
        ),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostHeader(
              object: widget.postObject,
              goToProfile: goToProfile,
              shouldFollow: shouldFollow,
              onFollow: onFollow,
              showExtension: showExtension,
            ),
            SizedBox(height: 20.h),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                    "${widget.postObject.text.substring(0, expandText ? null : (widget.postObject.text.length >= 150 ? 150 : widget.postObject.text.length))}"
                        "${widget.postObject.text.length >= 150 && !expandText ? "..." : ""}",
                    style: context.textTheme.bodyMedium,
                  ),
                  if (widget.postObject.text.length > 150)
                    TextSpan(
                      text: expandText ? " Read Less" : " Read More",
                      style:
                      context.textTheme.bodyMedium!.copyWith(color: appRed),
                      recognizer: TapGestureRecognizer()
                        ..onTap =
                            () => setState(() => expandText = !expandText),
                    ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            if (isPost && widget.postObject is Post && mediaAndText)
              PostContainer(post: widget.postObject as Post),
            if (!isPost && widget.postObject is Poll)
              PollContainer(
                poll: widget.postObject as Poll,
              ),
            PostFooter(
              object: widget.postObject,
              liked: liked,
              bookmarked: bookmarked,
              onBookmark: onBookmark,
              onLike: onLike,
              comments: comments,
              commentsFuture: commentsFuture,
              onCommentsAdded: updateCommentsCount,
            ),
          ],
        ),
      ),
    );
  }
}

class PostHeader extends StatelessWidget {
  final PostObject object;
  final bool shouldFollow;
  final VoidCallback goToProfile, showExtension, onFollow;
  final bool hideMore;

  const PostHeader({
    super.key,
    this.hideMore = false,
    required this.object,
    required this.onFollow,
    required this.shouldFollow,
    required this.goToProfile,
    required this.showExtension,
  });

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;

    return SizedBox(
      height: 40.r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: object.posterPicture,
                errorWidget: (context, url, error) => CircleAvatar(
                  backgroundColor: neutral2,
                  radius: 20.r,
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: Colors.black,
                    size: 16.r,
                  ),
                ),
                progressIndicatorBuilder: (context, url, download) {
                  return Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: neutral2,
                    ),
                  );
                },
                imageBuilder: (context, provider) {
                  return GestureDetector(
                    onTap: goToProfile,
                    child: CircleAvatar(
                      backgroundImage: provider,
                      radius: 20.r,
                    ),
                  );
                },
              ),
              SizedBox(width: 10.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 18.r,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: !shouldFollow ? 180.w : 140.w,
                          ),
                          child: GestureDetector(
                            onTap: goToProfile,
                            child: Text(
                              object.posterName,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodyLarge!
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        if (shouldFollow)
                          Skeleton.ignore(
                            ignore: true,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 10.w),
                                SizedBox(
                                  height: 15.r,
                                  width: 1.5.w,
                                  child: ColoredBox(
                                    color: darkTheme ? neutral : primary1,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                GestureDetector(
                                  onTap: onFollow,
                                  child: Container(
                                    height: 18.r,
                                    width: 18.r,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: darkTheme ? appRed : primary,
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Icon(
                                      Icons.add_rounded,
                                      color: theme,
                                      size: 16.r,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    "@${object.posterUsername}",
                    style: context.textTheme.labelMedium,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: hideMore ? 40.w : 80.w,
            height: 18.r,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  time.format(object.timestamp),
                  style: context.textTheme.labelMedium!.copyWith(color: gray),
                ),
                // if (!hideMore)
                //   GestureDetector(
                //     onTap: showExtension,
                //     child: Icon(
                //       Icons.more_horiz,
                //       color: Colors.grey,
                //       size: 26.r,
                //     ),
                //   )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PostFooter extends ConsumerStatefulWidget {
  final PostObject object;
  final bool liked, bookmarked;
  final VoidCallback onLike, onBookmark;
  final Future commentsFuture;
  final Function(int) onCommentsAdded;
  final int comments;

  const PostFooter({
    super.key,
    required this.comments,
    required this.object,
    required this.liked,
    required this.bookmarked,
    required this.onLike,
    required this.onBookmark,
    required this.commentsFuture,
    required this.onCommentsAdded,
  });

  @override
  ConsumerState<PostFooter> createState() => _PostFooterState();
}

class _PostFooterState extends ConsumerState<PostFooter> {
  late int totalComments;
  late bool bookmarked;

  @override
  void initState() {
    super.initState();
    totalComments = widget.comments;
    bookmarked = widget.bookmarked;
  }

  @override
  void didUpdateWidget(covariant PostFooter oldWidget) {
    totalComments = widget.comments;
    bookmarked = widget.bookmarked;
    super.didUpdateWidget(oldWidget);
  }

  void onCommentClicked(String postID, Future future) {
    showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      builder: (ctx) => PostComments(
        future: future,
        postID: postID,
        parentContext: context,
        updateCommentsCount: updateComment,
      ),
    );
  }

  Future<void> updateComment(int count) async {
    List<PostObject> objects = ref.watch(postsProvider);
    int index = objects.indexWhere((e) => e.uuid == widget.object.uuid);
    if (index != -1) {
      PostObject obj = widget.object.copyWith(newComments: count);
      setState(() => totalComments = count);
      widget.onCommentsAdded(count);

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
                  key: ValueKey<bool>(widget.liked),
                  splashRadius: 0.01,
                  onPressed: widget.onLike,
                  icon: SvgPicture.asset(
                    "assets/Like ${widget.liked ? "F" : "Unf"}illed.svg",
                    color: darkTheme && !widget.liked ? Colors.white : null,
                    width: 22.r,
                  ),
                ),
              ),
            ),
            SizedBox(width: 5.w),
            Text(
              "${widget.object.likes.length}",
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
                onPressed: () => onCommentClicked(
                  widget.object.uuid,
                  getComments(widget.object.uuid),
                ),
              ),
            ),
            SizedBox(width: 5.w),
            Text(
              "$totalComments",
              style: context.textTheme.bodyLarge,
            ),
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
              "${widget.object.shares}",
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
              onPressed: widget.onBookmark,
            ),
          ),
        ),
      ],
    );
  }
}

class PostContainer extends StatelessWidget {
  final Post post;

  const PostContainer({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 370.w,
      height: 230.h,
      child: PageView.builder(
        itemCount: post.media.length,
        itemBuilder: (context, index) => CachedNetworkImage(
          imageUrl: post.media[index],
          errorWidget: (context, url, error) => Container(
            width: 364.w,
            height: 230.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: neutral2,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.broken_image_rounded,
              color: Colors.white,
              size: 36.r,
            ),
          ),
          progressIndicatorBuilder: (context, url, download) => Container(
            width: 364.w,
            height: 230.h,
            decoration: BoxDecoration(
              color: neutral2,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: const Center(
              child: loader,
            ),
          ),
          imageBuilder: (context, provider) => GestureDetector(
            onTap: () => context.router.pushNamed(
              Pages.viewMedia,
              extra: PreviewData(
                images: post.media,
                current: index,
                displayType: DisplayType.network,
              ),
            ),
            child: Container(
              width: 364.w,
              height: 230.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                image: DecorationImage(image: provider, fit: BoxFit.cover),
              ),
              child: post.media.length > 1
                  ? Padding(
                padding: EdgeInsets.only(top: 10.h, left: 10.w),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: 20.h,
                    width: 55.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(10.h),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 5.w, vertical: 2.h),
                    child: Text(
                      "${index + 1} of ${post.media.length}",
                      style: context.textTheme.bodySmall!
                          .copyWith(color: theme),
                    ),
                  ),
                ),
              )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

class PollContainer extends ConsumerStatefulWidget {
  final Poll poll;

  const PollContainer({
    super.key,
    required this.poll,
  });

  @override
  ConsumerState<PollContainer> createState() => _PollContainerState();
}

class _PollContainerState extends ConsumerState<PollContainer> {
  int pollIndex = -1;
  bool hasVoted = false;

  late String currentUserID;
  int totalVotes = 0;

  @override
  void initState() {
    super.initState();

    currentUserID = ref.read(userProvider).uuid;

    for (int i = 0; i < widget.poll.polls.length; ++i) {
      PollChoice choice = widget.poll.polls[i];
      List<String> voters = choice.voters;
      if (!hasVoted && voters.contains(currentUserID)) {
        hasVoted = true;
        pollIndex = i;
      }

      totalVotes += voters.length;
    }
  }

  @override
  void didUpdateWidget(covariant PollContainer oldWidget) {
    totalVotes = 0;
    for (int i = 0; i < widget.poll.polls.length; ++i) {
      PollChoice choice = widget.poll.polls[i];
      List<String> voters = choice.voters;
      if (!hasVoted && voters.contains(currentUserID)) {
        hasVoted = true;
        pollIndex = i;
      }

      totalVotes += voters.length;
    }

    super.didUpdateWidget(oldWidget);
  }

  void vote(String id, int index) {
    setState(() {
      hasVoted = true;
      pollIndex = index;
      totalVotes += 1;
    });
    votePoll(id).then((response) {
      if (response.status == Status.success) {
        widget.poll.polls[index].voters.add(currentUserID);
        setState(() {});
      } else {
        setState(() {
          hasVoted = false;
          pollIndex = -1;
          totalVotes -= 1;
        });
        showMessage("Something went wrong voting on this poll");
      }
    });
  }

  void showMessage(String message) => showToast(message, context);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: List.generate(
            widget.poll.polls.length,
                (index) {
              PollChoice choice = widget.poll.polls[index];
              double percentage = 0.0;
              if (totalVotes > 0) {
                percentage = choice.voters.length / totalVotes;
              }

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (!hasVoted) {
                            vote(choice.uuid, index);
                          }
                        },
                        child: Row(
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border.all(color: appRed, width: 2.0),
                                color: (hasVoted && pollIndex == index)
                                    ? appRed
                                    : null,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: SizedBox(
                                width: 16.r,
                                height: 16.r,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              choice.name,
                              style: context.textTheme.bodyLarge,
                            )
                          ],
                        ),
                      ),
                      Text(
                        percentage == 0
                            ? "0"
                            : "${(percentage * 100).toStringAsFixed(0)}%",
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.r + 5.w),
                    child: LinearProgressIndicator(
                      color: appRed,
                      backgroundColor: context.isDark ? neutral2 : gray3,
                      minHeight: 10.h,
                      borderRadius: BorderRadius.circular(5.h),
                      value: percentage,
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              );
            },
          ),
        ),
        SizedBox(height: 5.h),
        Padding(
          padding: EdgeInsets.only(left: 20.r + 5.w),
          child: Text(
            "$totalVotes vote${totalVotes == 1 ? "" : "s"}",
            style: context.textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
