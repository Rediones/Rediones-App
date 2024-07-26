import 'package:camera/camera.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rediones/tools/constants.dart' as c;
import 'package:rediones/tools/constants.dart';
import 'package:timeago/timeago.dart' as time;

import 'api/file_handler.dart';
import 'repositories/database_manager.dart';
import 'tools/routes.dart';
import 'tools/styles.dart';

void main() async {
  WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  c.allCameras = await availableCameras();
  c.currentCamera = 0;

  await ScreenUtil.ensureScreenSize();
  await DatabaseManager.init();

  bool goHome = await FileHandler.hasAuthDetails;

  FlutterNativeSplash.preserve(widgetsBinding: binding);
  runApp(ProviderScope(child: Rediones(goHome: goHome)));
}

class Rediones extends ConsumerStatefulWidget {
  final bool goHome;
  const Rediones({super.key, required this.goHome});

  @override
  ConsumerState<Rediones> createState() => _RedionesState();
}

class _RedionesState extends ConsumerState<Rediones>
    with WidgetsBindingObserver {
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _router = GoRouter(
      initialLocation: widget.goHome ? Pages.home.path : Pages.login.path,
      routes: routes,
    );
    time.setDefaultLocale('en_short');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, widget) => MaterialApp.router(
        title: 'Rediones',
        debugShowCheckedModeBanner: false,
        theme: FlexThemeData.light(
          fontFamily: "Nunito",
          useMaterial3: true,
          scheme: FlexScheme.mandyRed,
          textTheme: lightTheme,
          appBarStyle: FlexAppBarStyle.scaffoldBackground,
          surfaceTint: Colors.transparent,
          appBarElevation: 1.0,
        ),
        darkTheme: FlexThemeData.dark(
          fontFamily: "Nunito",
          useMaterial3: true,
          scheme: FlexScheme.mandyRed,
          textTheme: darkTheme,
          appBarStyle: FlexAppBarStyle.scaffoldBackground,
          surfaceTint: Colors.transparent,
          appBarElevation: 1.0,
        ),
        routerConfig: _router,
      ),
      splitScreenMode: true,
      designSize: const Size(390, 844),
      minTextAdapt: true,
    );
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.paused) {
  //
  //   } else if (state == AppLifecycleState.resumed) {
  //
  //   }
  // }
}
