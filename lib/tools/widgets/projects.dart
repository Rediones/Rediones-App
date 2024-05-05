import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/components/project_data.dart';
import 'package:rediones/screens/other/media_view.dart';
import 'package:rediones/tools/constants.dart';

import 'common.dart' show SpecialForm;


class ProjectContainer extends StatelessWidget {
  final ProjectData data;

  const ProjectContainer({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;
    return Container(
      width: 364.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: darkTheme ? neutral : fadedPrimary),
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: SizedBox(
              height: 48.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        foregroundColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage(data.user!.profilePicture),
                        radius: 18.r,
                      ),
                      SizedBox(
                        width: 11.w,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.user!.username,
                              style: context.textTheme.labelMedium!
                                  .copyWith(fontWeight: FontWeight.w700)),
                          Text("@${data.user!.nickname}",
                              style: context.textTheme.labelSmall)
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () => context.router.pushNamed(
              Pages.viewMedia,
              extra: PreviewData(
                bytes: [data.cover!],
                displayType: DisplayType.memory,
              ),
            ),
            child: Image.memory(data.cover!,
                fit: BoxFit.cover, height: 116.h, width: 364.w),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Wrap(
                spacing: 10.w,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.start,
                children: [
                  Container(
                    width: 90.w,
                    height: 20.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: darkTheme ? Colors.white54 : Colors.black38,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.h),
                        topLeft: Radius.circular(10.h),
                        bottomLeft: Radius.circular(10.h),
                      ),
                    ),
                    child: Text(
                      "Project Title:",
                      style:
                      context.textTheme.bodyLarge!.copyWith(color: theme),
                    ),
                  ),
                  Text(
                    data.title,
                    style: context.textTheme.headlineLarge!
                        .copyWith(color: Colors.grey),
                  )
                ],
              ),
              SizedBox(height: 20.h),
              Wrap(
                  spacing: 10.w,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      width: 90.w,
                      height: 20.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: darkTheme ? Colors.white54 : Colors.black38,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.h),
                          topLeft: Radius.circular(10.h),
                          bottomLeft: Radius.circular(10.h),
                        ),
                      ),
                      child: Text("Description:",
                          style: context.textTheme.bodyLarge!
                              .copyWith(color: theme)),
                    ),
                    Text(data.description, style: context.textTheme.bodyLarge)
                  ]),
              SizedBox(height: 20.h),
              Wrap(
                  spacing: 10.w,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    Container(
                      width: 120.w,
                      height: 20.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: darkTheme ? Colors.white54 : Colors.black38,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.h),
                              topLeft: Radius.circular(10.h),
                              bottomLeft: Radius.circular(10.h))),
                      child: Text("Skills Required:",
                          style: context.textTheme.bodyLarge!
                              .copyWith(color: theme)),
                    ),
                    Text(data.title, style: context.textTheme.bodyLarge)
                  ]),
              SizedBox(height: 20.h),
              Wrap(
                  spacing: 10.w,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      width: 120.w,
                      height: 20.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: darkTheme ? Colors.white54 : Colors.black38,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.h),
                              topLeft: Radius.circular(10.h),
                              bottomLeft: Radius.circular(10.h))),
                      child: Text("Project Duration:",
                          style: context.textTheme.bodyLarge!
                              .copyWith(color: theme)),
                    ),
                    Text("${data.duration} ${data.durationType}",
                        style: context.textTheme.bodyLarge)
                  ]),
              SizedBox(height: 20.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.h),
                child: SizedBox(
                  width: 390.w,
                  height: 40.h,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          darkTheme ? Colors.white54 : Colors.black38),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Apply",
                      style:
                      context.textTheme.bodyLarge!.copyWith(color: theme),
                    ),
                  ),
                ),
              ),
            ]),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}


class TextFieldCombo extends StatefulWidget {
  final TextEditingController controller;
  final Function onChanged;
  final EdgeInsets padding;
  final List<String> items;
  final String hint;
  final double width;
  final Function? onValidate;
  final double height;

  const TextFieldCombo({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.hint,
    required this.padding,
    required this.items,
    this.onValidate,
    required this.width,
    required this.height,
  });

  @override
  State<TextFieldCombo> createState() => _TextFieldComboState();
}

class _TextFieldComboState extends State<TextFieldCombo> {
  String? selection;

  @override
  void initState() {
    super.initState();
    selection = widget.items[0];
  }

  @override
  Widget build(BuildContext context) {
    return SpecialForm(
      width: widget.width,
      height: widget.height,
      controller: widget.controller,
      onValidate: widget.onValidate,
      padding: widget.padding,
      hint: widget.hint,
      type: TextInputType.number,
      suffix: SizedBox(
        width: widget.width * 0.55,
        height: widget.height,
        child: DropdownButtonFormField<String>(
          value: selection,
          style: context.textTheme.bodyMedium,
          decoration: InputDecoration(
            fillColor: Colors.transparent,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
          ),
          items: widget.items
              .map(
                (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ),
          )
              .toList(),
          onChanged: (item) {
            selection = item;
            widget.onChanged(item);
          },
        ),
      ),
    );
  }
}
