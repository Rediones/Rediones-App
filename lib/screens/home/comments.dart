import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/api/post_service.dart';
import 'package:rediones/components/comment_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/widgets.dart';
import 'package:timeago/timeago.dart' as time;

class PostComments extends StatefulWidget {
  final Future future;
  final String postID;
  final BuildContext parentContext;

  const PostComments({
    super.key,
    required this.future,
    required this.postID,
    required this.parentContext,
  });

  @override
  State<PostComments> createState() => _PostCommentsState();
}

class _PostCommentsState extends State<PostComments> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    scrollController.dispose();
    controller.dispose();
    super.dispose();
  }

  void onSend(RedionesResponse<List<CommentData>> response, String text) async {
    controller.clear();

    RedionesResponse<CommentData?> resp =
        await createComment(widget.postID, text);
    if (resp.status == Status.success) {
      response.payload.add(resp.payload!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
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
              RedionesResponse<List<CommentData>> response =
                  snapshot.data as RedionesResponse<List<CommentData>>;
              if (response.status == Status.failed) {
                return Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          response.message,
                          style: context.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                );
              }

              SpecialForm commentSection = SpecialForm(
                controller: controller,
                suffix: IconButton(
                  icon: Icon(Icons.send_rounded, size: 18.r, color: appRed),
                  onPressed: () => onSend(response, controller.text),
                  splashRadius: 0.01,
                ),
                action: TextInputAction.send,
                width: 370.w,
                height: 40.h,
                hint: "Type your comment here",
                onActionPressed: onSend,
              );

              if (response.payload.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 380.h,
                      child: Center(
                        child: Text(
                          "Be the first to comment on this post.",
                          style: context.textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: commentSection)
                  ],
                );
              }

              return Column(
                children: [
                  SizedBox(height: 20.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 15.w),
                      child: Text(
                        "${response.payload.length} comment${response.payload.length == 1 ? "" : "s"}",
                        style: context.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.w600),
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
                        itemCount: response.payload.length + 1,
                        itemBuilder: (_, index) {
                          if (index == response.payload.length) {
                            return SizedBox(height: 10.h);
                          }

                          CommentData data = response.payload[index];
                          bool isLiked() => true;
                          return Container(
                            width: 390.w,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 10.h),
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
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                    backgroundColor: neutral2,
                                    radius: 16.r,
                                    child: Icon(Icons.person_outline_rounded,
                                        color: Colors.black, size: 12.r),
                                  ),
                                  progressIndicatorBuilder:
                                      (context, url, download) => Center(
                                    child: CircularProgressIndicator(
                                        color: appRed,
                                        value: download.progress),
                                  ),
                                  imageBuilder: (context, provider) =>
                                      CircleAvatar(
                                    backgroundImage: provider,
                                    radius: 16.r,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data.postedBy.username,
                                        style: context.textTheme.bodyLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w600)),
                                    SizedBox(height: 10.h),
                                    SizedBox(
                                        width: 300.w,
                                        child: Text(data.content,
                                            style:
                                                context.textTheme.bodyMedium)),
                                    SizedBox(height: 10.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                              isLiked()
                                                  ? Boxicons.bxs_like
                                                  : Boxicons.bx_like,
                                              color:
                                                  isLiked() ? niceBlue : null,
                                              size: 18.r),
                                          onPressed: () {},
                                          splashRadius: 0.01,
                                        ),
                                        Text("Like",
                                            style: context.textTheme.bodySmall),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        IconButton(
                                          icon: Icon(Boxicons.bx_reply,
                                              size: 18.r),
                                          onPressed: () {},
                                          splashRadius: 0.01,
                                        ),
                                        Text("Reply",
                                            style: context.textTheme.bodySmall),
                                        SizedBox(width: 30.w),
                                        Text(
                                          time.format(data.created),
                                          style: context.textTheme.bodySmall!
                                              .copyWith(color: appRed),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
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
