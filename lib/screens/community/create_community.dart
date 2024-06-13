import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/api/file_handler.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/widgets.dart';

class CreateCommunityPage extends ConsumerStatefulWidget {
  const CreateCommunityPage({
    super.key,
  });

  @override
  ConsumerState<CreateCommunityPage> createState() =>
      _CreateCommunityPageState();
}

class _CreateCommunityPageState extends ConsumerState<CreateCommunityPage> {
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();

  final List<String> chosenCategories = [];

  String? cover;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;
    List<String> categories = ref.watch(communityCategoriesProvider);

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
        title: Text(
          "Create Your Community",
          style: context.textTheme.titleMedium,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Text(
                  "Cover",
                  style: context.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4.h),
                GestureDetector(
                  onTap: () {
                    Future<String?> response = FileHandler.pickFile("jpeg");
                    response.then((value) => setState(() => cover = value));
                  },
                  child: Container(
                      width: 390.w,
                      height: 150.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: cover == null ? Colors.transparent : null,
                        border: cover == null
                            ? Border.all(
                                color: darkTheme ? neutral3 : fadedPrimary)
                            : null,
                        borderRadius: BorderRadius.circular(15.r),
                        image: cover == null
                            ? null
                            : DecorationImage(
                                image: FileImage(
                                  File(cover!),
                                ),
                                fit: BoxFit.cover,
                              ),
                      ),
                      child: cover == null
                          ? Icon(Icons.image_rounded,
                              size: 32.r, color: Colors.grey)
                          : null),
                ),
                SizedBox(height: 22.h),
                Text(
                  "Community Name",
                  style: context.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 4.h,
                ),
                SpecialForm(
                  controller: title,
                  hint: "e.g My Community",
                  width: 358.w,
                  height: 40.h,
                ),
                SizedBox(height: 15.h),
                Wrap(
                  spacing: 5.w,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text("Category",
                        style: context.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.w600)),
                    Text(
                      "*",
                      style:
                          context.textTheme.bodyLarge!.copyWith(color: appRed),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4.h,
                ),
                if(chosenCategories.isNotEmpty)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.r),
                      border: Border.all(
                          color: darkTheme ? neutral3 : fadedPrimary),
                  ),
                  child: Wrap(
                    spacing: 5.w,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 0,
                    children: List.generate(
                      chosenCategories.length,
                      (index) => Chip(
                        label: Text(
                          chosenCategories[index],
                          style: context.textTheme.bodySmall,
                        ),
                        elevation: 1.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        backgroundColor: neutral3,
                        side: const BorderSide(
                          color: Colors.transparent,
                        ),
                        deleteIcon: Icon(Boxicons.bx_x, color: theme, size: 18.r,),
                        onDeleted: () => setState(() => chosenCategories.removeAt(index)),
                      ),
                    ),
                  ),
                ),
                if(chosenCategories.isNotEmpty)
                SizedBox(
                  height: 4.h,
                ),
                Wrap(
                  spacing: 5.w,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 0,
                  children: List.generate(
                    categories.length,
                    (index) => GestureDetector(
                      onTap: () => setState(() {
                        if (!chosenCategories.contains(categories[index])) {
                          chosenCategories.add(categories[index]);
                        }
                      }),
                      child: Chip(
                        label: Text(
                          categories[index],
                          style: context.textTheme.bodySmall,
                        ),
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        backgroundColor:
                            chosenCategories.contains(categories[index])
                                ? neutral3
                                : null,
                        side: BorderSide(
                          color: chosenCategories.contains(categories[index])
                              ? Colors.transparent
                              : (darkTheme ? neutral3 : fadedPrimary),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Wrap(
                  spacing: 5.w,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text("Description",
                        style: context.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.w600)),
                    Text(
                      "*",
                      style:
                          context.textTheme.bodyLarge!.copyWith(color: appRed),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4.h,
                ),
                SpecialForm(
                  controller: description,
                  hint: "e.g This is a description",
                  maxLines: 10,
                  height: 150.h,
                  width: 358.w,
                ),
                SizedBox(height: 50.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_rounded,
                      color: darkTheme ? Colors.white54 : Colors.black54,
                      size: 14.r,
                    ),
                    SizedBox(
                      width: 330.w,
                      child: Text(
                          "Your members will be added to a community group that's moderated by you.",
                          style: context.textTheme.bodySmall!.copyWith(
                              color:
                                  darkTheme ? Colors.white54 : Colors.black54)),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.h),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(390.w, 40.h),
                      backgroundColor: appRed,
                    ),
                    onPressed: () {
                      String? message;
                      if (title.text.trim().isEmpty) {
                        message = "Please Enter Group Name";
                      } else if (description.text.trim().isEmpty) {
                        message = "Please Enter Group Description";
                      } else if (cover == null) {
                        message = "Please Choose Group Cover Image";
                      }

                      if (message != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(message),
                              duration: const Duration(seconds: 1),
                              dismissDirection: DismissDirection.vertical),
                        );
                        return;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Group Created"),
                            duration: Duration(seconds: 1),
                            dismissDirection: DismissDirection.vertical),
                      );


                      context.router.pop();
                    },
                    child: Text(
                      "Continue",
                      style:
                          context.textTheme.bodyLarge!.copyWith(color: theme),
                    ),
                  ),
                ),
                SizedBox(height: 50.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
