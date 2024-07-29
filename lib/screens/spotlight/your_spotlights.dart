import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/widgets/common.dart';

class YourSpotlightsPage extends StatefulWidget {
  const YourSpotlightsPage({
    super.key,
  });

  @override
  State<YourSpotlightsPage> createState() => _YourSpotlightsPageState();
}

class _YourSpotlightsPageState extends State<YourSpotlightsPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final List<String> savedSpotlights = [], mySpotlights = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    getData();
  }

  Future<void> getData() async {
    await Future.delayed(const Duration(seconds: 4));
    setState(() => loading = true);
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
          "My Spotlights",
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
                dividerColor: Colors.transparent,
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
              if (loading)
                const Expanded(
                  child: Center(
                    child: loader,
                  ),
                ),
              if (!loading)
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      mySpotlights.isEmpty
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
                                    style:
                                        context.textTheme.titleSmall!.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() => loading = true);
                                      getData();
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
                                    style:
                                        context.textTheme.titleSmall!.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() => loading = true);
                                      getData();
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
  final String data;
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
