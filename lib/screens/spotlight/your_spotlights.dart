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
  int activeTabBeingViewed = 0;

  @override
  void initState() {
    super.initState();
    isViewingOtherUserSpotlights =
        ref.read(userProvider.select((u) => u.uuid)) != widget.id;
    tabController = TabController(
        length: isViewingOtherUserSpotlights ? 1 : 2, vsync: this);
    Future.delayed(Duration.zero, () {
      getMySpotlights();
      if (!isViewingOtherUserSpotlights) {
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
    String id = isViewingOtherUserSpotlights
        ? widget.id
        : ref.watch(userProvider.select((u) => u.uuid));
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
    bool loading = activeTabBeingViewed == 0 ? loadingMine : loadingSaved;
    List<SpotlightData> spotlights =
        activeTabBeingViewed == 0 ? mySpotlights : savedSpotlights;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        children: [
          SizedBox(height: 10.h),
          if (!isViewingOtherUserSpotlights)
            Container(
              width: 390.w,
              height: 45.h,
              padding: EdgeInsets.symmetric(
                vertical: 3.r,
                horizontal: 6.r,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.h),
                color: const Color.fromRGBO(178, 187, 198, 0.4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                  2,
                  (index) => GestureDetector(
                    onTap: () => setState(() => activeTabBeingViewed = index),
                    child: Container(
                      width: 150.w,
                      height: 35.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17.5.h),
                        color: activeTabBeingViewed == index ? appRed : null,
                      ),
                      child: Text(
                        index == 0 ? "Your Videos" : "Saved Videos",
                        style: context.textTheme.bodyLarge!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(height: 10.h),
          Expanded(
            child: loading
                ? const Center(
                    child: loader,
                  )
                : spotlights.isEmpty
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
                              style: context.textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            GestureDetector(
                              onTap: () {
                                if (activeTabBeingViewed == 0) {
                                  loadingMine = true;
                                  getMySpotlights();
                                } else {
                                  loadingSaved = true;
                                  getSavedSpotlights();
                                }
                                setState(() {});
                              },
                              child: Text(
                                "Refresh",
                                style: context.textTheme.titleSmall!.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: appRed,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 10.w,
                          crossAxisCount: 3,
                          mainAxisExtent: 150.h,
                          crossAxisSpacing: 10.w,
                        ),
                        itemCount: spotlights.length,
                        itemBuilder: (context, index) => _SpotlightContainer(
                          key: ValueKey<String>(spotlights[index].id),
                          header: "some plays",
                          data: spotlights[index],
                          onClick: () => context.router.pushNamed(
                            Pages.viewSpotlight,
                            extra: ViewSpotlightOptions(
                              data: spotlights[index],
                            ),
                          ),
                        ),
                      ),
          ),
        ],
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
      maxHeight: 150.h.toInt(),
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
        height: 150.h,
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
