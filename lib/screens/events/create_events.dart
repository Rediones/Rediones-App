import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rediones/api/event_service.dart';
import 'package:rediones/api/file_handler.dart';
import 'package:rediones/components/event_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/tools/widgets.dart';

class CreateEventsPage extends ConsumerStatefulWidget {
  const CreateEventsPage({super.key});

  @override
  ConsumerState<CreateEventsPage> createState() => _CreateEventsPageState();
}

class _CreateEventsPageState extends ConsumerState<CreateEventsPage> {
  final TextEditingController eventName = TextEditingController();
  final TextEditingController eventDescription = TextEditingController();
  final TextEditingController eventLocation = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey();

  String formattedDate = "", formattedTime = "";

  final List<String> chosenCategories = [];

  final Map<String, dynamic> details = {
    "cover": "",
    "title": "",
    "categories": [],
    "location": "",
    "startDate": "",
    "description": "",
  };

  Uint8List? eventCover;
  DateTime? pickedDate;
  TimeOfDay? pickedTime;

  void navigate() {
    context.router.pop(true);
  }

  void create() {
    createEvent(details).then(
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
    List<String> categories = ref.watch(eventCategories);

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
          "Create An Event",
          style: context.textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.h),
                  Wrap(
                    spacing: 5.w,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "Event Cover",
                        style: context.textTheme.titleSmall!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "*",
                        style: context.textTheme.titleSmall!
                            .copyWith(color: appRed),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  GestureDetector(
                    onTap: () {
                      Future<SingleFileResponse?> response =
                          FileHandler.single(type: FileType.image);
                      response.then(
                        (value) {
                          if (value == null) return;
                          setState(() => eventCover = value.data);
                        },
                      );
                    },
                    child: Container(
                      width: 390.w,
                      height: 150.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: eventCover == null ? Colors.transparent : null,
                        border: eventCover == null
                            ? Border.all(
                                color: darkTheme ? neutral3 : fadedPrimary)
                            : null,
                        borderRadius: BorderRadius.circular(15.r),
                        image: eventCover == null
                            ? null
                            : DecorationImage(
                                image: MemoryImage(eventCover!),
                                fit: BoxFit.cover,
                              ),
                      ),
                      child: eventCover == null
                          ? Icon(Icons.image_rounded,
                              size: 32.r, color: Colors.grey)
                          : null,
                    ),
                  ),
                  SizedBox(height: 22.h),
                  Wrap(
                    spacing: 5.w,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "Event Name",
                        style: context.textTheme.titleSmall!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "*",
                        style: context.textTheme.titleSmall!
                            .copyWith(color: appRed),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  SpecialForm(
                    controller: eventName,
                    width: 390.w,
                    height: 40.h,
                    hint: "e.g My Event",
                    fillColor: darkTheme ? neutral2 : authFieldBackground,
                    borderColor: Colors.transparent,
                    onValidate: (value) {
                      if (value!.trim().isEmpty) {
                        showToast(
                            "Please enter the name of the event", context);
                        return '';
                      }
                      return null;
                    },
                    onSave: (value) => details["title"] = value!,
                  ),
                  SizedBox(height: 22.h),
                  Wrap(
                    spacing: 5.w,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "Event Category",
                        style: context.textTheme.titleSmall!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "*",
                        style: context.textTheme.titleSmall!
                            .copyWith(color: appRed),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
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
                  SizedBox(height: 22.h),
                  Wrap(
                    spacing: 5.w,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "Event Location",
                        style: context.textTheme.titleSmall!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "*",
                        style: context.textTheme.titleSmall!
                            .copyWith(color: appRed),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  SpecialForm(
                    controller: eventLocation,
                    hint: "e.g Ikeja, Lagos, Nigeria",
                    width: 390.w,
                    height: 40.h,
                    fillColor: darkTheme ? neutral2 : authFieldBackground,
                    borderColor: Colors.transparent,
                    prefix: SizedBox(
                      height: 40.h,
                      width: 40.h,
                      child: SvgPicture.asset(
                        "assets/Profile Location.svg",
                        width: 20.h,
                        height: 20.h,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    onValidate: (value) {
                      if (value!.trim().isEmpty) {
                        showToast(
                            "Please enter the location of the event", context);
                        return '';
                      }
                      return null;
                    },
                    onSave: (value) => details["location"] = value!,
                  ),
                  SizedBox(height: 22.h),
                  Wrap(
                    spacing: 5.w,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "Date and Time",
                        style: context.textTheme.titleSmall!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "*",
                        style: context.textTheme.titleSmall!
                            .copyWith(color: appRed),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    height: 40.h,
                    width: 250.w,
                    padding: EdgeInsets.only(left: 10.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.h),
                      color: darkTheme ? neutral2 : authFieldBackground,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setState(
                                () => formattedDate = formatDate(
                                    DateFormat("dd/MM/yyyy")
                                        .format(pickedDate!),
                                    shorten: true),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month_rounded,
                                color: appRed,
                                size: 16.r,
                              ),
                              SizedBox(width: 10.w),
                              SizedBox(
                                width: 100.w,
                                child: Text(
                                  pickedDate == null
                                      ? "Jan 1, 2023"
                                      : formattedDate,
                                  style: context.textTheme.bodyLarge!.copyWith(
                                      fontWeight: pickedDate == null
                                          ? FontWeight.w200
                                          : FontWeight.normal),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: appRed,
                          width: 1.5.w,
                          height: 15.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then(
                              (val) {
                                pickedTime = val;
                                if (pickedTime != null) {
                                  String format = pickedTime!.format(context);
                                  setState(() => formattedTime = format);
                                }
                              },
                            );
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 60.w,
                                child: Text(
                                  pickedTime == null
                                      ? "12:00 AM"
                                      : formattedTime,
                                  style: context.textTheme.bodyLarge!.copyWith(
                                    fontWeight: pickedTime == null
                                        ? FontWeight.w200
                                        : FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Icon(
                                Icons.timelapse,
                                color: appRed,
                                size: 16.r,
                              ),
                              SizedBox(width: 10.w),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 22.h),
                  Wrap(
                    spacing: 5.w,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "Description",
                        style: context.textTheme.titleSmall!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "*",
                        style: context.textTheme.titleSmall!
                            .copyWith(color: appRed),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  SpecialForm(
                    controller: eventDescription,
                    hint: "e.g This is a sample description",
                    maxLines: 5,
                    height: 120.h,
                    width: 390.w,
                    fillColor: darkTheme ? neutral2 : authFieldBackground,
                    borderColor: Colors.transparent,
                    onValidate: (value) {
                      if (value!.trim().isEmpty) {
                        showToast("Please enter the description of the event",
                            context);
                        return '';
                      }
                      return null;
                    },
                    onSave: (value) => details["description"] = value!,
                  ),
                  SizedBox(height: 64.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(390.w, 40.h),
                      backgroundColor: appRed,
                    ),
                    onPressed: () {
                      unFocus();

                      if (eventCover == null) {
                        showToast("Please choose event cover image", context);
                        return;
                      }

                      FormState? currentState = formKey.currentState;
                      if (currentState != null) {
                        if (!currentState.validate()) return;
                        currentState.save();

                        details["categories"] = chosenCategories;
                        details["startDate"] = pickedDate!.toIso8601String();
                        details["cover"] =
                            "$imgPrefix${FileHandler.convertTo64(eventCover!)}";

                        create();
                      }
                    },
                    child: Text(
                      "Create",
                      style: context.textTheme.titleSmall!.copyWith(
                        color: theme,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Hold {
  final String name;
  final double value;

  const Hold({
    required this.name,
    required this.value,
  });
}

class AspectRatioPage extends StatefulWidget {
  final String imagePath;
  final String imageName;

  const AspectRatioPage({
    super.key,
    required this.imagePath,
    required this.imageName,
  });

  @override
  State<AspectRatioPage> createState() => _AspectRatioPageState();
}

class _AspectRatioPageState extends State<AspectRatioPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late CropController cropController;

  late Animation<double> animation;

  late List<Hold> aspectRatios;

  bool expand = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: animationController,
          curve: Curves.easeIn,
          reverseCurve: Curves.easeOut),
    );
    cropController = CropController(
      defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
      aspectRatio: 1.0,
    );

    aspectRatios = const [
      Hold(name: "1:1", value: 1.0),
      Hold(name: "4:3", value: 4.0 / 3.0),
      Hold(name: "16:9", value: 16.0 / 9.0),
    ];
  }

  @override
  void dispose() {
    animationController.dispose();
    cropController.dispose();
    super.dispose();
  }

  void pop(String path) => context.router.pop(path);

  void cropImage() async {
    ui.Image image = await cropController.croppedBitmap();
    Directory directory = await getTemporaryDirectory();

    ByteData? data = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List bytes = data!.buffer.asUint8List();

    String path = "${directory.path}/${widget.imageName}.png";

    File file = File(path);
    file.writeAsBytes(bytes, flush: true);

    pop(path);
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
        title: Text("Edit Image", style: context.textTheme.headlineSmall),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: IconButton(
              icon: const Icon(Icons.done_rounded),
              iconSize: 26.r,
              splashRadius: 20.r,
              onPressed: cropImage,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: CropImage(
          image: Image.file(File(widget.imagePath)),
          controller: cropController,
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 100.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizeTransition(
              sizeFactor: animation,
              child: Container(
                color: midPrimary,
                height: 40.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    aspectRatios.length,
                    (index) => GestureDetector(
                      onTap: () {
                        cropController.aspectRatio = aspectRatios[index].value;
                        cropController.crop =
                            const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                      },
                      child: Text(
                        aspectRatios[index].name,
                        style: context.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 55.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    splashRadius: 20.r,
                    iconSize: 20.r,
                    icon: Icon(Icons.aspect_ratio_rounded,
                        color: expand ? appRed : null),
                    onPressed: () {
                      setState(() => expand = !expand);
                      if (expand) {
                        animationController.forward();
                      } else {
                        animationController.reverse();
                      }
                    },
                  ),
                  IconButton(
                    splashRadius: 20.r,
                    iconSize: 20.r,
                    icon: const Icon(Icons.rotate_90_degrees_ccw_rounded),
                    onPressed: () => cropController.rotateLeft(),
                  ),
                  IconButton(
                    splashRadius: 20.r,
                    iconSize: 20.r,
                    icon: const Icon(Icons.rotate_90_degrees_cw_rounded),
                    onPressed: () => cropController.rotateRight(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
