import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/api/post_service.dart';
import 'package:rediones/components/postable.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/tools/widgets.dart';

class AskQuestionPage extends ConsumerStatefulWidget {
  const AskQuestionPage({super.key});

  @override
  ConsumerState<AskQuestionPage> createState() => _AskQuestionPageState();
}

class _AskQuestionPageState extends ConsumerState<AskQuestionPage> {
  final TextEditingController controller = TextEditingController();

  late List<_ChoiceData> choices;
  late Map<String, int> pollLengths;
  late List<String> pollKeys;

  final GlobalKey<FormState> formKey = GlobalKey();

  int pollChoice = -1;

  final Map<String, dynamic> postData = {
    "type": "POLL",
    "title": "",
    "options": [],
    "duration": 0,
  };

  @override
  void initState() {
    super.initState();
    choices = [_ChoiceData(), _ChoiceData()];
    pollLengths = {
      "1 hour": 1,
      "2 hours": 2,
      "3 hours": 3,
      "4 hours": 4,
      "6 hours": 6,
      "12 hours": 12,
      "18 hours": 18,
      "24 hours": 24,
    };

    pollKeys = pollLengths.keys.toList();
  }

  void navigate() => context.router.pop(true);

  void upload() async {
    createPost(postData).then((response) {
      if (!mounted) return;

      Navigator.of(context).pop();
      if (response.payload == null) {
        showToast(response.message, context);
      } else {
        // List<PostObject> posts = ref.read(postsProvider);
        // ref.watch(postsProvider.notifier).state = [
        //   response.payload!,
        //   ...posts,
        // ];
        showToast("Poll created", context);
        navigate();
      }
    });

    showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (context) => const Popup(),
    );
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
        centerTitle: true,
        title: Text(
          "Ask A Question",
          style: context.textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SpecialForm(
                        controller: controller,
                        maxLines: 5,
                        height: 100.h,
                        width: 390.w,
                        hint: "What would you like to ask?",
                        fillColor: context.isDark ? neutral2 : authFieldBackground,
                        borderColor: Colors.transparent,
                        onValidate: (value) {
                          if (value!.isEmpty) {
                            showToast(
                                "Provide a title for your poll", context);
                            return '';
                          }
                          return null;
                        },
                        onSave: (value) => postData["title"] = value!,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        "Options",
                        style: context.textTheme.titleSmall!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
                SizedBox(
                  height: choices.length * 50.h,
                  child: ListView.separated(
                    itemBuilder: (_, index) => _ChoiceContainer(
                      choice: choices[index],
                      onRemove: () => setState(() => choices.removeAt(index)),
                      listener: () {
                        if (index == choices.length - 1 && choices.length < 5) {
                          setState(() => choices.add(_ChoiceData()));
                        }
                      },
                      onSave: (val) {
                        _ChoiceData data = choices[index];
                        data.value = val!;
                      },
                    ),
                    itemCount: choices.length,
                    separatorBuilder: (_, __) => SizedBox(
                      height: 10.h,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Poll length",
                  style: context.textTheme.titleSmall!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4.h),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10.r,
                  children: List.generate(
                    pollKeys.length,
                    (index) => GestureDetector(
                      onTap: () => setState(() {
                        pollChoice = index;
                        postData["duration"] = pollLengths[pollKeys[index]];
                      }),
                      child: Chip(
                        label: Text(
                          pollKeys[index],
                          style: context.textTheme.bodyLarge!.copyWith(
                            color: pollChoice == index ? Colors.white : appRed,
                          ),
                        ),
                        elevation: 0.0,
                        shadowColor: Colors.transparent,
                        backgroundColor: pollChoice == index ? appRed : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.r),
                        ),
                        side: BorderSide(
                          color: pollChoice != index
                              ? neutral2
                              : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 100.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(390.w, 40.h),
                    backgroundColor: appRed,
                  ),
                  onPressed: () {
                    if (!validateForm(formKey)) return;

                    if (choices.length < 2) {
                      showToast("Provide at least 2 poll options", context);
                      return;
                    }

                    List<String> answers = [];
                    for (var ch in choices) {
                      if (ch.value.isNotEmpty) {
                        answers.add(ch.value);
                      }
                    }

                    postData["options"] = answers;

                    upload();
                  },
                  child: Text(
                    "Post",
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
    );
  }
}

class _ChoiceData {
  String value;

  _ChoiceData({this.value = ""});
}

class _ChoiceContainer extends StatefulWidget {
  final _ChoiceData choice;
  final VoidCallback onRemove;
  final VoidCallback listener;
  final Function onSave;

  const _ChoiceContainer({
    required this.choice,
    required this.onRemove,
    required this.listener,
    required this.onSave,
  });

  @override
  State<_ChoiceContainer> createState() => _ChoiceContainerState();
}

class _ChoiceContainerState extends State<_ChoiceContainer> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.choice.value);
    controller.addListener(widget.listener);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;
    return SpecialForm(
      controller: controller,
      width: 390.w,
      height: 40.h,
      hint: "Choice",
      fillColor: darkTheme ? neutral2 : authFieldBackground,
      borderColor: Colors.transparent,
      onChange: (val) => widget.choice.value = val,
      onValidate: (value) {
        if (value!.isEmpty) {
          showToast("Input a choice", context);
          return '';
        }
        return null;
      },
      onSave: widget.onSave,
      suffix: GestureDetector(
        onTap: widget.onRemove,
        child: Icon(
          Boxicons.bx_x,
          color: appRed,
          size: 20.r,
        ),
      ),
    );
  }
}
