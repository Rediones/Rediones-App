import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rediones/components/pocket_data.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/widgets.dart';

class CreateTaskPage extends ConsumerStatefulWidget {
  const CreateTaskPage({super.key});

  @override
  ConsumerState<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends ConsumerState<CreateTaskPage> {
  final TextEditingController title = TextEditingController();
  final TextEditingController details = TextEditingController();
  final TextEditingController date = TextEditingController();
  final TextEditingController time = TextEditingController();

  bool reminder = false;

  DateTime? pickedDate;
  TimeOfDay? pickedTime;

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
        title: Text(
          "Create New Task",
          style: context.textTheme.headlineSmall!
              .copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Wrap(
                  spacing: 5.w,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "Title",
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
                SizedBox(
                  height: 4.h,
                ),
                SpecialForm(
                  controller: title,
                  hint: "e.g Urgent Reminder",
                  width: 358.w,
                  height: 40.h,
                ),
                SizedBox(height: 15.h),
                Wrap(
                  spacing: 5.w,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text("Details",
                        style: context.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.w600)),
                    Text("*",
                        style: context.textTheme.bodyLarge!
                            .copyWith(color: appRed)),
                  ],
                ),
                SizedBox(
                  height: 4.h,
                ),
                SpecialForm(
                  controller: details,
                  hint: "e.g These are some details",
                  maxLines: 20,
                  height: 250.h,
                  width: 358.w,
                ),
                SizedBox(
                  height: 15.h,
                ),
                Wrap(
                  spacing: 5.w,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text("Date and Time",
                        style: context.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.w600)),
                    Text("*",
                        style: context.textTheme.bodyLarge!
                            .copyWith(color: appRed)),
                  ],
                ),
                SizedBox(
                  height: 4.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SpecialForm(
                      prefix: IconButton(
                          splashRadius: 0.01,
                          iconSize: 16.r,
                          icon: const Icon(Icons.calendar_month_rounded,
                              color: appRed),
                          onPressed: () async {
                            pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2100));
                            if (pickedDate != null) {
                              String format = formatDate(
                                  DateFormat("dd/MM/yyyy").format(pickedDate!),
                                  shorten: true);
                              setState(() => date.text = format);
                            } else {
                              setState(() => date.text = "");
                            }
                          }),
                      controller: date,
                      hint: "Jan 1, 2023",
                      width: 150.w,
                      height: 40.h,
                      readOnly: true,
                    ),
                    SpecialForm(
                      controller: time,
                      readOnly: true,
                      prefix: IconButton(
                          splashRadius: 0.01,
                          iconSize: 16.r,
                          icon: const Icon(Icons.access_time_rounded, color: appRed),
                          onPressed: () {
                            Future<TimeOfDay?> result = showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            result.then((val) {
                              pickedTime = val;
                              if (pickedTime != null) {
                                String format = pickedTime!.format(context);
                                setState(() => time.text = format);
                              } else {
                                setState(() => date.text = "");
                              }
                            });
                          }),
                      hint: "12:00 AM",
                      width: 150.w,
                      height: 40.h,
                    ),
                  ],
                ),
                SizedBox(height: 50.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.h),
                  child: SizedBox(
                    width: 390.w,
                    height: 40.h,
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(appRed)),
                      onPressed: () {
                        title.text.trim();
                        details.text.trim();

                        String? message;
                        if (title.text.isEmpty) {
                          message = "Please Enter Title";
                        } else if (details.text.isEmpty) {
                          message = "Please Enter Details";
                        } else if (pickedTime == null) {
                          message = "Please Choose Time";
                        } else if (pickedDate == null) {
                          message = "Please Choose Date";
                        }

                        if (message != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(message),
                              duration: const Duration(seconds: 1),
                              dismissDirection: DismissDirection.vertical));
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Task Created"),
                              duration: Duration(seconds: 1),
                              dismissDirection: DismissDirection.vertical),
                        );

                        ref.watch(pocketProvider).add(
                              PocketData(
                                content: details.text,
                                heading: title.text,
                                created: DateTime.now(),
                                dateDue: pickedDate!,
                                timeDue: pickedTime!,
                                id: "",
                              ),
                            );
                        context.router.pop();
                      },
                      child: Text(
                        "Create",
                        style: context.textTheme.bodyLarge!.copyWith(
                            color: theme, fontWeight: FontWeight.w500),
                      ),
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
