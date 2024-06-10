import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/components/project_data.dart';
import 'package:rediones/tools/constants.dart';

class ViewProjectPage extends StatefulWidget {
  final ProjectData data;

  const ViewProjectPage({super.key, required this.data});

  @override
  State<ViewProjectPage> createState() => _ViewProjectPageState();
}

class _ViewProjectPageState extends State<ViewProjectPage> {
  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: 390.w,
              height: 160.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: MemoryImage(widget.data.cover!), fit: BoxFit.cover),
              ),
              child: Stack(children: [
                Positioned(
                  top: 20.h,
                  left: 20.w,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 32.r,
                      width: 32.r,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white24,
                      ),
                      child: Icon(Icons.chevron_left_rounded,
                          size: 26.r, color: theme),
                    ),
                  ),
                )
              ]),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 17.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25.h,
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Text("Project's Description",
                      style: context.textTheme.headlineSmall),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    widget.data.description,
                    style: context.textTheme.bodyMedium,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Text("Goals",
                      style: context.textTheme.headlineSmall),
                  SizedBox(
                    height: 15.h,
                  ),
                  const Text(""),
                  SizedBox(
                    height: 15.h,
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Text("Skills",
                      style: context.textTheme.headlineSmall),
                  SizedBox(
                    height: 15.h,
                  ),
                  const Text(""),
                  SizedBox(
                    height: 15.h,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(


                        child: Container(
                          height: 40.h,
                          width: 170.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                                color: darkTheme ? neutral3 : fadedPrimary),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text("Participants",
                              style: context.textTheme.bodyLarge),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6.r),
                        child: SizedBox(
                          width: 170.w,
                          height: 40.h,
                          child: TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(appRed)),
                            onPressed: () {},
                            child: Text("Library",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: theme)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
