import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:rediones/api/file_handler.dart';
import 'package:rediones/api/user_service.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/screens/home/home.dart';
import 'package:rediones/screens/notification/notification.dart';
import 'package:rediones/screens/spotlight/spotlight.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/tools/widgets.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
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

    _authenticate(5);
    Future.delayed(Duration.zero, () => FlutterNativeSplash.remove());
  }

  void _showError(String text) => showToast(text, context);

  void goHome() => context.router.goNamed(Pages.login);

  void _authenticate(int level) async {
    if (level == 0) {
      _showError("Could not login you in automatically");
      goHome();
      return;
    }

    Map<String, String>? authDetails = await FileHandler.loadAuthDetails();
    var resp = await authenticate(authDetails!, Pages.login);
    if (resp.status == Status.failed) {
      _showError("Unable to log you in. Retrying");
      _authenticate(level - 1);
    } else {
      _showError("Welcome back, ${resp.payload!.nickname}");
      saveToDatabase(resp.payload!);
      saveAuthDetails(authDetails, ref);
      ref.watch(userProvider.notifier).state = resp.payload!;
    }
  }

  Future<void> saveToDatabase(User user) async {
    Isar isar = GetIt.I.get();
    await isar.writeTxn(() async {
      await isar.users.put(user);
    });
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
            if (!ref.watch(hideBottomProvider)) bottomNavBar
          ],
        ),
      ),
    );
  }
}
