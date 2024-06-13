import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rediones/components/project_data.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/widgets.dart';

class ProjectPage extends ConsumerStatefulWidget {
  const ProjectPage({super.key});

  @override
  ConsumerState<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends ConsumerState<ProjectPage> {
  bool showProjects = true;

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;
    List<ProjectData> projects = ref.watch(projectsProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        centerTitle: true,
        title: Wrap(
          spacing: 15.w,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            GestureDetector(
              onTap: () => setState(() => showProjects = true),
              child: Text(
                "Projects",
                style: context.textTheme.headlineSmall!.copyWith(
                  color: darkTheme
                      ? (showProjects ? theme : Colors.white54)
                      : (showProjects ? primary : Colors.black45),
                ),
              ),
            ),
            Container(
              color: appRed,
              width: 1.5.w,
              height: 15.h,
            ),
            GestureDetector(
              onTap: () => setState(() => showProjects = false),
              child: Text(
                "Find A Project",
                style: context.textTheme.headlineSmall!.copyWith(
                  color: darkTheme
                      ? (!showProjects ? theme : Colors.white54)
                      : (!showProjects ? primary : Colors.black45),
                ),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 17.w),
          child: Column(
            children: [
              if (!showProjects && projects.isNotEmpty) SizedBox(height: 10.h),
              if (!showProjects && projects.isNotEmpty)
                Wrap(
                  spacing: 5.w,
                  children: [
                    Icon(Icons.info_rounded, color: appRed, size: 14.r),
                    Text(
                        "Users can't apply to another project without leaving their current project.",
                        style: context.textTheme.bodySmall!.copyWith(
                            color:
                                darkTheme ? Colors.white54 : Colors.black54)),
                  ],
                ),
              if (projects.isNotEmpty) SizedBox(height: 20.h),
              Expanded(
                child: projects.isEmpty
                    ? Center(
                        child: Text("No Projects Available",
                            style: context.textTheme.bodyLarge),
                )
                    : ListView.separated(
                        itemBuilder: (_, index) {
                          int length = projects.length + 1;
                          if (index == length) {
                            return SizedBox(
                                height: showProjects ? 100.h : 110.h);
                          } else {
                            return showProjects
                                ? _OngoingProjectContainer(
                                    data: projects[index])
                                : ProjectContainer(data: projects[index]);
                          }
                        },
                        separatorBuilder: (_, __) => SizedBox(height: 20.h),
                        itemCount: projects.length,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OngoingProjectContainer extends StatelessWidget {
  final ProjectData data;

  const _OngoingProjectContainer({required this.data});

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    int status = 0;
    bool isOver = false;

    return GestureDetector(
      // onTap: () =>
      //     Navigator.push(context, FadeRoute(ViewProjectPage(data: data))),
      child: Container(
        width: 390.w,
        height: 100.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: darkTheme ? neutral : fadedPrimary),
          color: Colors.transparent,
        ),
        child: Stack(children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.5.h),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.memory(data.cover!,
                          height: 80.h, width: 60.w, fit: BoxFit.cover)),
                  SizedBox(
                    width: 10.w,
                  ),
                  Container(
                    color: appRed,
                    width: 1.5.w,
                    height: 40.h,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  SizedBox(
                    height: 80.h,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(data.title,
                                  style: context.textTheme.bodyLarge!
                                      .copyWith(fontWeight: FontWeight.w700)),
                              SizedBox(
                                width: 20.w,
                              ),
                              Container(
                                  height: 8.r,
                                  width: 8.r,
                                  decoration: const BoxDecoration(
                                      // other color: neutral
                                      color: appRed,
                                      shape: BoxShape.circle))
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Wrap(children: [
                            Text(
                                "${data.participants.length} participant${data.participants.length == 1 ? "" : "s"}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: darkTheme
                                            ? Colors.white54
                                            : Colors.black54)),
                          ]),
                          SizedBox(
                            height: 20.h,
                          ),
                          Text(status == 0 ? "Ongoing" : "Completed",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color:
                                          status == 0 ? Colors.green : appRed)),
                        ]),
                  )
                ]),
          ),
          if (isOver)
            Container(
              width: 390.w,
              height: 100.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: darkTheme ? Colors.white10 : Colors.black12,
              ),
            )
        ]),
      ),
    );
  }
}
