import 'dart:developer';

import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/api/file_handler.dart';
import 'package:rediones/api/profile_service.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/screens/home/home.dart';
import 'package:rediones/screens/notification/notification.dart';
import 'package:rediones/screens/spotlight/spotlight.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/widgets.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage>
    with SingleTickerProviderStateMixin {
  late List<Widget> navPages;

  final int maxRetries = 5;
  int retries = 0;

  late AnimationController fabController;
  late Animation<double> fabAnimation;
  bool shrinkFAB = false;

  @override
  void initState() {
    super.initState();

    fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    fabAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: fabController, curve: Curves.easeIn),
    );

    navPages = const [
      Home(),
      SpotlightPage(),
      SizedBox(),
      NotificationPage(),
    ];

    _authenticate();
  }

  @override
  void dispose() {
    fabController.dispose();
    super.dispose();
  }

  void _showError(String text) {
    HapticFeedback.heavyImpact();
    AnimatedSnackBar.material(
      text,
      type: AnimatedSnackBarType.error,
      mobileSnackBarPosition: MobileSnackBarPosition.top,
      animationCurve: Curves.bounceIn,
      snackBarStrategy: RemoveSnackBarStrategy(),
    ).show(context);
  }

  void _authenticate() async {
    log("Logging In");
    if (retries >= maxRetries) {
      _showError("You were unable to be logged in. Please restart the app.");
      return;
    }

    Map<String, String>? authDetails = await FileHandler.loadAuthDetails();
    authenticate(authDetails!, Pages.login).then((resp) {
      if (resp.status == Status.failed) {
        _showError(resp.message);
        setState(() => ++retries);
        Future.delayed(const Duration(milliseconds: 500), _authenticate);
      } else {
        saveAuthDetails(authDetails, ref);
        ref.watch(userProvider.notifier).state = resp.payload!;
      }
    });
  }

  void showModalDialog() {
    void createPost() => context.router.pushNamed(Pages.createPosts);
    void askQuestion() => context.router.pushNamed(Pages.askQuestion);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.only(left: 120.w, right: 120.w, top: 400.h),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Container(
            height: 100.h,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    createPost();
                  },
                  child: Text(
                    "Create A Post",
                    style: context.textTheme.bodyMedium,
                  ),
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    askQuestion();
                  },
                  child: Text(
                    "Ask A Question",
                    style: context.textTheme.bodyMedium,
                  ),
                ),
              ],
            )),
      ),
      useSafeArea: true,
      barrierDismissible: true,
    );
  }

  void checkFAB() {
    if (ref.watch(shrinkFABProvider) && !shrinkFAB) {
      setState(() => shrinkFAB = true);
      fabController.forward();
    } else if (!ref.watch(shrinkFABProvider) && shrinkFAB) {
      setState(() => shrinkFAB = false);
      fabController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    int currentTab = ref.watch(dashboardIndexProvider);
    bool darkTheme = context.isDark;

    checkFAB();

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: currentTab,
          children: navPages,
        ),
      ),
      floatingActionButton: currentTab == 0
          ? ScaleTransition(
              scale: fabAnimation,
              child: FloatingActionButton(
                onPressed: showModalDialog,
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r)),
                backgroundColor: appRed,
                child: const Icon(
                  Icons.add_rounded,
                  color: theme,
                  size: 32,
                ),
              ),
            )
          : null,
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          CurvedNavigationBarItem(
            child: BottomNavItem(
              selected: currentTab == 0,
              activeSVG: "assets/Home Active.svg",
              inactiveSVG: "assets/Home Inactive.svg",
            ),
            label: "Home",
            labelStyle: context.textTheme.bodySmall,
          ),
          CurvedNavigationBarItem(
            child: BottomNavItem(
              activeSVG: "assets/Spotlight Active.svg",
              inactiveSVG: "assets/Spotlight Inactive.svg",
              selected: currentTab == 1,
            ),
            label: "Spotlight",
            labelStyle: context.textTheme.bodySmall,
          ),
          CurvedNavigationBarItem(
            child: BottomNavItem(
              selected: currentTab == 2,
              activeSVG: "assets/Community.svg",
              inactiveSVG: "assets/Community.svg",
            ),
            label: "Communities",
            labelStyle: context.textTheme.bodySmall,
          ),
          CurvedNavigationBarItem(
            child: BottomNavItem(
              selected: currentTab == 3,
              activeSVG: "assets/Notification Active.svg",
              inactiveSVG: "assets/Notification Inactive.svg",
            ),
            label: "Notification",
            labelStyle: context.textTheme.bodySmall,
          )
        ],
        onTap: (page) =>
            ref.watch(dashboardIndexProvider.notifier).state = page,
        backgroundColor: currentTab == 1 ? primary : Colors.transparent,
        color: darkTheme ? primary : theme,
      ),
    );
  }
}
