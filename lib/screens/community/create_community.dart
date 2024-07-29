import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/api/file_handler.dart';
import 'package:rediones/api/group_service.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/providers.dart';
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

  String? cover, coverData;

  final Map<String, dynamic> details = {
    "cover": "",
    "title": "",
    "categories": [],
    "description": "",
  };

  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  void dispose() {
    title.dispose();
    description.dispose();
    super.dispose();
  }

  void navigate() {
    // ref.watch(eventsProvider).add(result.payload!);
    context.router.pop();
  }

  void create() {
    createCommunity(details).then(
      (result) {
        if (!mounted) return;
        Navigator.of(context).pop();
        showToast(result.message, context);
        if (result.status == Status.success) {
          navigate();
        }
      },
    );

    showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      context: context,
      builder: (context) => const Popup(),
    );
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
          child: Form(
            key: formKey,
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
                    onTap: () async {
                      String? value = await FileHandler.pickFile("jpeg");
                      if (value != null) {
                        String base64Value =
                            await FileHandler.convertFilePathToBase64(value);
                        setState(() {
                          coverData = base64Value;
                          cover = value;
                        });
                      }
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
                    onValidate: (value) {
                      if (value!.isEmpty) {
                        showToast("Invalid Community Name", context);
                        return '';
                      }
                      return null;
                    },
                    onSave: (value) => details["title"] = value!,
                    fillColor: darkTheme ? neutral2 : authFieldBackground,
                    borderColor: Colors.transparent,
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
                        style: context.textTheme.bodyLarge!
                            .copyWith(color: appRed),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  if (chosenCategories.isNotEmpty)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.r),
                        border: Border.all(
                          color: darkTheme ? neutral3 : fadedPrimary,
                        ),
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
                              style: context.textTheme.bodyLarge,
                            ),
                            elevation: 1.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                            backgroundColor: neutral3,
                            side: const BorderSide(
                              color: Colors.transparent,
                            ),
                            deleteIcon: Icon(
                              Boxicons.bx_x,
                              color: theme,
                              size: 18.r,
                            ),
                            onDeleted: () => setState(
                                () => chosenCategories.removeAt(index)),
                          ),
                        ),
                      ),
                    ),
                  if (chosenCategories.isNotEmpty)
                    SizedBox(
                      height: 4.h,
                    ),
                  Wrap(
                    spacing: 5.w,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 0,
                    children: List.generate(
                      categories.length,
                      (index) {
                        String category = categories[index];
                        bool contained = chosenCategories.contains(category);

                        return GestureDetector(
                          onTap: () {
                            if (contained) return;
                            setState(() => chosenCategories.add(category));
                          },
                          child: Chip(
                            label: Text(
                              categories[index],
                              style: context.textTheme.bodyLarge,
                            ),
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                            backgroundColor: contained ? neutral3 : null,
                            side: BorderSide(
                              color: contained
                                  ? Colors.transparent
                                  : (darkTheme ? neutral3 : fadedPrimary),
                            ),
                          ),
                        );
                      },
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
                        style: context.textTheme.bodyLarge!
                            .copyWith(color: appRed),
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
                    fillColor: darkTheme ? neutral2 : authFieldBackground,
                    borderColor: Colors.transparent,
                    onValidate: (value) {
                      if (value!.isEmpty) {
                        showToast("Invalid Community Description", context);
                        return '';
                      }
                      return null;
                    },
                    onSave: (value) => details["description"] = value!,
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
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: darkTheme ? Colors.white54 : Colors.black54,
                          ),
                          textAlign: TextAlign.start,
                        ),
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
                        if (!validateForm(formKey)) return;

                        if (cover == null) {
                          showToast("Choose a cover image", context);
                          return;
                        }

                        if (chosenCategories.isEmpty) {
                          showToast("Select at least one category", context);
                          return;
                        }

                        details["categories"] = chosenCategories;
                        details["cover"] = "$imgPrefix$coverData";

                        create();
                      },
                      child: Text(
                        "Continue",
                        style: context.textTheme.titleSmall!.copyWith(
                          color: theme,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
