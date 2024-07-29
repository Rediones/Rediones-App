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
import 'package:rediones/tools/widgets/home.dart';

class ViewPostObjectPage extends ConsumerStatefulWidget {
  final PostObject object;

  const ViewPostObjectPage({
    super.key,
    required this.object,
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
  late Future<RedionesResponse<List<CommentData>>> commentsFuture;

  late bool isPost, mediaAndText;

  @override
  void initState() {
    super.initState();
    if (widget.object is Post) {
      Post post = widget.object as Post;
      length = post.media.length;
      isPost = true;
      mediaAndText = post.type == MediaType.imageAndText;
    } else {
      isPost = false;
      mediaAndText = false;
    }

    User user = ref.read(userProvider);
    currentUserID = user.uuid;
    liked = widget.object.likes.contains(currentUserID);
    bookmarked = user.savedPosts.contains(widget.object.uuid);
    commentsFuture = getComments(widget.object.uuid);
  }


  void showExtension() {
    bool darkTheme = context.isDark;
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 360.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.h),
            SvgPicture.asset("assets/Modal Line.svg",
                color: darkTheme ? Colors.white : null),
            SizedBox(height: 30.h),
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
    likePost(widget.object.uuid).then((response) {
      if (response.status == Status.success) {
        showToast(response.message, context);
        bool add = false;
        if (response.payload.contains(currentUserID) &&
            !widget.object.likes.contains(currentUserID)) {
          widget.object.likes.add(currentUserID);
          add = true;
        } else if (!response.payload.contains(currentUserID) &&
            widget.object.likes.contains(currentUserID)) {
          widget.object.likes.remove(currentUserID);
        }
        updateDatabaseForLikes(widget.object, currentUserID, add);
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
    savePost(widget.object.uuid).then((value) {
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
    if (widget.object.posterID == currentUser.uuid) return false;
    if (currentUser.following.contains(widget.object.posterID)) {
      return false;
    }
    return true;
  }

  void goToProfile() {
    User currentUser = ref.watch(userProvider);
    if (widget.object.posterID == currentUser.uuid) {
      context.router.pushNamed(Pages.profile);
    } else {
      context.router.pushNamed(
        Pages.otherProfile,
        extra: widget.object.posterID,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            padding: EdgeInsets.only(right: 15.w),
            child: IconButton(
              onPressed: showExtension,
              icon: const Icon(Icons.more_vert_rounded),
              iconSize: 26.r,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10.h),
                PostHeader(
                  object: widget.object,
                  shouldFollow: shouldFollow,
                  goToProfile: goToProfile,
                  showExtension: showExtension,
                  hideMore: true,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
