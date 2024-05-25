import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:rediones/components/postable.dart';
import 'package:rediones/repositories/conversation_repository.dart';
import 'package:rediones/repositories/messages_repository.dart';
import 'package:rediones/repositories/post_object_repository.dart';

import 'api/file_handler.dart';

import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/repositories/post_repository.dart';
import 'package:rediones/repositories/user_repository.dart';

import 'package:rediones/tools/constants.dart' as c;
import 'package:rediones/tools/constants.dart';
import 'package:timeago/timeago.dart' as time;

import 'components/message_data.dart';
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
  await DatabaseManager.init();

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
            appBarStyle: FlexAppBarStyle.scaffoldBackground,
            surfaceTint: Colors.transparent,
            appBarElevation: 1.0),
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

  Future<void> _savePosts(List<PostObject> posts) async {
    final PostObjectRepository repository = GetIt.I.get();
    await repository.clearAllAndAddAll(posts);
  }

  Future<void> _saveUser(User user) async {
    final UserRepository userRepository = GetIt.I.get();
    if (user != dummyUser) {
      userRepository.updateByIdAndColumn(user.id, "serverID", user);
      FileHandler.saveString(currentUserID, user.id);
    }
  }

  Future<User?> _loadUser() async {
    final UserRepository userRepository = GetIt.I.get();
    String? userID = await FileHandler.loadString(currentUserID);
    if (userID != null) {
      return userRepository.getById(userID);
    }
    return null;
  }

  Future<List<PostObject>> _loadPosts() async {
    final PostObjectRepository repository = GetIt.I.get();
    return repository.getAll();
  }

  Future<void> _saveConversations(List<Conversation> conversations) async {
    final ConversationRepository conversationRepository = GetIt.I.get();
    conversationRepository.clearAllAndAddAll(conversations);
  }

  Future<List<Conversation>> _loadConversations() async {
    final ConversationRepository conversationRepository = GetIt.I.get();
    return conversationRepository.getAll();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {

      final List<PostObject> posts = ref.watch(postsProvider);
      final List<Conversation> conversations = ref.watch(conversationsProvider);

      final User user = ref.watch(userProvider);

      await _savePosts(posts);
      await _saveUser(user);
      await _saveConversations(conversations);

    } else if (state == AppLifecycleState.resumed) {

      List<PostObject> posts = await _loadPosts();
      ref.watch(postsProvider).clear();
      ref.watch(postsProvider).addAll(posts);

      User? user = await _loadUser();
      if (user != null) {
        ref.watch(userProvider.notifier).state = user;
      }

      List<Conversation> conversations = await _loadConversations();
      ref.watch(conversationsProvider).clear();
      ref.watch(conversationsProvider).addAll(conversations);
    }
  }
}
