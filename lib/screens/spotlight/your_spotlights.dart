import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rediones/api/spotlight_service.dart';
import 'package:rediones/components/spotlight_data.dart';
import 'package:rediones/screens/spotlight/view_spotlight.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/tools/widgets/common.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class YourSpotlightsPage extends ConsumerStatefulWidget {
  final String id;
  const YourSpotlightsPage({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<YourSpotlightsPage> createState() => _YourSpotlightsPageState();
}

class _YourSpotlightsPageState extends ConsumerState<YourSpotlightsPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final List<SpotlightData> savedSpotlights = [], mySpotlights = [];

  bool loadingSaved = true, loadingMine = true;

  late bool isViewingOtherUserSpotlights;

  @override
  void initState() {
    super.initState();
    isViewingOtherUserSpotlights = ref.read(userProvider.select((u) => u.uuid)) != widget.id;
    tabController = TabController(length: isViewingOtherUserSpotlights ? 1 : 2, vsync: this);
    Future.delayed(Duration.zero, () {
      getMySpotlights();
      if(!isViewingOtherUserSpotlights) {
        getSavedSpotlights();
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void showMessage(String msg) => showToast(msg, context);

  Future<void> getMySpotlights() async {
    String id = isViewingOtherUserSpotlights ? widget.id : ref.watch(userProvider.select((u) => u.uuid));
    var response = await getUserSpotlights(id);

    if (response.status == Status.failed) {
      showMessage(response.message);
      setState(() => loadingMine = false);
      return;
    }

    loadingMine = false;
    mySpotlights.clear();
    mySpotlights.addAll(response.payload);
    setState(() {});
  }

  Future<void> getSavedSpotlights() async {
    var response = await getCurrentSavedSpotlights();

    if (response.status == Status.failed) {
      showMessage(response.message);
      setState(() => loadingSaved = false);
      return;
    }

    loadingSaved = false;
    savedSpotlights.clear();
    savedSpotlights.addAll(response.payload);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          splashRadius: 0.01,
          iconSize: 26.r,
          icon: const Icon(Icons.chevron_left),
          onPressed: () => context.router.pop(),
        ),
        leadingWidth: 30.w,
        title: Text(
          "Spotlights",
          style: context.textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              if(!isViewingOtherUserSpotlights)
              TabBar(
                controller: tabController,
                indicatorColor: appRed,
                dividerColor: context.isDark ? Colors.white12 : Colors.black12,
                labelColor: appRed,
                labelPadding: EdgeInsets.symmetric(horizontal: 5.w),
                labelStyle: context.textTheme.titleSmall!
                    .copyWith(fontWeight: FontWeight.w600),
                unselectedLabelStyle: context.textTheme.titleSmall!
                    .copyWith(fontWeight: FontWeight.w500),
                tabs: const [
                  Tab(text: "My Spotlights"),
                  Tab(text: "Saved Spotlights"),
                ],
              ),
              SizedBox(height: 10.h),

              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    loadingMine
                        ? const Center(
                            child: loader,
                          )
                        : mySpotlights.isEmpty
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
                                      "There are no spotlights available",
                                      style: context.textTheme.titleSmall!
                                          .copyWith(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() => loadingMine = true);
                                        getMySpotlights();
                                      },
                                      child: Text(
                                        "Refresh",
                                        style: context.textTheme.titleSmall!
                                            .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: appRed,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 10.h,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                ),
                                itemCount: mySpotlights.length,
                                itemBuilder: (context, index) =>
                                    _SpotlightContainer(
                                  header: "some plays",
                                  data: mySpotlights[index],
                                  onClick: () => context.router.pushNamed(
                                    Pages.viewSpotlight,
                                    extra: ViewSpotlightOptions(
                                      data: mySpotlights[index],
                                    ),
                                  ),
                                ),
                              ),

                    if(!isViewingOtherUserSpotlights)
                    loadingSaved
                        ? const Center(
                            child: loader,
                          )
                        : savedSpotlights.isEmpty
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
                                      "There are no saved spotlights available",
                                      style: context.textTheme.titleSmall!
                                          .copyWith(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() => loadingSaved = true);
                                        getSavedSpotlights();
                                      },
                                      child: Text(
                                        "Refresh",
                                        style: context.textTheme.titleSmall!
                                            .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: appRed,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 10.h,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.h,
                                ),
                                itemCount: savedSpotlights.length,
                                itemBuilder: (context, index) =>
                                    _SpotlightContainer(
                                  header: "play",
                                  data: savedSpotlights[index],
                                  onClick: () => context.router.pushNamed(
                                    Pages.viewSpotlight,
                                    extra: ViewSpotlightOptions(
                                      data: savedSpotlights[index],
                                      showUserData: true,
                                    ),
                                  ),
                                ),
                              )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpotlightContainer extends StatefulWidget {
  final String header;
  final SpotlightData data;
  final VoidCallback onClick;

  const _SpotlightContainer({
    super.key,
    required this.header,
    required this.data,
    required this.onClick,
  });

  @override
  State<_SpotlightContainer> createState() => _SpotlightContainerState();
}

class _SpotlightContainerState extends State<_SpotlightContainer> {
  String? filePath;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: widget.data.url,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxWidth: 180.w.toInt(),
      maxHeight: 220.h.toInt(),
      quality: 75,
    );
    setState(() => filePath = fileName);
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;

    return GestureDetector(
      onTap: widget.onClick,
      child: Container(
        width: 180.w,
        height: 220.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: filePath == null
              ? Border.all(
                  color: darkTheme ? neutral3 : fadedPrimary,
                )
              : null,
          image: filePath == null
              ? null
              : DecorationImage(
                  image: FileImage(
                    File(filePath!),
                  ),
                  fit: BoxFit.cover,
                ),
        ),
        alignment: Alignment.center,
        child: filePath == null ? loader : null,
      ),
    );
  }
}
