import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/api/spotlight_service.dart';
import 'package:rediones/components/spotlight_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/tools/widgets/common.dart';

class YourSpotlightsPage extends ConsumerStatefulWidget {
  const YourSpotlightsPage({
    super.key,
  });

  @override
  ConsumerState<YourSpotlightsPage> createState() => _YourSpotlightsPageState();
}

class _YourSpotlightsPageState extends ConsumerState<YourSpotlightsPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final List<SpotlightData> savedSpotlights = [], mySpotlights = [];

  bool loadingSaved = true, loadingMine = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    Future.delayed(Duration.zero, () {
      getMySpotlights();
      getSavedSpotlights();
    });

  }

  void showMessage(String msg) => showToast(msg, context);


  Future<void> getMySpotlights() async {
    String id = ref.watch(userProvider.select((u) => u.uuid));
    var response = await getUserSpotlights(id);

    if(response.status == Status.failed) {
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

    if(response.status == Status.failed) {
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
                                  onClick: () {},
                                ),
                              ),

                    loadingSaved ? const Center(
                      child: loader,
                    )
                        :
                    savedSpotlights.isEmpty
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
                                  style: context.textTheme.titleSmall!.copyWith(
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
                              onClick: () {},
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
          border: Border.all(color: darkTheme ? neutral3 : fadedPrimary),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5.w),
              child: Text(widget.header, style: context.textTheme.bodyMedium),
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.r),
                bottomRight: Radius.circular(8.r),
              ),
              // child: FadeInImage(
              //   height: 155.h,
              //   width: 180.w,
              //   fit: BoxFit.cover,
              //   placeholder: MemoryImage(kTransparentImage),
              //   image: MediaThumbnailProvider(
              //     media: widget.data,
              //   ),
              // ),
            )
          ],
        ),
      ),
    );
  }
}
