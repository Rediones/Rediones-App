import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/components/project_data.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/api/file_handler.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/widgets.dart';

class CreateProjectPage extends ConsumerStatefulWidget {
  const CreateProjectPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends ConsumerState<CreateProjectPage> {
  final List<Holder> categories = [
    Holder("Science"),
    Holder("Technology"),
    Holder("Education"),
    Holder("Health and Wellness"),
    Holder("Environment and Sustainability"),
    Holder("Arts"),
    Holder("Community Service"),
    Holder("Social Justice"),
    Holder("Business and Entrepreneurship"),
    Holder("Sports and Recreation"),
  ];

  final List<Holder> skills = [
    Holder("Communication"),
    Holder("Adaptability"),
    Holder("Problem Solving"),
    Holder("Creativity"),
    Holder("Empathy"),
    Holder("Leadership"),
    Holder("Initiative"),
    Holder("Time Management"),
    Holder("Positive Attitude"),
    Holder("Active Learning"),
    Holder("Team Work"),
    Holder("Flexibility"),
  ];

  final List<Holder> ownerSkills = [
    Holder("Communication"),
    Holder("Adaptability"),
    Holder("Problem Solving"),
    Holder("Creativity"),
    Holder("Empathy"),
    Holder("Leadership"),
    Holder("Initiative"),
    Holder("Time Management"),
    Holder("Positive Attitude"),
    Holder("Active Learning"),
    Holder("Team Work"),
    Holder("Flexibility"),
  ];

  final TextEditingController projectName = TextEditingController();
  final TextEditingController projectDescription = TextEditingController();
  final TextEditingController projectDuration = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  late ProjectData project;

  Uint8List? projectCover;
  DateTime? pickedDate;
  TimeOfDay? pickedTime;
  String durationType = 'Days';

  int page = 1;

  @override
  void initState() {
    super.initState();
  }

  Widget _pageOne(BuildContext context, bool darkTheme) {
    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 15.h),
        Wrap(
          spacing: 5.w,
          children: [
            Text("Add Project Cover",
                style: context.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.w600)),
            Text("*",
                style: context.textTheme.bodyLarge!.copyWith(color: appRed)),
          ],
        ),
        SizedBox(height: 4.h),
        GestureDetector(
          onTap: () {
            Future<List<Uint8List>> response =
                FileHandler.loadFilesAsBytes(["jpeg"], many: false);
            response.then((value) => setState(() {
                  if (value.isNotEmpty) {
                    projectCover = value[0];
                  }
                }));
          },
          child: Container(
              width: 390.w,
              height: 150.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: projectCover == null ? Colors.transparent : null,
                  borderRadius: BorderRadius.circular(15.r),
                  border: projectCover == null
                      ? Border.all(color: darkTheme ? neutral3 : fadedPrimary)
                      : null,
                  image: projectCover == null
                      ? null
                      : DecorationImage(
                          image: MemoryImage(projectCover!),
                          fit: BoxFit.cover,
                        )),
              child: projectCover == null
                  ? Icon(Icons.image_rounded, size: 32.r, color: Colors.grey)
                  : null),
        ),
        SizedBox(height: 22.h),
        Wrap(
          spacing: 5.w,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text("Title Of Project",
                style: context.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.w600)),
            Text("*",
                style: context.textTheme.bodyLarge!.copyWith(color: appRed)),
          ],
        ),
        SizedBox(height: 4.h),
        SpecialForm(
          controller: projectName,
          hint: "e.g My Project",
          width: 390.w,
          height: 40.h,
          onValidate: (val) {
            if (val?.trim().isEmpty) {
              showError("Please enter project title");
              return '';
            }
            return null;
          },
        ),
        SizedBox(height: 22.h),
        Wrap(
          spacing: 5.w,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text("Category",
                style: context.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.w600)),
            Text("*",
                style: context.textTheme.bodyLarge!.copyWith(color: appRed)),
          ],
        ),
        SizedBox(height: 4.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: List.generate(
            categories.length,
            (index) => GestureDetector(
              onTap: () => setState(() => categories[index].selected = true),
              child: Chip(
                label: Text(categories[index].value,
                    style: context.textTheme.bodyMedium!.copyWith(
                        color: darkTheme ? Colors.white54 : Colors.black54)),
                elevation: categories[index].selected ? 1.0 : 0.0,
                backgroundColor: categories[index].selected
                    ? appRed
                    : (darkTheme ? Colors.white24 : Colors.black12),
                onDeleted: categories[index].selected
                    ? () => setState(() => categories[index].selected = false)
                    : null,
                deleteIcon: categories[index].selected
                    ? Icon(Boxicons.bx_x, size: 16.r)
                    : null,
              ),
            ),
          ),
        ),
        SizedBox(height: 22.h),
        Wrap(
          spacing: 5.w,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text("Skills Required",
                style: context.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.w600)),
            Text("*",
                style: context.textTheme.bodyLarge!.copyWith(color: appRed)),
          ],
        ),
        SizedBox(height: 4.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: List.generate(
            skills.length,
            (index) => GestureDetector(
              onTap: () => setState(() => skills[index].selected = true),
              child: Chip(
                label: Text(skills[index].value,
                    style: context.textTheme.bodyMedium!.copyWith(
                        color: darkTheme ? Colors.white54 : Colors.black54)),
                elevation: skills[index].selected ? 1.0 : 0.0,
                backgroundColor: skills[index].selected
                    ? appRed
                    : (darkTheme ? Colors.white24 : Colors.black12),
                onDeleted: skills[index].selected
                    ? () => setState(() => skills[index].selected = false)
                    : null,
                deleteIcon: skills[index].selected
                    ? Icon(Boxicons.bx_x, size: 14.r)
                    : null,
              ),
            ),
          ),
        ),
        SizedBox(height: 22.h),
        Wrap(
          spacing: 5.w,
          children: [
            Text("What Skills Do You Have?",
                style: context.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.w600)),
            Text("*",
                style: context.textTheme.bodyLarge!.copyWith(color: appRed)),
          ],
        ),
        SizedBox(height: 4.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: List.generate(
            ownerSkills.length,
            (index) => GestureDetector(
              onTap: () => setState(() => ownerSkills[index].selected = true),
              child: Chip(
                label: Text(ownerSkills[index].value,
                    style: context.textTheme.bodyMedium!.copyWith(
                        color: darkTheme ? Colors.white54 : Colors.black54)),
                elevation: ownerSkills[index].selected ? 1.0 : 0.0,
                backgroundColor: ownerSkills[index].selected
                    ? appRed
                    : (darkTheme ? Colors.white24 : Colors.black12),
                onDeleted: ownerSkills[index].selected
                    ? () => setState(() => ownerSkills[index].selected = false)
                    : null,
                deleteIcon: ownerSkills[index].selected
                    ? Icon(Boxicons.bx_x, size: 14.r)
                    : null,
              ),
            ),
          ),
        ),
        SizedBox(height: 22.h),
        Wrap(
          spacing: 5.w,
          children: [
            Text("Project Duration",
                style: context.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.w600)),
            Text("*",
                style: context.textTheme.bodyLarge!.copyWith(color: appRed)),
          ],
        ),
        SizedBox(height: 4.h),
        TextFieldCombo(
            controller: projectDuration,
            padding: EdgeInsets.only(left: 30.w),
            onChanged: (val) => setState(() => durationType = val),
            onValidate: (val) {
              if (val?.trim().isEmpty || int.tryParse(val) == null) {
                showError("Please enter valid project duration");
                return '';
              }
              return null;
            },
            hint: "",
            items: const ["Days", "Months", "Years"],
            width: 150.w,
            height: 40.h),
        SizedBox(height: 22.h),
        Wrap(
          spacing: 5.w,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text("Description",
                style: context.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.w600)),
            Text("*",
                style: context.textTheme.bodyLarge!.copyWith(color: appRed)),
          ],
        ),
        SizedBox(height: 4.h),
        SpecialForm(
          hint: "e.g This is a sample description",
          controller: projectDescription,
          maxLines: 5,
          height: 100.h,
          width: 390.w,
          onValidate: (val) {
            if (val?.trim().isEmpty) {
              showError("Please enter project description");
              return '';
            }
            return null;
          },
        ),
        SizedBox(height: 31.h),
        Align(
            alignment: Alignment.bottomCenter,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Wrap(
                spacing: 5.w,
                children: [
                  Icon(Icons.info_rounded,
                      color: darkTheme ? Colors.white54 : Colors.black54,
                      size: 14.r),
                  Text(
                      "Your Applicants will be added to a group that's moderated by you.",
                      style: context.textTheme.bodySmall!.copyWith(
                          color: darkTheme ? Colors.white54 : Colors.black54)),
                ],
              ),
              SizedBox(height: 15.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.h),
                child: SizedBox(
                  width: 390.w,
                  height: 40.h,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(appRed),
                    ),
                    onPressed: () {
                      if (projectCover == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please choose a cover image"),
                                duration: Duration(seconds: 1),
                                dismissDirection: DismissDirection.vertical));
                        return;
                      }

                      FormState? state = _formKey.currentState;
                      if (state == null || !state.validate()) return;
                      state.save();

                      project = ProjectData(
                        id: "123456",
                        user: ref.watch(userProvider.notifier).state,
                        cover: projectCover!,
                        description: projectDescription.text.trim(),
                        title: projectName.text.trim(),
                        duration: int.parse(projectDuration.text.trim()),
                        participants: const [],
                        moderators: const [],
                        durationType: durationType,
                      );

                      setState(() => ++page);
                    },
                    child: Text("Continue",
                        style: context.textTheme.bodyLarge!
                            .copyWith(color: theme)),
                  ),
                ),
              ),
            ]))
      ]),
    );
  }

  Widget _pageThree(BuildContext context, bool darkTheme) {
    return Column(children: [
      SizedBox(height: 23.h),
      ProjectContainer(data: project),
      SizedBox(height: 31.h),
      Align(
          alignment: Alignment.bottomCenter,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Wrap(
              spacing: 5.w,
              children: [
                Icon(Icons.info_rounded,
                    color: darkTheme ? Colors.white54 : Colors.black54,
                    size: 14.r),
                Text(
                    "Your Applicants will be added to a group that's moderated by you.",
                    style: context.textTheme.bodySmall!.copyWith(
                        color: darkTheme ? Colors.white54 : Colors.black54)),
              ],
            ),
            SizedBox(height: 15.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(20.h),
              child: SizedBox(
                width: 390.w,
                height: 40.h,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(appRed),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Project Created"),
                          duration: Duration(seconds: 1),
                          dismissDirection: DismissDirection.vertical),
                    );

                    ref.watch(projectsProvider).add(project);

                    context.router.pop();
                  },
                  child: Text(
                    "Post",
                    style: context.textTheme.bodyLarge!.copyWith(color: theme),
                  ),
                ),
              ),
            ),
          ])),
    ]);
  }

  Widget getPage(BuildContext context, bool darkTheme) => (page == 1)
      ? _pageOne(context, darkTheme)
      : _pageThree(context, darkTheme);

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
        title: Text("Create A Project", style: context.textTheme.headlineSmall),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 24.h),
            child: getPage(context, darkTheme),
          ),
        ),
      ),
    );
  }
}
