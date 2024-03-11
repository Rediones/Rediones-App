import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:rediones/api/message_service.dart';
import 'package:rediones/components/pocket_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/widgets.dart';

class PocketPage extends ConsumerStatefulWidget {
  const PocketPage({super.key});

  @override
  ConsumerState<PocketPage> createState() => _PocketPageState();
}

class _PocketPageState extends ConsumerState<PocketPage> {
  static final List<Color> _colors = [
    appRed,
    niceBlue,
    goodYellow,
    possibleGreen,
    midPrimary,
  ];

  bool loadingNotes = false, loadingMessages = false;

  final List<StickyData> stickyNotes = [];
  final List<PocketMessageData> messages = [];

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadingNotes = loadingMessages = true;
    getMessages();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void getMessages() {
    getPocket().then((resp) {
      if (!mounted) return;

      if (resp.status == Status.failed) {
        showError(resp.message);
        return;
      }

      messages.clear();
      messages.addAll(resp.payload!.pocketMessages);

      stickyNotes.clear();
      stickyNotes.addAll(resp.payload!.stickyNotes);

      setState(() => loadingMessages = false);
    });
  }

  void createMessage(String text) {
    setState(() => controller.clear());
    createPocketMessageData(text).then((_) => getMessages());
  }

  void createStickyNote(String id) {
    makeSticky(id).then((resp) {
      if (!mounted) return;

      if (resp.status == Status.failed) {
        showError(resp.message);
        return;
      }

      setState(() {
        stickyNotes.add(resp.payload!);
        loadingMessages = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;

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
          "Pocket",
          style: context.textTheme.titleMedium,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: SizedBox(
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
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Text(
                "Sticky Notes",
                style: context.textTheme.titleLarge,
              ),
              SizedBox(height: 10.h),
              SizedBox(
                height: 100.h,
                child: stickyNotes.isEmpty
                    ? Center(
                        child: Text(
                          "No sticky notes created",
                          style: context.textTheme.bodyMedium,
                        ),
                      )
                    : ListView.separated(
                        itemBuilder: (_, index) => _StickyNoteContainer(
                          data: stickyNotes[index],
                          color: _colors[
                              stickyNotes[index].id.hashCode % _colors.length],
                        ),
                        separatorBuilder: (_, __) => SizedBox(width: 20.w),
                        itemCount: stickyNotes.length,
                        scrollDirection: Axis.horizontal,
                      ),
              ),
              SizedBox(height: 10.h),
              if (stickyNotes.length > 3)
                Center(
                  child: SizedBox(
                    width: 40.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => CircleAvatar(
                          backgroundColor: index == 0 ? appRed : null,
                          radius: index == 0 ? 6.r : 4.r,
                          child: CircleAvatar(
                            radius: 4.r,
                            backgroundColor: index == 0 ? Colors.white : Colors.white30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 10.h),
              const Divider(color: neutral2),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() => loadingMessages = true);
                    getMessages();
                  },
                  child: ListView.separated(
                    itemBuilder: (_, index) {
                      if (index == messages.length) {
                        return SizedBox(height: 50.h);
                      }

                      return _MessageDataContainer(
                        data: messages[index],
                        onCreateNote: () =>
                            createStickyNote(messages[index].id),
                      );
                    },
                    separatorBuilder: (_, __) => SizedBox(height: 4.h),
                    itemCount: messages.length + 1,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 500),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpecialForm(
              controller: controller,
              width: 300.w,
              height: 40.h,
              hint: "Type your message here",
            ),
            IconButton(
              onPressed: () {
                String text = controller.text.trim();
                if (text.isEmpty) return;

                createMessage(text);
              },
              icon: const Icon(Icons.send_rounded, color: appRed),
              iconSize: 26.r,
            )
          ],
        ),
      ),
    );
  }
}

class _StickyNoteContainer extends StatelessWidget {
  final StickyData data;
  final Color color;

  const _StickyNoteContainer({
    super.key,
    required this.data,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            "Date Created: ${formatDate(DateFormat("dd/MM/yyyy").format(data.created), shorten: true)}",
            style: context.textTheme.bodySmall),
        SizedBox(height: 2.h),
        Container(
          width: 220.w,
          height: 80.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                  color: darkTheme ? neutral3 : fadedPrimary, width: 1),
              color: color.withOpacity(0.05),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, spreadRadius: 1.5, blurRadius: 0.5)
              ]),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              height: 80.h,
              width: 5.w,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  bottomLeft: Radius.circular(8.r),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200.w,
                    child: Text(data.heading,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.titleLarge!
                            .copyWith(fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(height: 5.h),
                  SizedBox(
                    width: 200.w,
                    child: Text(data.content,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.w400)),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                      "Date Due: ${formatDate(DateFormat("dd/MM/yyyy").format(data.dateDue), shorten: true)}",
                      style: context.textTheme.bodyMedium),
                ],
              ),
            )
          ]),
        ),
      ],
    );
  }
}

