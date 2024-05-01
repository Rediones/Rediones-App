import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/repositories/post_repository.dart';
import 'package:rediones/repositories/user_repository.dart';

import 'package:rediones/tools/constants.dart' as c;
import 'package:rediones/tools/constants.dart';
import 'package:timeago/timeago.dart' as time;

import 'components/user_data.dart';
import 'tools/routes.dart';
import 'tools/styles.dart';
import 'repositories/database_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  c.allCameras = await availableCameras();
  c.currentCamera = 0;

  await ScreenUtil.ensureScreenSize();

  await DatabaseManager.initialize();

  runApp(const ProviderScope(child: Rediones()));
}

class Rediones extends ConsumerStatefulWidget {
  const Rediones({super.key});

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
      initialLocation: Pages.splash.path,
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
        ),
        darkTheme: FlexThemeData.dark(
          fontFamily: "Nunito",
          useMaterial3: true,
          scheme: FlexScheme.mandyRed,
          textTheme: darkTheme,
        ),
        routerConfig: _router,
      ),
      splitScreenMode: true,
      designSize: const Size(390, 844),
      minTextAdapt: true,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      final PostRepository postRepository = GetIt.I.get();
      final List<Post> posts = ref.watch(postsProvider);
      log("Pausing with ${posts.length}");

      if (posts.isNotEmpty) {
        postRepository.clearAll();
        postRepository.addPosts(posts);
      }

      final UserRepository userRepository = GetIt.I.get();
      final User user = ref.watch(userProvider);
      if (user != dummyUser) {
        userRepository.updateUser(user);
      }
    } else if (state == AppLifecycleState.resumed) {
      final PostRepository postRepository = GetIt.I.get();
      final List<Post> posts = await postRepository.getAllPosts();
      log("Resuming with ${posts.length}");

      if (posts.isNotEmpty) {
        ref.watch(postsProvider).clear();
        ref.watch(postsProvider).addAll(posts);
      }

      // final UserRepository userRepository = GetIt.I.get();
      // final User user = userRepository;
      // if (user != dummyUser) {
      //   userRepository.updateUser(user);
      // }
    }
  }
}
