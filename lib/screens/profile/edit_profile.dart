import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/api/profile_service.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
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
    ref.watch(userProvider.notifier).state = result.payload!;
    if (ref.watch(isNewUserProvider.notifier).state) {
      ref.watch(isNewUserProvider.notifier).state = false;
      context.pushReplacementNamed(Pages.home);
    } else {
      context.router.pop();
    }
  }

  void edit() {
    updateUser(details).then(
      (result) {
        if (!mounted) return;

        if (result.status == Status.success) {
          navigate(result);
        } else {
          showToast(result.message, context);
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
                  Text("First Name", style: context.textTheme.labelLarge),
                  SizedBox(height: 4.h),
                  SpecialForm(
                    controller: firstNameController,
                    hint: "e.g John",
                    width: 390.w,
                    height: 40.h,
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
                    buttonWidth: 170.w,
                    dropdownItems: const ["Male", "Female", "Other"],
                    value: gender,
                    onChanged: (g) => setState(() => gender = g),
                  ),
                  SizedBox(height: 20.h),
                  Text("School", style: context.textTheme.labelLarge),
                  SizedBox(height: 4.h),
                  SpecialForm(
                    controller: schoolController,
                    hint: "e.g University of Ibadan",
                    width: 390.w,
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
                    height: 120.h,
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.h),
                    child: SizedBox(
                      width: 390.w,
                      height: 40.h,
                      child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(appRed)),
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
