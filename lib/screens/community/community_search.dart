import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rediones/components/community_data.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/widgets.dart';

import 'package:badges/badges.dart' as bg;

class CommunitySearchPage extends ConsumerStatefulWidget {
  const CommunitySearchPage({super.key});

  @override
  ConsumerState<CommunitySearchPage> createState() =>
      _CommunitySearchPageState();
}

class _CommunitySearchPageState extends ConsumerState<CommunitySearchPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<CommunityData> communities = ref.watch(communitiesProvider);
    bool darkTheme = context.isDark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Text(
          "Community Practice",
          style: context.textTheme.titleLarge,
        ),
        actions: [
          GestureDetector(
            onTap: () => context.router.pushNamed(Pages.createCommunity),
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: const BoxDecoration(
                color: neutral2,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_circle,
                size: 26.r,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: () => context.router.pop(),
            child: Container(
              decoration: BoxDecoration(
                color: appRed,
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              child: Text(
                "Explore",
                style: context.textTheme.bodyLarge!
                    .copyWith(color: theme),
              ),
            ),
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 5.h),
              SpecialForm(
                controller: searchController,
                fillColor: Colors.transparent,
                borderColor: neutral,
                width: 390.w,
                height: 40.h,
                hint: "Search your communities",
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
              SizedBox(height: 20.h),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (_, index) {
                    if (index == communities.length) {
                      return SizedBox(height: 50.h);
                    }

                    return GestureDetector(
                      onTap: () => context.router.pushNamed(Pages.communityChat, extra: communities[index]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage(communities[index].image),
                                radius: 20.r,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                communities[index].name,
                                style: context.textTheme.bodyLarge!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          bg.Badge(
                            badgeContent: Text(
                              "1",
                              style: context.textTheme.bodySmall!
                                  .copyWith(color: theme),
                            ),
                            badgeStyle: const bg.BadgeStyle(badgeColor: appRed),
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => SizedBox(height: 16.h),
                  itemCount: communities.length + 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
