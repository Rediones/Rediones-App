import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/api/file_handler.dart';
import 'package:rediones/api/profile_service.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/widgets/common.dart';

class CreateProfilePage extends ConsumerStatefulWidget {
  const CreateProfilePage({super.key});

  @override
  ConsumerState<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends ConsumerState<CreateProfilePage> {
  final TextEditingController username = TextEditingController();
  final TextEditingController university = TextEditingController();

  String? profilePicture;

  final GlobalKey<FormState> formKey = GlobalKey();

  final Map<String, dynamic> authDetails = {
    "username": "",
    "schoolAddress": "",
  };

  int page = 1;

  void navigate(RedionesResponse<User?> result) {
    ref.watch(userProvider.notifier).state = result.payload!;
    ref.watch(isNewUserProvider.notifier).state = false;
    ref.watch(createdProfileProvider.notifier).state = true;
    context.router.pushReplacementNamed(Pages.home);
  }

  void createProfile() {
    updateUser(authDetails).then(
      (result) {
        if (!mounted) return;

        if (result.status == Status.success) {
          navigate(result);
        } else {
          showNewError(result.message, context);
          Navigator.of(context).pop();
        }
      },
    );

    showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      context: context,
      builder: (_) => const Popup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;

    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 63.h,
              ),
              Text("Create Your Profile ($page of 2)",
                  style: context.textTheme.titleMedium),
              Text(
                page == 1
                    ? "You're almost done."
                    : "Choose a profile picture (optional)",
                style: context.textTheme.bodyLarge,
              ),
              SizedBox(height: 63.h),
              if (page == 1)
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SpecialForm(
                        width: 390.w,
                        height: 40.h,
                        controller: username,
                        fillColor: darkTheme ? neutral2 : authFieldBackground,
                        borderColor: Colors.transparent,
                        type: TextInputType.emailAddress,
                        prefix: Icon(
                          Icons.person,
                          size: 18.r,
                          color: darkTheme ? offWhite : primaryPoint2,
                        ),
                        onValidate: (value) {
                          if (value!.isEmpty) {
                            showNewError("Invalid Username", context);
                            return '';
                          }
                          return null;
                        },
                        onSave: (value) => authDetails["username"] = value!,
                        hint: "Username",
                      ),
                      SizedBox(height: 20.h),
                      SpecialForm(
                        width: 390.w,
                        height: 40.h,
                        controller: university,
                        fillColor: darkTheme ? neutral2 : authFieldBackground,
                        borderColor: Colors.transparent,
                        type: TextInputType.emailAddress,
                        prefix: Icon(
                          Icons.school,
                          size: 18.r,
                          color: darkTheme ? offWhite : primaryPoint2,
                        ),
                        onValidate: (value) {
                          if (value!.isEmpty) {
                            showNewError("No school provided", context);
                            return '';
                          }
                          return null;
                        },
                        onSave: (value) =>
                            authDetails["schoolAddress"] = value!,
                        hint: "School",
                      ),
                    ],
                  ),
                ),
              if (page == 2)
                GestureDetector(
                  onTap: () =>
                      FileHandler.single(type: FileType.image).then((resp) {
                    if (resp == null) return;
                    setState(() => profilePicture = resp.path);
                  }),
                  child: Container(
                    width: 150.r,
                    height: 150.r,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: profilePicture == null ? neutral2 : null,
                        image: profilePicture != null
                            ? DecorationImage(
                                image: FileImage(
                                  File(profilePicture!),
                                ),
                              )
                            : null),
                    child: profilePicture == null
                        ? Icon(
                            Icons.image,
                            size: 36.r,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
              SizedBox(height: 150.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(390.w, 40.h),
                  backgroundColor: appRed,
                  elevation: 1.0,
                ),
                onPressed: () async {
                  if (page == 1) {
                    if (!validateForm(formKey)) return;

                    setState(() => page = 2);
                  } else {
                    if (profilePicture != null) {
                      var data = await FileHandler.convertSingleToData(
                          profilePicture!);
                      String base64Media = FileHandler.convertTo64(data);
                      authDetails["profilePicture"] = {
                        "file": {"name": ""},
                        "base64": "$imgPrefix$base64Media"
                      };
                    }

                    createProfile();
                  }
                },
                child: Text(
                  page == 1 ? "Continue" : "Finish",
                  style: context.textTheme.bodyLarge!.copyWith(
                    color: theme,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
