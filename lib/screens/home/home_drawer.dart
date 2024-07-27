import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/providers.dart';

class HomeDrawer extends ConsumerStatefulWidget {
  const HomeDrawer({super.key});

  @override
  ConsumerState<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends ConsumerState<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    String profilePicture =
        ref.watch(userProvider.select((value) => value.profilePicture));
    String username = ref.watch(userProvider.select((value) => value.username));
    String nickname = ref.watch(userProvider.select((value) => value.nickname));

    return SizedBox(
      width: 250.w,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  context.router.pushNamed(Pages.profile);
                },
                child: SizedBox(
                  height: 50.h,
                  child: Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: profilePicture,
                        errorWidget: (context, url, error) => CircleAvatar(
                          backgroundColor: neutral2,
                          radius: 32.r,
                          child: Icon(Icons.person_outline_rounded, size: 24.r),
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
                              style: context.textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 32.sp),
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
                "assets/Community.svg",
                color: appRed,
              ),
              title: Text(
                "Projects",
                style: context.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                context.router.pushNamed(Pages.communityPractice);
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
              onTap: () {
                logout(ref);
                context.router.goNamed(Pages.login);
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
      ),
    );
  }
}
