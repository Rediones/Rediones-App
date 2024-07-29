import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:rediones/api/file_handler.dart';
import 'package:rediones/components/community_data.dart';
import 'package:rediones/components/group_data.dart';
import 'package:rediones/components/media_data.dart';
import 'package:rediones/components/message_data.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/screens/auth/create_profile.dart';
import 'package:rediones/screens/auth/login.dart';
import 'package:rediones/screens/auth/signup.dart';
import 'package:rediones/screens/community/community_chat.dart';
import 'package:rediones/screens/community/community_library.dart';
import 'package:rediones/screens/community/community_participants.dart';
import 'package:rediones/screens/community/community_practice.dart';
import 'package:rediones/screens/community/community_search.dart';
import 'package:rediones/screens/community/create_community.dart';
import 'package:rediones/screens/events/create_events.dart';
import 'package:rediones/screens/events/events_page.dart';
import 'package:rediones/screens/groups/create_group.dart';
import 'package:rediones/screens/groups/group_home.dart';
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
import 'package:rediones/screens/other/camera.dart';
import 'package:rediones/screens/other/media_view.dart';
import 'package:rediones/screens/profile/edit_profile.dart';
import 'package:rediones/screens/profile/my_profile.dart';
import 'package:rediones/screens/profile/other_profile.dart';
import 'package:rediones/screens/project/create_project.dart';
import 'package:rediones/screens/spotlight/create_spotlight.dart';
import 'package:rediones/screens/spotlight/edit_spotlight.dart';
import 'package:rediones/screens/spotlight/your_spotlights.dart';
import 'package:rediones/tools/providers.dart';

import 'constants.dart';

final List<GoRoute> routes = [
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
    onExit: (context, state) {
      ProviderContainer container = ProviderContainer();
      var controller = container.read(exitAttemptProvider.notifier);
      if(controller.state == 0) {
        return true;
      } else {
        controller.state--;
        Future.delayed(const Duration(seconds: 2), () => controller.state = 2);
      }
      return false;
    },
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
    builder: (_, state) => OtherProfilePage(id: state.extra as String),
  ),
  GoRoute(
    path: Pages.createSpotlight.path,
    name: Pages.createSpotlight,
    builder: (_, __) => const MultimediaGallery(),
  ),
  GoRoute(
    path: Pages.editSpotlight.path,
    name: Pages.editSpotlight,
    builder: (_, state) => EditSpotlightPage(spotlight: state.extra as Medium),
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
    builder: (_, state) => CreateStoryPage(media: state.extra as SingleFileResponse),
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
    builder: (_, state) => PreviewPictures(data: state.extra as PreviewData),
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
  GoRoute(
    path: Pages.createProfile.path,
    name: Pages.createProfile,
    builder: (_, __) => const CreateProfilePage(),
  ),
  GoRoute(
    path: Pages.camera.path,
    name: Pages.camera,
    builder: (_, __) => const CameraPage(),
  ),
  GoRoute(
    path: Pages.groupHome.path,
    name: Pages.groupHome,
    builder: (_, state) => GroupHome(data: state.extra as GroupData),
  ),
];
