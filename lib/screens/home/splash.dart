import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/api/file_handler.dart';
import 'package:rediones/api/profile_service.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/widgets.dart';

class Splash extends ConsumerStatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  ConsumerState<Splash> createState() => _SplashState();
}

class _SplashState extends ConsumerState<Splash> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut,
      ),
    );

    Future.delayed(
      const Duration(milliseconds: 1000),
      () async {
        controller.forward();
        Map<String, String>? authDetails = await FileHandler.loadAuthDetails();
        if(authDetails == null) {
          controller.reverse().then((_) => navigate(Pages.login));
        } else {
          authenticate(authDetails, Pages.login).then((resp) {
            String destination = Pages.login;
            if(resp.status == Status.failed) {
              showError(resp.message, background: offWhite, text: appRed);
            } else {
              login(authDetails, ref);
              ref.watch(userProvider.notifier).state = resp.payload!;
              if (!resp.payload!.isProfileComplete) {
                destination = Pages.editProfile;
              } else {
                destination = Pages.home;
              }
            }
            navigate(destination);
          });
        }
      },
    );
  }

  void navigate(String destination) => context.router.pushReplacementNamed(destination);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appRed,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Rediones",
                style: context.textTheme.displayLarge!.copyWith(color: theme),
              ),
              SizedBox(height: 20.h),
              FadeTransition(
                opacity: animation,
                child: whiteLoader,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
