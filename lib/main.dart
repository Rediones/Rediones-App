import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:is_lock_screen/is_lock_screen.dart';
import 'package:rediones/components/media_data.dart';
import 'package:rediones/components/message_data.dart';
import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/repositories/post_repository.dart';
import 'package:rediones/repositories/user_repository.dart';
import 'package:rediones/screens/auth/login.dart';
import 'package:rediones/screens/auth/signup.dart';
import 'package:rediones/screens/events/create_events.dart';
import 'package:rediones/screens/events/events_page.dart';
import 'package:rediones/screens/groups/create_group.dart';
import 'package:rediones/screens/groups/groups.dart';
import 'package:rediones/screens/home/ask_question.dart';
import 'package:rediones/screens/home/create_post.dart';
import 'package:rediones/screens/home/landing_page.dart';
import 'package:rediones/screens/home/search.dart';
import 'package:rediones/screens/home/splash.dart';
import 'package:rediones/screens/messaging/create_story.dart';
import 'package:rediones/screens/messaging/create_task.dart';
import 'package:rediones/screens/messaging/inbox.dart';
import 'package:rediones/screens/messaging/message.dart';
import 'package:rediones/screens/messaging/pockets.dart';
import 'package:rediones/screens/messaging/view_story.dart';
import 'package:rediones/screens/other/media_view.dart';
import 'package:rediones/screens/profile/edit_profile.dart';
import 'package:rediones/screens/profile/my_profile.dart';
import 'package:rediones/screens/profile/other_profile.dart';
import 'package:rediones/screens/community/community_chat.dart';
import 'package:rediones/screens/community/community_practice.dart';
import 'package:rediones/screens/community/create_community.dart';
import 'package:rediones/screens/community/community_library.dart';
import 'package:rediones/screens/community/community_participants.dart';
import 'package:rediones/screens/community/community_search.dart';
import 'package:rediones/screens/project/create_project.dart';
import 'package:rediones/screens/spotlight/create_spotlight.dart';
import 'package:rediones/screens/spotlight/edit_spotlight.dart';
import 'package:rediones/screens/spotlight/your_spotlights.dart';
import 'package:rediones/tools/constants.dart' as c;
import 'package:rediones/tools/constants.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:timeago/timeago.dart' as time;

import 'components/community_data.dart';
import 'components/user_data.dart';

import 'repositories/database_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  c.allCameras = await availableCameras();
  c.currentCamera = 0;

  await ScreenUtil.ensureScreenSize();

  await DatabaseManager.initialize();

  runApp(const ProviderScope(child: Rediones()));

  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
}

class Rediones extends ConsumerStatefulWidget {
  const Rediones({super.key});

  @override
  ConsumerState<Rediones> createState() => _RedionesState();
}