class PocketContainer extends StatelessWidget {
  final PocketData data;
  final Color color;
  final VoidCallback onDelete;

  const PocketContainer({
    super.key,
    required this.data,
    required this.color,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            "Date Created: ${formatDate(DateFormat("dd/MM/yyyy").format(data.created), shorten: true)}",
            style: context.textTheme.bodySmall),
        SizedBox(height: 2.h),
        GestureDetector(
          onLongPress: () => showDialog(
              context: context,
              builder: (context) => Center(
                    child: SizedBox(
                      width: 270.w,
                      height: 180.h,
                      child: Card(
                          elevation: 2.0,
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Column(children: [
                                SizedBox(height: 20.h),
                                Text("Delete Confirmation",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.w700)),
                                SizedBox(height: 30.h),
                                Text(
                                    "Do you want to really delete this pocket?",
                                    style: context.textTheme.bodyLarge),
                                SizedBox(height: 30.h),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                          onTap: () => Navigator.pop(context),
                                          child: Text("Cancel",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600))),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                            onDelete();
                                          },
                                          child: Text("Confirm",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: appRed))),
                                    ])
                              ]))),
                    ),
                  )),
          child: Container(
            width: 390.w,
            height: 70.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                    color: darkTheme ? neutral3 : fadedPrimary, width: 1),
                color: Colors.transparent),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                height: 70.h,
                width: 5.w,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.r),
                      bottomLeft: Radius.circular(8.r)),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 340.w,
                      child: Text(data.heading,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.w700)),
                    ),
                    SizedBox(height: 5.h),
                    SizedBox(
                      width: 340.w,
                      child: Text(data.content,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodySmall),
                    ),
                    SizedBox(height: 5.h),
                    // Text(
                    //     "Date Due: ${formatDate(DateFormat("dd/MM/yyyy").format(data.dateDue), shorten: true)} by ${data.timeDue.format(context)}",
                    //     style: context.textTheme.bodySmall),
                  ],
                ),
              )
            ]),
          ),
        ),
      ],
    );
  }
}

class _MessageDataContainer extends StatefulWidget {
  final PocketMessageData data;
  final VoidCallback onCreateNote;

  const _MessageDataContainer({
    super.key,
    required this.data,
    required this.onCreateNote,
  });

  @override
  State<_MessageDataContainer> createState() => _MessageDataContainerState();
}

class _MessageDataContainerState extends State<_MessageDataContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  bool expanded = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.fastEaseInToSlowEaseOut,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void toggle() {
    setState(() => expanded = !expanded);
    if (expanded) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizeTransition(
            sizeFactor: animation,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10.h),
                    CircleAvatar(
                      backgroundColor: appRed,
                      radius: 20.r,
                      child: const Icon(Icons.task, color: theme),
                    ),
                    Text(
                      "Tasks",
                      style: context.textTheme.bodySmall,
                    ),
                    SizedBox(height: 5.h),
                    GestureDetector(
                      onTap: () {
                        toggle();
                        widget.onCreateNote();
                      },
                      child: CircleAvatar(
                        backgroundColor: appRed,
                        radius: 20.r,
                        child: const Icon(Icons.note, color: theme),
                      ),
                    ),
                    Text(
                      "Notes",
                      style: context.textTheme.bodySmall,
                    ),
                    SizedBox(height: 5.h),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              border: Border.all(color: appRed),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Text(
              widget.data.text!,
              style: context.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
