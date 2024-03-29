import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/components/event_data.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/api/event_service.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/widgets.dart';

class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
  final TextEditingController searchController = TextEditingController();
  bool loadedForYou = false;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  void fetchEvents() {
    getEvents().then((result) {
      if (result.status == Status.failed) {
        showError(result.message);
      }
      if (!mounted) return;
      setState(() => loadedForYou = true);
      ref.watch(eventsProvider).clear();
      ref.watch(eventsProvider).addAll(result.payload);
    });
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
        title: Text("Events", style: context.textTheme.titleMedium),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => context.router.pushNamed(Pages.createEvents),
                child: Container(
                  height: 35.h,
                  width: 90.w,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(6.r),
                    border:
                        Border.all(color: darkTheme ? neutral3 : fadedPrimary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      Text("Create", style: context.textTheme.bodyLarge)
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
              SizedBox(height: 20.h),
              SpecialForm(
                width: 390.w,
                height: 40.h,
                controller: searchController,
                hint: "Search",
                fillColor: neutral2,
                borderColor: Colors.transparent,
                action: TextInputAction.go,
                onActionPressed: (value) {},
                prefix: Icon(Icons.search_rounded, size: 20.r, color: appRed),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: !loadedForYou
                    ? const CenteredPopup()
                    : events.isEmpty
                        ? Center(
                            child: Text("No Events Available",
                                style: context.textTheme.bodyLarge),
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
                                return EventContainer(data: events[index]);
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
