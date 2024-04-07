import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rediones/components/group_data.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/api/file_handler.dart';
import 'package:rediones/api/group_service.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/widgets.dart';

class CreateGroupPage extends ConsumerStatefulWidget {
  const CreateGroupPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends ConsumerState<CreateGroupPage> {
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey();

  final Map<String, dynamic> details = {
    "cover": "",
    "title": "",
    "description": "",
  };

  Uint8List? cover;

  void navigate() {
    context.router.pop(true);
  }

  void create() {
    createGroup(details).then(
      (result) {
        if (!mounted) return;
        showToast(result.message);
        Navigator.of(context).pop();

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
        title: Text("Create Group", style: context.textTheme.titleMedium),
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
                  Wrap(
                    spacing: 5.w,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "Add Group Cover",
                        style: context.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "*",
                        style: context.textTheme.bodyLarge!
                            .copyWith(color: appRed),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  GestureDetector(
                    onTap: () {
                      Future<String?> response = FileHandler.pickFile("jpeg");
                      response.then(
                        (value) async {
                          if (value == null) return;
                          Uint8List data =
                              await FileHandler.convertSingleToData(value);
                          setState(() => cover = data);
                        },
                      );
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
                                  image: MemoryImage(cover!),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        child: cover == null
                            ? Icon(Icons.image_rounded,
                                size: 32.r, color: Colors.grey)
                            : null),
                  ),
                  SizedBox(height: 22.h),
                  Wrap(
                    spacing: 5.w,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "Group Name",
                        style: context.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
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
                    controller: title,
                    hint: "e.g My Group",
                    width: 358.w,
                    height: 40.h,
                    onValidate: (value) {
                      if (value!.trim().isEmpty) {
                        showError("Please enter the name of the group");
                        return '';
                      }
                      return null;
                    },
                    onSave: (value) => details["title"] = value!,
                  ),
                  SizedBox(height: 15.h),
                  Wrap(
                    spacing: 5.w,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "Group Description",
                        style: context.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
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
                    onValidate: (value) {
                      if (value!.trim().isEmpty) {
                        showError("Please enter a description for your group");
                        return '';
                      }
                      return null;
                    },
                    onSave: (value) => details["description"] = value!,
                  ),
                  SizedBox(height: 50.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.h),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(390.w, 40.h),
                        backgroundColor: appRed,
                      ),
                      onPressed: () {
                        if (cover == null) {
                          showError(
                              "Please choose a cover image for your group.");
                          return;
                        }
                        
                        details["cover"] = "$imgPrefix${FileHandler.convertTo64(cover!)}";

                        if (!validateForm(formKey)) return;
                        create();
                      },
                      child: Text(
                        "Create",
                        style:
                            context.textTheme.bodyLarge!.copyWith(color: theme),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
