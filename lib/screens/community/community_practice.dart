import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/components/community_data.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/tools/constants.dart';

class CommunityPracticePage extends ConsumerStatefulWidget {
  const CommunityPracticePage({super.key});

  @override
  ConsumerState<CommunityPracticePage> createState() =>
      _CommunityPracticePageState();
}

class _CommunityPracticePageState extends ConsumerState<CommunityPracticePage> {
  int popularCategory = 0;

  @override
  Widget build(BuildContext context) {
    List<String> categories = ref.watch(communityCategoriesProvider);
    List<CommunityData> communities = ref.watch(communitiesProvider);

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
            onTap: () => context.router.pushNamed(Pages.communitySearch),
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: const BoxDecoration(
                color: neutral2,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_rounded,
                size: 26.r,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                "Popular Categories",
                style: context.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 50.h,
                width: 390.w,
                child: ListView.separated(
                  itemBuilder: (_, index) => GestureDetector(
                    onTap: () => setState(() => popularCategory = index),
                    child: Chip(
                      label: Text(
                        categories[index],
                        style: context.textTheme.bodyLarge!.copyWith(
                          color: popularCategory == index
                              ? theme
                              : (darkTheme ? neutral3 : midPrimary),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      backgroundColor:
                          popularCategory == index ? neutral3 : null,
                      side: BorderSide(
                        color: index == popularCategory
                            ? Colors.transparent
                            : (darkTheme ? neutral3 : fadedPrimary),
                      ),
                    ),
                  ),
                  separatorBuilder: (_, __) => SizedBox(width: 20.w),
                  itemCount: categories.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (_, index) {
                    if (index == communities.length) {
                      return SizedBox(height: 50.h);
                    }

                    return _CommunityContainer(data: communities[index]);
                  },
                  separatorBuilder: (_, __) => SizedBox(height: 20.h),
                  itemCount: communities.length + 1,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CommunityContainer extends StatelessWidget {
  final CommunityData data;

  const _CommunityContainer({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;

    return Container(
      width: 390.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: darkTheme ? neutral3 : fadedPrimary),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundImage: AssetImage(data.image),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    style: context.textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  Text(
                    "${data.members} members",
                    style: context.textTheme.bodyMedium,
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            data.description,
            style: context.textTheme.bodyLarge,
          ),
          SizedBox(height: 10.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(390.w, 40.h),
              backgroundColor: appRed,
              elevation: 1.0,
            ),
            onPressed: () => context.router.pushNamed(
              Pages.communityChat,
              extra: data,
            ),
            child: Text(
              "Join",
              style: context.textTheme.bodyLarge!
                  .copyWith(color: theme, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
