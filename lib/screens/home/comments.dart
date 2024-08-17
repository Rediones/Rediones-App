import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:rediones/api/post_service.dart';
import 'package:rediones/components/comment_data.dart';
import 'package:rediones/components/poll_data.dart';
import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/postable.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/tools/widgets.dart';
import 'package:timeago/timeago.dart' as time;

class PostComments extends ConsumerStatefulWidget {
  final Future future;
  final String postID;
  final BuildContext parentContext;
  final Function? updateCommentsCount;

  const PostComments({
    super.key,
    this.updateCommentsCount,
    required this.future,
    required this.postID,
    required this.parentContext,
  });

  @override
  ConsumerState<PostComments> createState() => _PostCommentsState();
}

class _PostCommentsState extends ConsumerState<PostComments> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    scrollController.dispose();
    controller.dispose();
    super.dispose();
  }

  void onSend(List<CommentData> response, String text) async {
    controller.clear();

    RedionesResponse<CommentInfo?> resp =
        await createComment(widget.postID, text);
    if (resp.status == Status.success) {
      response.add(resp.payload!.data);
      updateComment(resp.payload!.count);
      setState(() {});
      if(widget.updateCommentsCount != null) {
        widget.updateCommentsCount!(response.length);
      }
    }
  }

  Future<void> updateComment(int count) async {
    List<PostObject> objects = ref.watch(postsProvider);
    int index = objects.indexWhere((e) => e.uuid == widget.postID);
    if(index != -1) {
      PostObject obj = objects[index].copyWith(newComments: count);
      ref.watch(postsProvider.notifier).state = [
        ...objects.sublist(0, index),
        obj,
        ...objects.sublist(index + 1),
      ];

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
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: SizedBox(
        height: 420.h,
        child: FutureBuilder(
          future: widget.future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                children: [
                  Expanded(
                    child: Center(
                      child: CenteredPopup(),
                    ),
                  ),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<CommentData>? response = snapshot.data;

              if(response == null) {
                return Center(
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
                        "An error occurred. Please try again",
                        style:
                        context.textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                );
              }

              SpecialForm commentSection = SpecialForm(
                controller: controller,
                suffix: IconButton(
                  icon: const Icon(
                    Icons.send_rounded,
                    color: appRed,
                  ),
                  iconSize: 26.r,
                  onPressed: () => onSend(response, controller.text),
                  splashRadius: 0.01,
                ),
                fillColor: darkTheme ? neutral2 : authFieldBackground,
                borderColor: Colors.transparent,
                action: TextInputAction.send,
                width: 370.w,
                height: 40.h,
                hint: "Type your comment here",
                onActionPressed: onSend,
              );

              if (response.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 365.h,
                        child: Center(
                          child: Text(
                            "Be the first to comment on this post.",
                            style: context.textTheme.bodyLarge,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: commentSection,
                      )
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 15.w),
                      child: Text(
                        "${response.length} comment${response.length == 1 ? "" : "s"}",
                        style: context.textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  SizedBox(
                    height: 320.h,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: ListView.separated(
                        controller: scrollController,
                        itemCount: response.length + 1,
                        itemBuilder: (_, index) {
                          if (index == response.length) {
                            return SizedBox(height: 10.h);
                          }
                          CommentData data = response[index];
                          return CommentDataContainer(data: data);
                        },
                        separatorBuilder: (_, __) => SizedBox(height: 15.h),
                      ),
                    ),
                  ),
                  commentSection,
                ],
              );
            } else {
              return SizedBox(
                height: 420.h,
                child: Center(
                  child: Text(
                    "Could not fetch the comments under this post. Please try again!",
                    style: context.textTheme.bodyLarge,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class CommentDataContainer extends StatelessWidget {
  final CommentData data;

  const CommentDataContainer({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    bool isLiked() => false;

    return Container(
      width: 390.w,
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: neutral2),
        borderRadius: BorderRadius.circular(15.r),
        color: Colors.transparent,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: data.postedBy.profilePicture,
            errorWidget: (context, url, error) => CircleAvatar(
              backgroundColor: neutral2,
              radius: 16.r,
              child: Icon(Icons.person_outline_rounded,
                  color: Colors.black, size: 12.r),
            ),
            progressIndicatorBuilder: (context, url, download) => Center(
              child: CircularProgressIndicator(
                  color: appRed, value: download.progress),
            ),
            imageBuilder: (context, provider) => CircleAvatar(
              backgroundImage: provider,
              radius: 16.r,
            ),
          ),
          SizedBox(width: 10.w),
          SizedBox(
            width: 280.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.postedBy.username,
                  style: context.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: 280.w,
                  child: Text(
                    data.content,
                    style: context.textTheme.bodyMedium,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  time.format(data.created),
                  style:
                  context.textTheme.bodyMedium!.copyWith(color: appRed),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Row(
                //       mainAxisSize: MainAxisSize.min,
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         IconButton(
                //           icon: Icon(
                //             isLiked() ? Boxicons.bxs_like : Boxicons.bx_like,
                //             color: isLiked() ? niceBlue : null,
                //             size: 18.r,
                //           ),
                //           onPressed: () {},
                //           splashRadius: 0.01,
                //         ),
                //         Text("Like", style: context.textTheme.bodySmall),
                //       ],
                //     ),
                //     Row(
                //       mainAxisSize: MainAxisSize.min,
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         IconButton(
                //           icon: Icon(Boxicons.bx_reply, size: 18.r),
                //           onPressed: () {},
                //           splashRadius: 0.01,
                //         ),
                //         Text("Reply", style: context.textTheme.bodySmall),
                //       ],
                //     ),
                //     Text(
                //       time.format(data.created),
                //       style:
                //           context.textTheme.bodySmall!.copyWith(color: appRed),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
