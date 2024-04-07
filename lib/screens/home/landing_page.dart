import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
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

    _authenticate();
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
    Map<String, String>? authDetails = await FileHandler.loadAuthDetails();
    authenticate(authDetails!, Pages.login).then((resp) {
      if (resp.status == Status.failed) {
        _showError(resp.message);
      } else {
        saveAuthDetails(authDetails, ref);
        ref.watch(userProvider.notifier).state = resp.payload!;
      }
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
