import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rediones/api/post_service.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/screens/home/home.dart';
import 'package:rediones/screens/notification/notification.dart';
import 'package:rediones/screens/project/project_page.dart';
import 'package:rediones/screens/spotlight/spotlight.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/widgets.dart';

import 'dart:developer';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late List<Widget> navPages;

  @override
  void initState() {
    super.initState();
    navPages = const [
      Home(),
      SpotlightPage(),
      SizedBox(),
      NotificationPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    int currentTab = ref.watch(dashboardIndexProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            IndexedStack(
              index: currentTab,
              children: navPages,
            ),
            if (!ref.watch(hideBottomProvider))
              bottomNavBar
          ],
        ),
      ),
    );
  }
}
