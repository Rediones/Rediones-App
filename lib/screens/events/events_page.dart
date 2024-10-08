import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rediones/api/event_service.dart';
import 'package:rediones/components/event_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/tools/widgets.dart';

class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({
    super.key,
  });

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
  final TextEditingController searchController = TextEditingController();
  bool loadedForYou = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, fetchEvents);
  }

  void fetchEvents() {
    getEvents(ref.watch(userProvider.select((u) => u.uuid))).then((result) {
      if (result.status == Status.failed) {
        showToast(result.message, context);
      }
      if (!mounted) return;
      setState(() => loadedForYou = true);
      ref.watch(eventsProvider).clear();
      ref.watch(eventsProvider).addAll(result.payload);
    });
  }

  void refreshEvents() {
    setState(() => loadedForYou = false);
    fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;
    List<EventData> events = ref.watch(eventsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 26.r,
          splashRadius: 0.01,
          icon: const Icon(Icons.chevron_left),
          onPressed: () => context.router.pop(),
        ),
        elevation: 0.0,
        leadingWidth: 30.w,
        title: Text(
          "Events",
          style: context.textTheme.titleLarge,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  context.router.pushNamed(Pages.createEvents).then((resp) {
                    if (resp == null) return;
                    refreshEvents();
                  });
                },
                child: Container(
                  height: 35.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(17.5.h),
                    border:
                        Border.all(color: darkTheme ? neutral3 : fadedPrimary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 18.r,
                        height: 18.r,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: appRed),
                        child: Center(
                            child: Icon(Icons.add_rounded,
                                color: theme, size: 14.r)),
                      ),
                      Text(
                        "Create",
                        style: context.textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              SpecialForm(
                width: 390.w,
                height: 40.h,
                controller: searchController,
                hint: "Search",
                fillColor: neutral2,
                borderColor: Colors.transparent,
                action: TextInputAction.go,
                onActionPressed: (value) {},
                prefix: SizedBox(
                  height: 40.h,
                  width: 40.h,
                  child: SvgPicture.asset(
                    "assets/Search Icon.svg",
                    width: 20.h,
                    height: 20.h,
                    color: darkTheme ? Colors.white54 : Colors.black45,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: !loadedForYou
                    ? const CenteredPopup()
                    : events.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/No Data.png",
                                  width: 150.r,
                                  height: 150.r,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 20.h),
                                Text(
                                  "There are no events available",
                                  style: context.textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                GestureDetector(
                                  onTap: refreshEvents,
                                  child: Text(
                                    "Refresh",
                                    style:
                                        context.textTheme.titleSmall!.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: appRed,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              setState(() => loadedForYou = false);
                              fetchEvents();
                            },
                            child: ListView.separated(
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: 30.h),
                              itemCount: events.length + 1,
                              itemBuilder: (context, index) {
                                if (index == events.length) {
                                  return SizedBox(height: 30.h);
                                }
                                return EventContainer(
                                  data: events[index],
                                  key: ValueKey<String>(events[index].id),
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