class _RedionesState extends ConsumerState<Rediones>
    with WidgetsBindingObserver {
  late GoRouter _router;
  late TextTheme _lightTheme, _darkTheme;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _router = GoRouter(
      initialLocation: Pages.splash.path,
      routes: [
        GoRoute(
          name: Pages.aspectRatio,
          path: Pages.aspectRatio.path,
          builder: (_, state) {
            List<String> data = state.extra as List<String>;
            String name = data[0];
            String path = data[1];
            return AspectRatioPage(
              imageName: name,
              imagePath: path,
            );
          },
        ),
        GoRoute(
          path: Pages.splash.path,
          name: Pages.splash,
          builder: (_, __) => const Splash(),
        ),
        GoRoute(
          path: Pages.register.path,
          name: Pages.register,
          builder: (_, __) => const Signup(),
        ),
        GoRoute(
          path: Pages.login.path,
          name: Pages.login,
          builder: (_, __) => const Login(),
        ),
        GoRoute(
          path: Pages.home.path,
          name: Pages.home,
          builder: (_, __) => const LandingPage(),
        ),
        GoRoute(
          path: Pages.createPosts.path,
          name: Pages.createPosts,
          builder: (_, state) => CreatePostPage(id: state.extra as String?),
        ),
        GoRoute(
          path: Pages.search.path,
          name: Pages.search,
          builder: (_, __) => const SearchPage(),
        ),
        GoRoute(
          path: Pages.createEvents.path,
          name: Pages.createEvents,
          builder: (_, __) => const CreateEventsPage(),
        ),
        GoRoute(
          path: Pages.events.path,
          name: Pages.events,
          builder: (_, __) => const EventsPage(),
        ),
        GoRoute(
          path: Pages.groups.path,
          name: Pages.groups,
          builder: (_, __) => const GroupsPage(),
        ),
        GoRoute(
          path: Pages.createGroup.path,
          name: Pages.createGroup,
          builder: (_, __) => const CreateGroupPage(),
        ),
        GoRoute(
          path: Pages.editProfile.path,
          name: Pages.editProfile,
          builder: (_, __) => const EditProfilePage(),
        ),
        GoRoute(
          path: Pages.profile.path,
          name: Pages.profile,
          builder: (_, __) => const MyProfilePage(),
        ),
        GoRoute(
          path: Pages.otherProfile.path,
          name: Pages.otherProfile,
          builder: (_, state) => OtherProfilePage(data: state.extra as User),
        ),
        GoRoute(
          path: Pages.createSpotlight.path,
          name: Pages.createSpotlight,
          builder: (_, __) => const CreateSpotlightPage(),
        ),
        GoRoute(
          path: Pages.editSpotlight.path,
          name: Pages.editSpotlight,
          builder: (_, state) =>
              EditSpotlightPage(spotlight: state.extra as dynamic),
        ),
        GoRoute(
          path: Pages.yourSpotlight.path,
          name: Pages.yourSpotlight,
          builder: (_, __) => const YourSpotlightsPage(),
        ),
        GoRoute(
          path: Pages.messagePocket.path,
          name: Pages.messagePocket,
          builder: (_, __) => const PocketPage(),
        ),
        GoRoute(
          path: Pages.createTask.path,
          name: Pages.createTask,
          builder: (_, __) => const CreateTaskPage(),
        ),
        GoRoute(
          path: Pages.createStory.path,
          name: Pages.createStory,
          builder: (_, __) => const CreateStoryPage(),
        ),
        GoRoute(
          path: Pages.inbox.path,
          name: Pages.inbox,
          builder: (_, state) => Inbox(details: state.extra as Conversation),
        ),
        GoRoute(
          path: Pages.viewStory.path,
          name: Pages.viewStory,
          builder: (_, state) => ViewStoryPage(story: state.extra as StoryData),
        ),
        GoRoute(
          path: Pages.message.path,
          name: Pages.message,
          builder: (_, __) => const MessagePage(),
        ),
        GoRoute(
          path: Pages.createProject.path,
          name: Pages.createProject,
          builder: (_, __) => const CreateProjectPage(),
        ),
        GoRoute(
          path: Pages.viewMedia.path,
          name: Pages.viewMedia,
          builder: (_, state) =>
              PreviewPictures(data: state.extra as PreviewData),
        ),
        GoRoute(
          path: Pages.askQuestion.path,
          name: Pages.askQuestion,
          builder: (_, __) => const AskQuestionPage(),
        ),
        GoRoute(
          path: Pages.communityPractice.path,
          name: Pages.communityPractice,
          builder: (_, __) => const CommunityPracticePage(),
        ),
        GoRoute(
          path: Pages.createCommunity.path,
          name: Pages.createCommunity,
          builder: (_, __) => const CreateCommunityPage(),
        ),
        GoRoute(
          path: Pages.communityChat.path,
          name: Pages.communityChat,
          builder: (_, state) =>
              CommunityChatPage(data: state.extra as CommunityData),
        ),
        GoRoute(
          path: Pages.communityLibrary.path,
          name: Pages.communityLibrary,
          builder: (_, state) =>
              CommunityLibraryPage(data: state.extra as CommunityData),
        ),
        GoRoute(
          path: Pages.communityParticipants.path,
          name: Pages.communityParticipants,
          builder: (_, state) =>
              CommunityParticipantsPage(data: state.extra as CommunityData),
        ),
        GoRoute(
          path: Pages.communitySearch.path,
          name: Pages.communitySearch,
          builder: (_, __) => const CommunitySearchPage(),
        ),
      ],
    );
    time.setDefaultLocale('en_short');

    _lightTheme = TextTheme(
      bodySmall: TextStyle(
        fontSize: 12.sp,
        color: primary,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.sp,
        color: primary,
        fontWeight: FontWeight.normal,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.sp,
        color: primary,
        fontWeight: FontWeight.normal,
      ),
      titleSmall: TextStyle(
        fontSize: 18.sp,
        color: primary,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        fontSize: 20.sp,
        color: primary,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        fontSize: 22.sp,
        color: primary,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: TextStyle(
        fontSize: 22.sp,
        color: primary,
        fontWeight: FontWeight.w600,
      ),
      displayMedium: TextStyle(
        fontSize: 24.sp,
        color: primary,
        fontWeight: FontWeight.w600,
      ),
      displayLarge: TextStyle(
        fontSize: 26.sp,
        color: primary,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        fontSize: 24.sp,
        color: primary,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        fontSize: 26.sp,
        color: primary,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: TextStyle(
        fontSize: 28.sp,
        color: primary,
        fontWeight: FontWeight.bold,
      ),
    );
    _darkTheme = TextTheme(
      bodySmall: TextStyle(
        fontSize: 12.sp,
        color: theme,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.sp,
        color: theme,
        fontWeight: FontWeight.normal,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.sp,
        color: theme,
        fontWeight: FontWeight.normal,
      ),
      titleSmall: TextStyle(
        fontSize: 18.sp,
        color: theme,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        fontSize: 20.sp,
        color: theme,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: TextStyle(
        fontSize: 22.sp,
        color: theme,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: TextStyle(
        fontSize: 22.sp,
        color: theme,
        fontWeight: FontWeight.w600,
      ),
      displayMedium: TextStyle(
        fontSize: 24.sp,
        color: theme,
        fontWeight: FontWeight.w600,
      ),
      displayLarge: TextStyle(
        fontSize: 26.sp,
        color: theme,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        fontSize: 24.sp,
        color: theme,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        fontSize: 26.sp,
        color: theme,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: TextStyle(
        fontSize: 28.sp,
        color: theme,
        fontWeight: FontWeight.bold,
      ),
    );
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
          textTheme: _lightTheme,
        ),
        darkTheme: FlexThemeData.dark(
          fontFamily: "Nunito",
          useMaterial3: true,
          scheme: FlexScheme.mandyRed,
          textTheme: _darkTheme,
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
      //final isLock = await isLockScreen();
      //if (isLock != null && !isLock) {
      final PostRepository postRepository = GetIt.I.get();
      final List<Post> posts = ref.watch(postsProvider);
      postRepository.clearAll();
      postRepository.addPosts(posts);

      final UserRepository userRepository = GetIt.I.get();
      final User user = ref.watch(userProvider);
      userRepository.updateUser(user);

      //}

      //else {
      // Screen is locked
      // Perform your logic here

      //}
    }
  }
}
