import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rediones/components/post_data.dart';
import 'package:rediones/api/file_handler.dart';
import 'package:rediones/api/post_service.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/widgets.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  final String? id;
  const CreatePostPage({super.key, this.id});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final TextEditingController controller = TextEditingController();
  final List<Uint8List> mediaBytes = [];

  PostCategory? postCategory;
  String? title;
  List<dynamic>? icon;


  void navigate() => context.router.pop(true);


  void upload(Map<String, dynamic> postData) async {
    createPost(postData).then((response) {
      if(!mounted) return;

      Navigator.of(context).pop();
      if(response.payload == null) {
        showError(response.message);
      } else {
        ref.watch(postsProvider).add(response.payload!);
        navigate();
      }

    });

    showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (context) => const Popup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<PostCategory, Map<String, List<dynamic>>> postCategories = ref.watch(postCategoryProvider);


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 26.r,
          splashRadius: 0.01,
          icon: const Icon(Icons.chevron_left),
          onPressed: () => context.router.pop(),
        ),
        elevation: 0.0,
        centerTitle: true,
        title: Text("Create Post", style: context.textTheme.titleMedium),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Wrap(
                  spacing: 5.w,
                  children: [
                    Text(
                      "Description",
                      style: context.textTheme.bodyLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "*",
                      style:
                      context.textTheme.bodyLarge!.copyWith(color: appRed),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                SpecialForm(
                  controller: controller,
                  hint: "e.g This is a sample description",
                  maxLines: 10,
                  height: 168.h,
                  width: 390.w,
                ),
                SizedBox(
                  height: 100.h,
                ),
                SizedBox(
                  height: 380.h,
                  child: Column(
                    children: [
                      ImageSlide(
                        mediaBytes: mediaBytes,
                        onDelete: (index) =>
                            setState(
                                  () => mediaBytes.removeAt(index),
                            ),
                      ),
                      SizedBox(height: 20.h),
                      ListTile(
                        leading: SvgPicture.asset("assets/Add Gallery.svg", color: appRed),
                        title: Text("Gallery",
                            style: context.textTheme.bodyMedium),
                        onTap: () async {
                          unFocus();
                          List<Uint8List> images = await FileHandler
                              .loadToBytes(type: FileType.image);
                          setState(() => mediaBytes.addAll(images));
                        },
                      ),
                      ListTile(
                        leading: SvgPicture.asset("assets/Profile Location.svg"),
                        title: Text("Location",
                            style: context.textTheme.bodyMedium),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(
                            postCategory == null
                                ? Boxicons.bx_category
                                : icon![0],
                            size: 18.r,
                            color: postCategory == null ? appRed : icon![1]),
                        title: Text(postCategory == null ? "Category" : title!,
                            style: context.textTheme.bodyMedium),
                        onTap: () {
                          unFocus();
                          Navigator.push(
                            context,
                            FadeRoute(
                              const _ChooseCategoryPage(),
                            ),
                          ).then(
                                (resp) =>
                                setState(() {
                                  postCategory = resp;
                                  title =
                                      postCategories[postCategory]?.keys.first;
                                  icon = postCategories[postCategory]?[title]!;
                                }),
                          );
                        },
                      ),
                      SizedBox(height: 10.h),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(390.w, 40.h),
                          backgroundColor: appRed,
                        ),
                        onPressed: () async {
                          unFocus();

                          if (controller.text
                              .trim()
                              .isEmpty) {
                            showError("Please enter a description");
                            return;
                          } else if (postCategory == null) {
                            showError("Please select a category");
                            return;
                          }

                          Map<String, dynamic> postData = {
                            "content": controller.text.trim(),
                            "category": Post.fromCategory(postCategory!),
                            "media":
                            List.generate(mediaBytes.length, (index) {
                              String base64Media =
                              FileHandler.convertTo64(mediaBytes[index]);
                              return {
                                "file": {"name": ""},
                                "base64": "$imgPrefix$base64Media"
                              };
                            })
                          };

                          if(widget.id != null) {
                            postData["group"] = widget.id;
                          }

                          upload(postData);
                        },
                        child: Text(
                          "Post",
                          style: context.textTheme.bodyLarge!.copyWith(
                            color: theme,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChooseCategoryPage extends ConsumerStatefulWidget {
  const _ChooseCategoryPage({Key? key}) : super(key: key);

  @override
  ConsumerState<_ChooseCategoryPage> createState() => _ChooseCategoryPageState();
}

class _ChooseCategoryPageState extends ConsumerState<_ChooseCategoryPage> {
  late List<PostCategory> postKeys;

  @override
  void initState() {
    super.initState();
    Map<PostCategory, Map<String, List<dynamic>>> postCategories = ref.read(postCategoryProvider);
    postKeys = postCategories.keys.toList();
    postKeys.removeAt(0);
  }

  @override
  Widget build(BuildContext context) {
    Map<PostCategory, Map<String, List<dynamic>>> postCategories = ref.watch(postCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left, size: 26.r),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Post Category",
          style: context.textTheme.headlineSmall,
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (context, index) {
            String title = postCategories[postKeys[index]]!.keys.first;
            List<dynamic> icon = postCategories[postKeys[index]]![title]!;
            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
              leading: Icon(icon[0], color: icon[1], size: 18.r),
              title: Text(title, style: context.textTheme.bodyMedium),
              onTap: () => Navigator.pop(context, postKeys[index]),
            );
          },
          itemCount: postKeys.length,
        ),
      ),
    );
  }
}
