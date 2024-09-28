import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rediones/api/group_service.dart';
import 'package:rediones/components/group_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/tools/widgets.dart';

class GroupsPage extends ConsumerStatefulWidget {
  const GroupsPage({
    super.key,
  });

  @override
  ConsumerState<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends ConsumerState<GroupsPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  late TabController tabController;

  bool loaded = false;

  List<GroupData> forYou = [];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
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
        leadingWidth: 30.w,
        title: Text("Community Practice", style: context.textTheme.titleLarge),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => context.router.pushNamed(Pages.createCommunity),
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
          child: SingleChildScrollView(
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
                SizedBox(height: 5.h),
                const CommunitiesSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CommunitiesSection extends ConsumerStatefulWidget {
  const CommunitiesSection({super.key});

  @override
  ConsumerState<CommunitiesSection> createState() => _CommunitiesSectionState();
}

class _CommunitiesSectionState extends ConsumerState<CommunitiesSection>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    fetchGroups();
  }

  void showMessage(String message) => showToast(message, context);

  Future<void> fetchGroups() async {
    setState(() => loading = true);

    var result = await getGroups();
    if (!mounted) return;

    setState(() => loading = false);

    if (result.status == Status.failed) {
      showMessage(result.message);
      return;
    }

    ref.watch(myGroupsProvider).clear();
    ref.watch(myGroupsProvider).addAll(result.payload.myGroups);

    ref.watch(forYouGroupsProvider).clear();
    ref.watch(forYouGroupsProvider).addAll(result.payload.forYou);
  }

  Future<void> refreshGroups() async {
    setState(() => loading = true);
    fetchGroups();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<GroupData> myGroups = ref.watch(myGroupsProvider);
    List<GroupData> forYou = ref.watch(forYouGroupsProvider);

    if (loading) {
      return SizedBox(
        height: 600.h,
        child: const Center(child: loader),
      );
    }

    if (!loading && (myGroups.isEmpty && forYou.isEmpty)) {
      return SizedBox(
        height: 600.h,
        child: Center(
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
                "There are no communities available",
                style: context.textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 10.h),
              GestureDetector(
                onTap: fetchGroups,
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
        ),
      );
    }

    return Column(
      children: [
        TabBar(
          controller: controller,
          indicatorColor: appRed,
          dividerColor: Colors.transparent,
          labelStyle: context.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: context.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w400,
          ),
          labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
          tabAlignment: TabAlignment.center,
          labelColor: context.isDark ? theme : primary,
          tabs: const [
            Tab(text: "For You"),
            Tab(
              text: "Communities",
            ),
          ],
        ),
        SizedBox(height: 20.h),
        SizedBox(
          height: 550.h,
          child: TabBarView(
            controller: controller,
            children: [
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10.h,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.h,
                ),
                itemCount: forYou.length,
                itemBuilder: (_, index) => _GroupDataContainer(
                  data: forYou[index],
                ),
              ),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10.h,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.h,
                ),
                itemCount: myGroups.length,
                itemBuilder: (_, index) => _GroupDataContainer(
                  data: myGroups[index],
                  key: ValueKey<String>(myGroups[index].id),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _GroupDataContainer extends StatefulWidget {
  final GroupData data;

  const _GroupDataContainer({super.key, required this.data});

  @override
  State<_GroupDataContainer> createState() => _GroupDataContainerState();
}

class _GroupDataContainerState extends State<_GroupDataContainer> {
  final List<String> memberImages = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.data.groupUsers.length; ++i) {
      String image = widget.data.groupUsers[i].profilePicture;
      memberImages.add(image);

      if (i == 2) break;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;

    return GestureDetector(
      onTap: () => context.router.pushNamed(
        Pages.groupHome,
        extra: widget.data,
      ),
      child: Container(
        width: 170.w,
        height: 260.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: Colors.transparent,
          border: Border.all(color: darkTheme ? neutral3 : fadedPrimary),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: 5.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.5.r),
              child: CachedNetworkImage(
                imageUrl: widget.data.groupCoverImage,
                errorWidget: (context, url, error) => Container(
                  height: 80.h,
                  width: 170.w,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.broken_image_outlined,
                    color: appRed,
                    size: 24,
                  ),
                ),
                progressIndicatorBuilder: (context, url, download) => SizedBox(
                  height: 80.h,
                  width: 170.w,
                  child: const Center(
                    child: CenteredPopup(),
                  ),
                ),
                imageBuilder: (context, provider) => Container(
                  height: 80.h,
                  width: 170.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: provider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: 170.w,
              child: Center(
                child: Text(
                  widget.data.groupName,
                  style: context.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: 170.w,
              child: MultiMemberImage(
                images: memberImages,
                size: 14.r,
                border: goodYellow,
                total: widget.data.groupUsers.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
