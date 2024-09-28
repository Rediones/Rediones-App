import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:rediones/api/file_handler.dart';
import 'package:rediones/api/user_service.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/tools/widgets.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends ConsumerState<EditProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  late User user;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController otherNameController = TextEditingController();

  final TextEditingController addressController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController schoolController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  String? gender;

  final Map<String, String> details = {
    "firstName": "",
    "lastName": "",
    "otherName": "",
    "bio": "",
    "address": "",
    "schoolAddress": "",
    "username": "",
    "gender": "",
    "level": "100"
  };
  final GlobalKey<FormState> formKey = GlobalKey();

  Uint8List? pickedImage;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    user = ref.read(userProvider);
    firstNameController.text = user.firstName;
    lastNameController.text = user.lastName;
    otherNameController.text = user.otherName;
    addressController.text = user.address;
    bioController.text = user.description;
    usernameController.text = user.nickname;
    schoolController.text = user.school;
    gender = user.gender.isEmpty ? null : user.gender;
  }

  @override
  void dispose() {
    controller.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    otherNameController.dispose();
    addressController.dispose();
    bioController.dispose();
    usernameController.dispose();
    schoolController.dispose();
    super.dispose();
  }

  void navigate(RedionesResponse<User?> result) {
    saveToDatabase(result.payload!);
    ref.watch(userProvider.notifier).state = result.payload!;
    context.router.pop(true);
  }

  Future<void> saveToDatabase(User user) async {
    Isar isar = GetIt.I.get();
    await isar.writeTxn(() async {
      await isar.users.put(user);
    });
  }

  void edit() {
    updateUser(details).then(
      (result) {
        if (!mounted) return;
        if(result.status == Status.failed) {
          showToast(result.message, context);
        }

        Navigator.of(context).pop();

        if (result.status == Status.success) {
          navigate(result);
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => context.router.pop(),
          splashRadius: 0.01,
          iconSize: 26.r,
        ),
        elevation: 0.0,
        centerTitle: true,
        title: Text("Edit Profile", style: context.textTheme.titleLarge),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 17.w),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50.h),
                  Center(
                    child: Stack(
                      children: [
                        pickedImage == null
                            ? CachedNetworkImage(
                                imageUrl: user.profilePicture,
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
                                  backgroundColor: neutral2,
                                  radius: 64.r,
                                  child: Icon(
                                    Icons.person_outline_rounded,
                                    color: Colors.black,
                                    size: 48.r,
                                  ),
                                ),
                                progressIndicatorBuilder:
                                    (context, url, download) => CircleAvatar(
                                  backgroundColor: neutral2,
                                  radius: 64.r,
                                ),
                                imageBuilder: (context, provider) =>
                                    CircleAvatar(
                                  backgroundImage: provider,
                                  radius: 64.r,
                                ),
                              )
                            : CircleAvatar(
                                backgroundImage: MemoryImage(pickedImage!),
                                radius: 64.r,
                              ),
                        Positioned(
                          bottom: 0.h,
                          right: 10.w,
                          child: GestureDetector(
                            onTap: () {
                              FileHandler.single(type: FileType.image)
                                  .then((resp) {
                                if (resp == null) return;
                                setState(() => pickedImage = resp.data);
                              });
                            },
                            child: Container(
                              height: 25.r,
                              width: 25.r,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: appRed),
                              child: Icon(
                                Icons.edit_rounded,
                                size: 14.r,
                                color: theme,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Text("First Name", style: context.textTheme.labelLarge),
                  SizedBox(height: 4.h),
                  SpecialForm(
                    controller: firstNameController,
                    hint: "e.g John",
                    width: 390.w,
                    height: 40.h,
                    fillColor: darkTheme ? neutral2 : authFieldBackground,
                    borderColor: Colors.transparent,
                    onValidate: (value) {
                      if (value!.trim().isEmpty) {
                        showToast("Please enter your first name", context);
                        return '';
                      }
                      return null;
                    },
                    onSave: (value) => details["firstName"] = value!,
                  ),
                  SizedBox(height: 20.h),
                  Text("Last Name", style: context.textTheme.labelLarge),
                  SizedBox(height: 4.h),
                  SpecialForm(
                    controller: lastNameController,
                    hint: "e.g Doe",
                    width: 390.w,
                    height: 40.h,
                    fillColor: darkTheme ? neutral2 : authFieldBackground,
                    borderColor: Colors.transparent,
                    onValidate: (value) {
                      if (value!.trim().isEmpty) {
                        showToast("Please enter your last name", context);
                        return '';
                      }
                      return null;
                    },
                    onSave: (value) => details["lastName"] = value!,
                  ),
                  SizedBox(height: 20.h),
                  Text("Other Name", style: context.textTheme.labelLarge),
                  SizedBox(height: 4.h),
                  SpecialForm(
                    controller: otherNameController,
                    hint: "e.g Smith",
                    width: 390.w,
                    height: 40.h,
                    fillColor: darkTheme ? neutral2 : authFieldBackground,
                    borderColor: Colors.transparent,
                    onValidate: (value) {
                      if (value!.trim().isEmpty) {
                        showToast("Please enter your other name", context);
                        return '';
                      }
                      return null;
                    },
                    onSave: (value) => details["otherName"] = value!,
                  ),
                  SizedBox(height: 20.h),
                  Text("Username", style: context.textTheme.labelLarge),
                  SizedBox(height: 4.h),
                  SpecialForm(
                    controller: usernameController,
                    hint: "e.g john_doe",
                    width: 390.w,
                    height: 40.h,
                    fillColor: darkTheme ? neutral2 : authFieldBackground,
                    borderColor: Colors.transparent,
                    onValidate: (value) {
                      if (value!.trim().isEmpty) {
                        showToast("Please enter your username", context);
                        return '';
                      }
                      return null;
                    },
                    onSave: (value) => details["username"] = value!,
                  ),
                  SizedBox(height: 20.h),
                  Text("Gender", style: context.textTheme.labelLarge),
                  SizedBox(height: 4.h),
                  ComboBox(
                    hint: "Select gender",
                    buttonWidth: 390.w,
                    dropdownItems: const ["Male", "Female", "Other"],
                    value: gender,
                    onChanged: (g) => setState(() => gender = g),
                    buttonDecoration: BoxDecoration(
                      color: darkTheme ? neutral2 : authFieldBackground,
                      borderRadius: BorderRadius.circular(20.h),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text("School", style: context.textTheme.labelLarge),
                  SizedBox(height: 4.h),
                  SpecialForm(
                    controller: schoolController,
                    hint: "e.g University of Ibadan",
                    width: 390.w,
                    fillColor: darkTheme ? neutral2 : authFieldBackground,
                    borderColor: Colors.transparent,
                    height: 40.h,
                    onValidate: (value) {
                      if (value!.trim().isEmpty) {
                        showToast("Please enter your school", context);
                        return '';
                      }
                      return null;
                    },
                    onSave: (value) => details["schoolAddress"] = value!,
                  ),
                  SizedBox(height: 20.h),
                  Text("Address", style: context.textTheme.labelLarge),
                  SizedBox(height: 4.h),
                  SpecialForm(
                    controller: addressController,
                    hint: "e.g Lagos, Nigeria",
                    width: 390.w,
                    height: 40.h,
                    fillColor: darkTheme ? neutral2 : authFieldBackground,
                    borderColor: Colors.transparent,
                    onValidate: (value) {
                      if (value!.trim().isEmpty) {
                        showToast("Please enter your address", context);
                        return '';
                      }
                      return null;
                    },
                    onSave: (value) => details["address"] = value!,
                  ),
                  SizedBox(height: 20.h),
                  Text("Bio", style: context.textTheme.labelLarge),
                  SizedBox(height: 4.h),
                  SpecialForm(
                    controller: bioController,
                    hint: "Say a few words about yourself",
                    width: 390.w,
                    height: 150.h,
                    fillColor: darkTheme ? neutral2 : authFieldBackground,
                    borderColor: Colors.transparent,
                    maxLines: 10,
                    onValidate: (value) {
                      if (value!.trim().isEmpty) {
                        showToast("Please enter your bio", context);
                        return '';
                      }
                      return null;
                    },
                    onSave: (value) => details["bio"] = value!,
                  ),
                  SizedBox(height: 30.h),
                  ElevatedButton(
                    onPressed: () {
                      unFocus();
                      FormState? currentState = formKey.currentState;
                      if (currentState != null) {
                        // if (!currentState.validate()) return;
                        currentState.save();
                        details["gender"] = gender ?? "";

                        edit();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appRed,
                      fixedSize: Size(390.w, 40.h),
                      minimumSize: Size(390.w, 40.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.h),
                      )
                    ),
                    child: Text(
                      "Save",
                      style: context.textTheme.titleSmall!.copyWith(
                        color: theme,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
