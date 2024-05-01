import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/components/post_data.dart';
import 'package:rediones/api/file_handler.dart';
import 'package:rediones/api/post_service.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/widgets.dart';

class AskQuestionPage extends ConsumerStatefulWidget {
  const AskQuestionPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AskQuestionPage> createState() => _AskQuestionPageState();
}

class _AskQuestionPageState extends ConsumerState<AskQuestionPage> {
  final TextEditingController controller = TextEditingController();

  late List<_ChoiceData> choices;

  @override
  void initState() {
    super.initState();
    choices = [_ChoiceData(), _ChoiceData()];
  }

  void navigate() => context.router.pop();

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
        centerTitle: true,
        title: Text("Ask A Question", style: context.textTheme.titleMedium),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Wrap(
                  spacing: 5.w,
                  children: [
                    Text(
                      "Question",
                      style: context.textTheme.bodyLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "*",
                      style:
                          context.textTheme.bodyLarge!.copyWith(color: appRed),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                SpecialForm(
                  controller: controller,
                  hint:
                      "e.g What is the answer to life and everything that exists?",
                  maxLines: 6,
                  height: 120.h,
                  width: 390.w,
                ),
                SizedBox(
                  height: 24.h,
                ),
                Wrap(
                  spacing: 5.w,
                  children: [
                    Text(
                      "Options",
                      style: context.textTheme.bodyLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "*",
                      style:
                          context.textTheme.bodyLarge!.copyWith(color: appRed),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Column(
                  children: List.generate(
                    choices.length,
                    (index) => _ChoiceContainer(
                      choice: choices[index],
                      onEdit: () {},
                    ),
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                Text(
                  "Poll Length",
                  style: context.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4.h),
                Chip(
                  label: Text(
                    "1 day",
                    style:
                        context.textTheme.bodyMedium!.copyWith(color: appRed),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.r),
                  ),
                  side: BorderSide(
                      color: context.isDark ? neutral3 : fadedPrimary),
                ),
                SizedBox(height: 50.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(390.w, 40.h),
                    backgroundColor: appRed,
                  ),
                  onPressed: () {
                    unFocus();

                    Future.delayed(
                      Duration.zero,
                      () => showDialog(
                        context: context,
                        builder: (context) {
                          return const Dialog(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              child: CenteredPopup());
                        },
                      ),
                    );
                  },
                  child: Text(
                    "Post",
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: theme,
                      fontWeight: FontWeight.w500,
                    ),
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

class _ChoiceData {
  late String value;

  _ChoiceData({this.value = ""});
}

class _ChoiceContainer extends StatefulWidget {
  final _ChoiceData choice;
  final VoidCallback onEdit;

  const _ChoiceContainer({
    super.key,
    required this.choice,
    required this.onEdit,
  });

  @override
  State<_ChoiceContainer> createState() => _ChoiceContainerState();
}

class _ChoiceContainerState extends State<_ChoiceContainer> {
  late TextEditingController controller;
  final FocusNode node = FocusNode();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.choice.value);
    controller.addListener(() {
      if (node.hasFocus) {
        widget.onEdit();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: Center(
        child: SpecialForm(
          controller: controller,
          focus: node,
          width: 390.w,
          height: 40.h,
          hint: "Choice",
        ),
      ),
    );
  }
}
