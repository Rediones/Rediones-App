import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/poll_data.dart';
import 'package:rediones/components/search_data.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/providers.dart';

import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

class HomeDrawer extends ConsumerStatefulWidget {
  const HomeDrawer({super.key});

  @override
  ConsumerState<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends ConsumerState<HomeDrawer> {

  void logoutApp() => context.router.goNamed(Pages.login);

  @override
  Widget build(BuildContext context) {
    String profilePicture =
        ref.watch(userProvider.select((value) => value.profilePicture));
    String username = ref.watch(userProvider.select((value) => value.username));
    String nickname = ref.watch(userProvider.select((value) => value.nickname));

    return Container(
      color: context.isDark ? Colors.black : Colors.white,
      width: 390.w,
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              context.router.pushNamed(Pages.profile);
            },
            child: SizedBox(
              height: 60.h,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                ),
                child: Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: profilePicture,
                      errorWidget: (context, url, error) => CircleAvatar(
                        backgroundColor: neutral2,
                        radius: 32.r,
                      ),
                      progressIndicatorBuilder: (context, url, download) =>
                          Container(
                        width: 40.r,
                        height: 40.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: neutral2,
                        ),
                      ),
                      imageBuilder: (context, provider) => CircleAvatar(
                        backgroundImage: provider,
                        radius: 32.r,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 140.w,
                          child: Text(
                            username,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          "@$nickname",
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodyLarge,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 30.h),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
            leading: SvgPicture.asset(
              "assets/Project Active.svg",
              color: appRed,
            ),
            title: Text(
              "Projects",
              style: context.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {

            },
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
            leading: SvgPicture.asset(
              "assets/Events.svg",
              color: appRed,
            ),
            title: Text(
              "Events",
              style: context.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              context.router.pushNamed(Pages.events);
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
            onTap: () async {
              logout(ref);
              Isar isar = GetIt.I.get();

              await isar.writeTxn(() async {
                await isar.users.where().deleteAll();
                await isar.posts.where().deleteAll();
                await isar.polls.where().deleteAll();
                await isar.searchDatas.where().deleteAll();
              });

              logoutApp();
            },
            leading: SvgPicture.asset(
              "assets/Logout.svg",
              color: appRed,
            ),
            title: Text(
              "Log Out",
              style: context.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
