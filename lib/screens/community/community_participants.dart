import 'package:badges/badges.dart' as bg;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/components/community_data.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/tools/constants.dart';

class CommunityParticipantsPage extends ConsumerStatefulWidget {
  final CommunityData data;

  const CommunityParticipantsPage({
    super.key,
    required this.data,
  });

  @override
  ConsumerState<CommunityParticipantsPage> createState() =>
      _CommunityParticipantsPageState();
}

class _CommunityParticipantsPageState
    extends ConsumerState<CommunityParticipantsPage> {
  final List<User> members = [], moderators = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 10; ++i) {
      members.add(ref.read(userProvider));
      moderators.add(ref.read(userProvider));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                icon: Icon(Icons.chevron_left, size: 26.r),
                onPressed: () => Navigator.pop(context),
              ),
              elevation: 0.0,
              title: Wrap(
                spacing: 5.w,
                children: [
                  Text("Participants", style: context.textTheme.titleMedium),
                  Text(
                    "(${members.length + moderators.length})",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: darkTheme ? Colors.white54 : Colors.black45),
                  ),
                ],
              ),
              centerTitle: true,
              floating: true,
              snap: true,
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Text("Moderator(s)", style: context.textTheme.bodySmall),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverList.separated(
                  itemBuilder: (_, index) =>  _ParticipantContainer(participant: moderators[index]),
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemCount: moderators.length,
                ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Text("Member(s)", style: context.textTheme.bodySmall),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverList.separated(
                itemBuilder: (_, index) =>  _ParticipantContainer(participant: members[index]),
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemCount: members.length,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 50.h),
            )
          ],
        ),
      ),
    );
  }
}

class _ParticipantContainer extends StatelessWidget {
  final User participant;

  const _ParticipantContainer({required this.participant});

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;
    return Container(
      width: 390.w,
      height: 55.h,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        border: Border.all(color: darkTheme ? neutral3 : fadedPrimary),
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.h),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 300.w,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 10.w),
                CircleAvatar(
                  backgroundImage: const AssetImage("assets/watch man.jpg"),
                  foregroundColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  radius: 18.r,
                ),
                SizedBox(width: 10.w),
                Text(participant.username,
                    style: context.textTheme.bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600)),
                SizedBox(width: 25.w),
                Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: const BoxDecoration(
                      // other color: neutral
                      color: appRed,
                      shape: BoxShape.circle),
                ),
              ],
            ),
          ),
          bg.Badge(
            badgeStyle: const bg.BadgeStyle(
              badgeColor: Colors.transparent,
              borderSide: BorderSide(
                color: appRed,
              ),
            ),
            badgeContent: Text("25",
                style: context.textTheme.labelSmall!.copyWith(color: appRed)),
          )
        ],
      ),
    );
  }
}
