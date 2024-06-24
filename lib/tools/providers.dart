import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rediones/api/file_handler.dart';
import 'package:rediones/api/profile_service.dart';
import 'package:rediones/components/event_data.dart';
import 'package:rediones/components/group_data.dart';
import 'package:rediones/components/media_data.dart';
import 'package:rediones/components/message_data.dart';
import 'package:rediones/components/notification_data.dart';
import 'package:rediones/components/pocket_data.dart';
import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/postable.dart';
import 'package:rediones/components/project_data.dart';
import 'package:rediones/components/spotlight_data.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/tools/constants.dart';

import '../components/community_data.dart';

const User dummyUser = User(id: "dummy");
final StateProvider<User> userProvider = StateProvider((ref) => dummyUser);

final StateProvider<List<PostObject>> postsProvider =
    StateProvider((ref) => []);

final StateProvider<int> exitAttemptProvider = StateProvider((ref) => 2);

final StateProvider<List<SpotlightData>> spotlightsProvider = StateProvider(
  (ref) => [],
);

final StateProvider<List<NotificationData>> notificationsProvider =
    StateProvider((ref) => []);

final StateProvider<List<EventData>> eventsProvider =
    StateProvider((ref) => []);

final StateProvider<List<GroupData>> groupsProvider =
    StateProvider((ref) => []);

final StateProvider<List<Conversation>> conversationsProvider =
    StateProvider((ref) => []);

final StateProvider<List<PocketData>> pocketProvider =
    StateProvider((ref) => []);

final StateProvider<List<StoryData>> storiesProvider = StateProvider(
  (ref) => [
    StoryData(
      postedBy: ref.read(userProvider),
      stories: [
        MediaData(
          mediaUrl: "assets/watch man.jpg",
          type: MediaType.imageAndText,
          views: 0,
          timestamp: DateTime.now(),
        ),
      ],
    ),
    StoryData(
      postedBy: ref.read(userProvider),
      stories: [
        MediaData(
          mediaUrl: "assets/watch man.jpg",
          type: MediaType.imageAndText,
          views: 0,
          timestamp: DateTime.now(),
        ),
      ],
    ),
    StoryData(
      postedBy: ref.read(userProvider),
      stories: [
        MediaData(
          mediaUrl: "assets/watch man.jpg",
          type: MediaType.imageAndText,
          views: 0,
          timestamp: DateTime.now(),
        ),
      ],
    ),
    StoryData(
      postedBy: ref.read(userProvider),
      stories: [
        MediaData(
          mediaUrl: "assets/watch man.jpg",
          type: MediaType.imageAndText,
          views: 0,
          timestamp: DateTime.now(),
        ),
      ],
    ),
    StoryData(
      postedBy: ref.read(userProvider),
      stories: [
        MediaData(
          mediaUrl: "assets/watch man.jpg",
          type: MediaType.imageAndText,
          views: 0,
          timestamp: DateTime.now(),
        ),
      ],
    ),
    StoryData(
      postedBy: ref.read(userProvider),
      stories: [
        MediaData(
          mediaUrl: "assets/watch man.jpg",
          type: MediaType.imageAndText,
          views: 0,
          timestamp: DateTime.now(),
        ),
      ],
    ),
    StoryData(
      postedBy: ref.read(userProvider),
      stories: [
        MediaData(
          mediaUrl: "assets/watch man.jpg",
          type: MediaType.imageAndText,
          views: 0,
          timestamp: DateTime.now(),
        ),
      ],
    ),
  ],
);

final StateProvider<List<ProjectData>> projectsProvider =
    StateProvider((ref) => []);

final StateProvider<List<CommunityData>> communitiesProvider =
    StateProvider((ref) => const [
          CommunityData(
            image: "assets/watch man.jpg",
            name: "Dev Design",
            description:
                "Allow students to create detailed profiles with information such as their school, major, interests, and goals.",
            members: "500k",
          ),
          CommunityData(
            image: "assets/watch man.jpg",
            name: "Dev Design",
            description:
                "Allow students to create detailed profiles with information such as their school, major, interests, and goals.",
            members: "500k",
          ),
          CommunityData(
            image: "assets/watch man.jpg",
            name: "Dev Design",
            description:
                "Allow students to create detailed profiles with information such as their school, major, interests, and goals.",
            members: "500k",
          ),
          CommunityData(
            image: "assets/watch man.jpg",
            name: "Dev Design",
            description:
                "Allow students to create detailed profiles with information such as their school, major, interests, and goals.",
            members: "500k",
          ),
          CommunityData(
            image: "assets/watch man.jpg",
            name: "Dev Design",
            description:
                "Allow students to create detailed profiles with information such as their school, major, interests, and goals.",
            members: "500k",
          ),
        ]);

