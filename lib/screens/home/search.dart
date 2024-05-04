import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rediones/components/community_data.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/widgets.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController suggestedController = ScrollController();
  final ScrollController communityController = ScrollController();

  late List<User> suggested;

  final FocusNode node = FocusNode();

  @override
  void initState() {
    super.initState();

    suggested = [
      const User(
        id: "123456",
        nickname: "chuks",
        firstName: "Desmond",
        lastName: "Chukwu",
        profilePicture: "assets/hotel.jpg",
      ),
      const User(
        id: "123456",
        nickname: "nigger12",
        firstName: "Abdullahi",
        lastName: "Francis",
        profilePicture: "assets/yacht.jpg",
      ),
      const User(
        id: "123456",
        nickname: "testys",
        firstName: "Testimony",
        lastName: "Adekoya",
        profilePicture: "assets/three.jpg",
      ),
      const User(
        id: "123456",
        nickname: "emma",
        firstName: "Dev",
        lastName: "Emmy",
        profilePicture: "assets/watch man.jpg",
      ),
      const User(
        id: "123456",
        nickname: "ripper",
        firstName: "Folayimi",
        lastName: "Ripper",
        profilePicture: "assets/twelve.jpg",
      ),
    ];

    node.requestFocus();
  }

  void onSearch(String text) {
    text = text.trim();
  }

  @override
  Widget build(BuildContext context) {
    List<CommunityData> communities = ref.watch(communitiesProvider);
    List<String> recentSearches = ref.watch(recentSearchesProvider);

    bool darkTheme = context.isDark;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              iconSize: 26.r,
              icon: const Icon(Icons.chevron_left),
              splashRadius: 0.01,
              onPressed: () => context.router.pop(),
            ),
            elevation: 0.0,
            floating: true,
            pinned: true,
            title: Text("Search", style: context.textTheme.titleLarge),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpecialForm(
                    width: 390.w,
                    height: 40.h,
                    focus: node,
                    borderColor: Colors.transparent,
                    fillColor: neutral2,
                    controller: searchController,
                    hint: "What are you looking for?",
                    action: TextInputAction.go,
                    onActionPressed: onSearch,
                    onChange: (text) => onSearch(text),
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
                  Text(
                    "Recent Searches",
                    style: context.textTheme.titleSmall!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverList.separated(
              itemBuilder: (_, index) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(recentSearches[index],
                      style: context.textTheme.bodyLarge,),
                  GestureDetector(
                    onTap: () => setState(
                      () => recentSearches.removeAt(index),
                    ),
                    child: Icon(
                      Boxicons.bx_x,
                      size: 20.r,
                    ),
                  )
                ],
              ),
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemCount: recentSearches.length,
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  const Divider(color: neutral2),
                  SizedBox(height: 10.h),
                  Text(
                    "Suggested",
                    style: context.textTheme.titleSmall!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    height: 150.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: suggested.length,
                      itemBuilder: (context, index) => SuggestedContainer(
                        onAdd: () {},
                        user: suggested[index],
                        onDelete: () => setState(
                          () => suggested.removeAt(index),
                        ),
                      ),
                      separatorBuilder: (_, __) => SizedBox(width: 13.w),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  const Divider(color: neutral2),
                  SizedBox(height: 15.h),
                  Text(
                    "Communities",
                    style: context.textTheme.titleSmall!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverGrid.builder(
              itemBuilder: (_, index) => CommunityContainer(
                onFollow: () {},
                data: communities[index],
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 146.h,
                crossAxisSpacing: 20.r,
                mainAxisSpacing: 20.r,
              ),
              itemCount: communities.length,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 50.h),
          )
        ],
      ),
    );
  }
}

class SuggestedContainer extends StatelessWidget {
  final User user;
  final VoidCallback onDelete;
  final VoidCallback onAdd;

  const SuggestedContainer({
    super.key,
    required this.user,
    required this.onDelete,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      width: 120.w,
      height: 150.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: darkTheme ? neutral3 : fadedPrimary),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 3.h,
            right: 5.w,
            child: GestureDetector(
              onTap: onDelete,
              child: Icon(Boxicons.bx_x, size: 20.r),
            ),
          ),
          SizedBox(
            width: 120.w,
            height: 145.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 15.h),
                CircleAvatar(
                  foregroundColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(user.profilePicture),
                  radius: 22.r,
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  width: 100.w,
                  child: Center(
                    child: Text(
                      user.username,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyLarge!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                SizedBox(
                  width: 100.w,
                  child: Center(
                    child: Text("@${user.nickname}",
                        style: context.textTheme.labelSmall),
                  ),
                ),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: onAdd,
                  child: Container(
                    height: 22.r,
                    width: 22.r,
                    decoration: BoxDecoration(
                      color: appRed,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Center(
                      child: Icon(Icons.add_rounded, color: theme, size: 18.r),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CommunityContainer extends StatelessWidget {
  final CommunityData data;
  final VoidCallback onFollow;

  const CommunityContainer({
    super.key,
    required this.data,
    required this.onFollow,
  });

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      width: 170.w,
      height: 130.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: darkTheme ? neutral3 : fadedPrimary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.r),
              topRight: Radius.circular(10.r),
            ),
            child: Image.asset(data.image,
                width: 170.w, height: 38.h, fit: BoxFit.cover),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: 150.w,
            child: Center(
              child: Text(
                data.name,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: goodYellow,
              minimumSize: Size(100.w, 30.h),
              maximumSize: Size(100.w, 30.h),
            ),
            onPressed: onFollow,
            child: Text("Follow",
                style: context.textTheme.bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600, color: primary)),
          ),
        ],
      ),
    );
  }
}
