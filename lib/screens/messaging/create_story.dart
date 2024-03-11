import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/api/file_handler.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/widgets.dart';

class CreateStoryPage extends StatefulWidget {
  const CreateStoryPage({Key? key}) : super(key: key);

  @override
  State<CreateStoryPage> createState() => _CreateStoryPageState();
}

class _CreateStoryPageState extends State<CreateStoryPage> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scroll = ScrollController();

  final List<Uint8List> mediaBytes = [];

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

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
        title: Text("Create Story", style: context.textTheme.headlineSmall),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                GestureDetector(
                  onTap: () async {
                    List<Uint8List> images =
                        await FileHandler.loadFilesAsBytes(['jpeg']);
                    setState(() => mediaBytes.addAll(images));
                  },
                  child: Container(
                    height: 26.h,
                    width: 125.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: darkTheme ? neutral3 : fadedPrimary),
                      borderRadius: BorderRadius.circular(13.h),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.image, size: 18.r, color: appRed),
                        Text("Add Photo/Video",
                            style: context.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 26.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: darkTheme ? neutral3 : fadedPrimary),
                      borderRadius: BorderRadius.circular(13.h),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.location_on_rounded,
                            size: 18.r, color: appRed),
                        Text("Location", style: context.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                SpecialForm(
                  controller: controller,
                  hint: "This is a caption",
                  maxLines: 10,
                  height: 168.h,
                  width: 358.w,
                ),
                SizedBox(
                  height: 100.h,
                ),
                SizedBox(
                  height: 260.h,
                  child: Column(
                    children: [
                      ImageSlide(
                        mediaBytes: mediaBytes,
                        onDelete: (index) => setState(
                          () => mediaBytes.removeAt(index),
                        ),
                      ),
                      SizedBox(height: 50.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.h),
                        child: SizedBox(
                          width: 390.w,
                          height: 40.h,
                          child: TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(appRed)),
                            onPressed: () {},
                            child: Text("Post",
                                style: context.textTheme.bodyLarge!
                                    .copyWith(color: theme)),
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