final StateProvider<List<CommunityChatData>> communityChatProvider =
    StateProvider(
  (ref) => [
    CommunityChatData(
      id: "id",
      userId: "userId",
      username: "Ava Lee",
      image: "assets/watch man.jpg",
      message:
          "Hello kifpsofp posipfoi posipogi poipogp iopfoga ipsfopaoigp oapio ipoigpo agiopafogi afg ",
      timestamp: DateTime.now(),
    ),
    CommunityChatData(
      id: "id",
      userId: "userId",
      username: "Ava Lee",
      image: "assets/watch man.jpg",
      message: "aisipgowr oqpirwp oirpoiq pigpqoirwg iproig gri gpqojpro",
      timestamp: DateTime.now(),
    ),
    CommunityChatData(
      id: "id",
      userId: "userId",
      username: "Ava Lee",
      image: "assets/watch man.jpg",
      message: "qri poqproit oqipto iporitporitpoiwt",
      timestamp: DateTime.now(),
    ),
    CommunityChatData(
      id: "id",
      userId: "userId",
      username: "Ava Lee",
      image: "assets/watch man.jpg",
      message:
          "qirtpo pqoritpoqirpotiq wrtpoqir trout qwrutp roit poitp iwpoti wprit pqowit iropt oqirw ptoirwpot iprwit poqirt ",
      timestamp: DateTime.now(),
    ),
    CommunityChatData(
      id: "id",
      userId: "6504e7b668ad68ed675a18d6",
      username: "Idowu Emmanuel",
      image: "assets/watch man.jpg",
      message: "Hello",
      timestamp: DateTime.now(),
    ),
  ],
);

final StateProvider<List<String>> eventCategories = StateProvider(
  (ref) => [
    "Sports",
    "Entertainment",
    "Football",
    "Games",
    "Festival",
    "Education",
    "Networking",
    "Arts and Culture",
    "Fun",
    "Health and Wellness",
    "Food and Drink",
    "Carnival",
    "Music",
    "Social Causes",
  ],
);

final StateProvider<List<String>> communityCategoriesProvider = StateProvider(
  (ref) => [
    "Science",
    "Study Group",
    "Academic Subject",
    "Career Exploration",
    "Mentorship and Guidance",
    "Skill Development",
    "STEM",
    "Alumni Networks",
    "Study Abroad Planning",
  ],
);

final List<Post> dummyPosts = List.generate(
  4,
  (index) => Post(
    poster: dummyUser,
    id: "Dummy Post ID: $index",
    text: loremIpsum,
    timestamp: DateTime(1900),
    shares: 0,
  ),
);

final StateProvider<List<String>> recentSearchesProvider = StateProvider(
  (ref) => [
    "Sholape Williams",
    "Idris Badejo",
    "Dev Emmy",
    "Fola The Ripper",
    "What's My Name"
  ],
);

final StateProvider<bool> isNewUserProvider = StateProvider((ref) => false);
final StateProvider<bool> isLoggedInProvider = StateProvider((ref) => false);
final StateProvider<bool> createdProfileProvider =
    StateProvider((ref) => false);
final StateProvider<bool> initializedProvider = StateProvider((ref) => false);
final StateProvider<bool> hideBottomProvider = StateProvider((ref) => false);
final StateProvider<int> dashboardIndexProvider = StateProvider((ref) => 0);
final StateProvider<bool> spotlightsPlayStatusProvider =
    StateProvider((ref) => false);

void logout(WidgetRef ref) {
  FileHandler.saveAuthDetails(null);
  ref.invalidate(exitAttemptProvider);
  ref.invalidate(spotlightsPlayStatusProvider);
  ref.invalidate(createdProfileProvider);
  ref.invalidate(recentSearchesProvider);
  ref.invalidate(communitiesProvider);
  ref.invalidate(hideBottomProvider);
  ref.invalidate(pocketProvider);
  ref.invalidate(projectsProvider);
  ref.invalidate(dashboardIndexProvider);
  ref.invalidate(isNewUserProvider);
  ref.invalidate(isLoggedInProvider);
  ref.invalidate(initializedProvider);
  ref.invalidate(storiesProvider);
  ref.invalidate(groupsProvider);
  ref.invalidate(eventsProvider);
  ref.invalidate(notificationsProvider);
  ref.invalidate(spotlightsProvider);
  ref.invalidate(postsProvider);
  ref.invalidate(conversationsProvider);
  ref.invalidate(userProvider);
}

Future<void> initializeApp(WidgetRef ref) async {
  if (ref.watch(initializedProvider)) return;

  Map<String, String>? details = await FileHandler.loadAuthDetails();
  if (details != null) {
    RedionesResponse<User?> response = await authenticate(details, Pages.login);
    if (response.status == Status.success) {
      FileHandler.saveAuthDetails(details);
      ref.watch(userProvider.notifier).state = response.payload!;
      ref.watch(isLoggedInProvider.notifier).state = true;
    }
  }
  ref.watch(initializedProvider.notifier).state = true;
}

void saveAuthDetails(Map<String, String> authDetails, WidgetRef ref) {
  FileHandler.saveAuthDetails(authDetails);
  ref.watch(isLoggedInProvider.notifier).state = true;
}

void goToTab(int index, WidgetRef ref) =>
    ref.watch(dashboardIndexProvider.notifier).state = index;
