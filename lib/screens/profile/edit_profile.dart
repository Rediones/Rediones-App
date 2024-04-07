import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/api/profile_service.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/widgets.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

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
  final TextEditingController levelController = TextEditingController();

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
    "level": ""
  };
  final GlobalKey<FormState> formKey = GlobalKey();

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
    levelController.text = user.level;
    gender = user.gender.isEmpty ? null : user.gender;
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text("Edit Profile", style: context.textTheme.headlineSmall),
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
                        GestureDetector(
                          onTap: () {},
                          child: CachedNetworkImage(
                            imageUrl: user.profilePicture,
                            errorWidget: (context, url, error) => CircleAvatar(
                              backgroundColor: neutral2,
                              radius: 64.r,
                              child: Icon(Icons.person_outline_rounded,
                                  color: Colors.black, size: 48.r),
                            ),
                            progressIndicatorBuilder:
                                (context, url, download) => Center(
                              child: CircularProgressIndicator(
                                  color: appRed, value: download.progress),
                            ),
                            imageBuilder: (context, provider) => CircleAvatar(
                              backgroundImage: provider,
                              radius: 64.r,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0.h,
                          right: 10.w,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 25.r,
                              width: 25.r,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: appRed),
                              child: Icon(Icons.edit_rounded,
                                  size: 14.r, color: theme),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Text("First Name", style: context.textTheme.labelSmall),
                  SizedBox(height: 4.h),
                  SpecialForm(
                    controller: firstNameController,
                    hint: "e.g John",
                    width: 390.w,
                    height: 40.h,
                    onValidate: (value) {
                      if (value!.trim().isEmpty) {
                        showError("Please enter your first name");
                        return '';
                      }
                      return null;
                    },
                    onSave: (value) => details["firstName"] = value!,
                  ),
                  SizedBox(height: 20.h),
                  Text("Last Name", style: context.textTheme.labelSmall),
                  SizedBox(height: 4.h),
                  SpecialForm(
                    controller: lastNameController,
                    hint: "e.g Doe",
                    width: 390.w,
                    height: 40.h,
                    onValidate: (value) {
                      if (value!.trim().isEmpty) {
                        showError("Please enter your last name");
                        return '';
                      }
                      return null;
                    },
                    onSave: (value) => details["lastName"] = value!,
                  ),
                  SizedBox(height: 20.h),
                  Text("Other Name", style: context.textTheme.labelSmall),
                  SizedBox(height: 4.h),
                  SpecialForm(
                    controller: otherNameController,
                    hint: "e.g Smith",
                    width: 390.w,
                    height: 40.h,
                    onValidate: (value) {
                      if (value!.trim().isEmpty) {
                        showError("Please enter your other name");
                        return '';
                      }
                      return null;
                    },
                    onSave: (value) => details["otherName"] = value!,
                  ),
                  SizedBox(height: 20.h),
                  Text("Username", style: context.textTheme.labelSmall),
                  SizedBox(height: 4.h),
                  SpecialForm(
                    controller: usernameController,
                    hint: "e.g john_doe",
                    width: 390.w,
                    height: 40.h,
                    onValidate: (value) {
                      if (value!.trim().isEmpty) {
                        showError("Please enter your username");
                        return '';
                      }
                      return null;
                    },
                    onSave: (value) => details["username"] = value!,
                  ),
                  SizedBox(height: 20.h),
                  Text("Gender", style: context.textTheme.labelSmall),
                  SizedBox(height: 4.h),
                  ComboBox(
                    hint: "Select gender",
                    buttonWidth: 170.w,
                    dropdownItems: const ["Male", "Female", "Other"],
                    value: gender,
                    onChanged: (g) => setState(() => gender = g),
                  ),
                  SizedBox(height: 20.h),
                  Text("School", style: context.textTheme.labelSmall),
                  SizedBox(height: 4.h),
                  SpecialForm(
                    controller: schoolController,
                    hint: "e.g University of Ibadan",
                    width: 390.w,
                    height: 40.h,
                    onValidate: (value) {
                      if (value!.trim().isEmpty) {
                        showError("Please enter your school");
                        return '';
                      }
                      return null;
                    },
                    onSave: (value) => details["schoolAddress"] = value!,
                  ),
                  SizedBox(height: 20.h),
                  Text("Year", style: context.textTheme.labelSmall),
                  SizedBox(height: 4.h),
                  SpecialForm(
                    controller: levelController,
                    hint: "e.g 100",
                    width: 390.w,
                    height: 40.h,
                    onValidate: (value) {
                      if (value!.trim().isEmpty) {
                        showError("Please enter your level");
                        return '';
                      }
                      return null;
                    },
                    onSave: (value) => details["level"] = value!,
                  ),
                  SizedBox(height: 20.h),
                  Text("Address", style: context.textTheme.labelSmall),
                  SizedBox(height: 4.h),
                  SpecialForm(
                    controller: addressController,
                    hint: "e.g Lagos, Nigeria",
                    width: 390.w,
                    height: 40.h,
                    onValidate: (value) {
                      if (value!.trim().isEmpty) {
                        showError("Please enter your address");
                        return '';
                      }
                      return null;
                    },
                    onSave: (value) => details["address"] = value!,
                  ),
                  SizedBox(height: 20.h),
                  Text("Bio", style: context.textTheme.labelSmall),
                  SizedBox(height: 4.h),
                  SpecialForm(
                    controller: bioController,
                    hint: "Say a few words about yourself",
                    width: 390.w,
                    height: 120.h,
                    maxLines: 10,
                    onValidate: (value) {
                      if (value!.trim().isEmpty) {
                        showError("Please enter your bio");
                        return '';
                      }
                      return null;
                    },
                    onSave: (value) => details["bio"] = value!,
                  ),
                  SizedBox(height: 30.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.h),
                    child: SizedBox(
                      width: 390.w,
                      height: 40.h,
                      child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(appRed)),
                        onPressed: () {
                          unFocus();
                          FormState? currentState = formKey.currentState;
                          if (currentState != null) {
                            // if (!currentState.validate()) return;
                            currentState.save();
                            details["gender"] = gender ?? "";

                            void navigate(RedionesResponse<User?> result) {
                              ref
                                  .watch(userProvider.notifier)
                                  .state = result.payload!;
                              if (ref.watch(isNewUserProvider.notifier).state) {
                                ref.watch(isNewUserProvider.notifier).state = false;
                                context.pushReplacementNamed(Pages.home);
                              } else {
                                context.router.pop();
                              }
                            }

                            void snackBar(String message) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(message),
                                    duration: const Duration(seconds: 1),
                                    dismissDirection:
                                        DismissDirection.horizontal),
                              );
                            }

                            showDialog(
                              useSafeArea: true,
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                updateUser(user, details).then(
                                  (result) {
                                    Navigator.of(context).pop();
                                    snackBar(result.message);

                                    if (result.status == Status.success) {
                                      navigate(result);
                                    }
                                  },
                                );

                                return const Popup();
                              },
                            );
                          }
                        },
                        child: Text(
                          "Save",
                          style: context.textTheme.bodyLarge!.copyWith(
                              color: theme, fontWeight: FontWeight.w500),
                        ),
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
