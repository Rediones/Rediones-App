import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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

  String? visibility;

  void navigate() => context.router.pop(true);

  void upload(Map<String, dynamic> postData) async {
    createPost(postData).then((response) {
      if (!mounted) return;

      Navigator.of(context).pop();
      if (response.payload == null) {
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
        title: Text("Create Post", style: context.textTheme.titleLarge),
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
                // ComboBox(hint: "", value: visibility, dropdownItems: const ["Public"], onChanged: (val) => setState(() => visibility = val)),
                // SizedBox(height: 4.h),
                SpecialForm(
                  controller: controller,
                  hint: "What would you like to share?",
                  maxLines: 6,
                  height: 120.h,
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
                        onDelete: (index) => setState(
                          () => mediaBytes.removeAt(index),
                        ),
                        onPictureTaken: (res) {
                          if(res == null) return;
                          mediaBytes.add(res as Uint8List);
                        },
                      ),
                      SizedBox(height: 20.h),
                      ListTile(
                        leading: SvgPicture.asset("assets/Add Gallery.svg",
                            color: appRed),
                        title: Text("Gallery",
                            style: context.textTheme.bodyLarge),
                        onTap: () async {
                          unFocus();
                          List<Uint8List> images =
                              await FileHandler.loadToBytes(
                                  type: FileType.image);
                          setState(() => mediaBytes.addAll(images));
                        },
                      ),
                      ListTile(
                        leading:
                            SvgPicture.asset("assets/Profile Location.svg"),
                        title: Text("Location",
                            style: context.textTheme.bodyLarge),
                        onTap: () {},
                      ),
                      SizedBox(height: 70.h),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(390.w, 40.h),
                          backgroundColor: appRed,
                        ),
                        onPressed: () async {
                          unFocus();

                          if (controller.text.trim().isEmpty) {
                            showError("Please enter a description");
                            return;
                          }

                          Map<String, dynamic> postData = {
                            "content": controller.text.trim(),
                            "category": -1,
                            "media": List.generate(mediaBytes.length, (index) {
                              String base64Media =
                                  FileHandler.convertTo64(mediaBytes[index]);
                              return {
                                "file": {"name": ""},
                                "base64": "$imgPrefix$base64Media"
                              };
                            })
                          };

                          if (widget.id != null) {
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
