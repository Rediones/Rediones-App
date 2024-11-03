import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rediones/api/file_handler.dart';
import 'package:rediones/api/notification_service.dart';
import 'package:rediones/api/user_service.dart';
import 'package:rediones/components/event_data.dart';
import 'package:rediones/components/group_data.dart';
import 'package:rediones/components/media_data.dart';
import 'package:rediones/components/message_data.dart';
import 'package:rediones/components/notification_data.dart';
import 'package:rediones/components/pocket_data.dart';
import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/postable.dart';
import 'package:rediones/components/project_data.dart';
import 'package:rediones/components/search_data.dart';
import 'package:rediones/components/spotlight_data.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/tools/constants.dart';

import '../components/community_data.dart';

User dummyUser = User(
  uuid: "dummy",
  profilePicture: "https://gravatar.com/avatar/dymmy?s=400&d=robohash&r=x",
);

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

final StateProvider<List<GroupData>> myGroupsProvider =
    StateProvider((ref) => []);
final StateProvider<List<GroupData>> forYouGroupsProvider =
    StateProvider((ref) => []);

final StateProvider<List<Conversation>> conversationsProvider =
    StateProvider((ref) => []);

final StateProvider<List<PocketData>> pocketProvider =
    StateProvider((ref) => []);

final StateProvider<List<StoryData>> storiesProvider = StateProvider(
  (ref) => [],
);

final StateProvider<StoryData> currentUserStory = StateProvider((ref) {
  User user = ref.watch(userProvider);
  UserSubData usb = UserSubData(
    profilePicture: user.profilePicture,
    username: user.nickname,
    lastName: user.lastName,
    firstName: user.firstName,
    id: user.uuid,
  );
  return StoryData(postedBy: usb);
});

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
    posterID: dummyUser.uuid,
    posterName: dummyUser.firstName,
    posterPicture: dummyUser.profilePicture,
    posterUsername: dummyUser.nickname,
    uuid: "Dummy Post ID: $index",
    text: loremIpsum,
    timestamp: DateTime(1900),
    comments: 0,
    shares: 0,
  ),
);

final List<EventData> dummyEvents = List.generate(
  4,
  (index) => EventData(
    id: "id",
    cover: "cover",
    header: "header",
    description: "description",
    location: "location",
    date: DateTime.now(),
    categories: [],
    interested: [],
    going: [],
    time: TimeOfDay.now(),
    author: dummyUser,
  ),
);

final StateProvider<List<SearchData>> recentSearchesProvider = StateProvider(
  (ref) => [],
);

final StateProvider<bool> isNewUserProvider = StateProvider((ref) => false);
final StateProvider<bool> isLoggedInProvider = StateProvider((ref) => false);
final StateProvider<bool> createdProfileProvider =
    StateProvider((ref) => false);

final StateProvider<bool> registeredNotificationHandler = StateProvider((ref) {
  ref.listen(isLoggedInProvider, (oldVal, newVal) {
    if (!oldVal! && newVal) {
      addHandler(notificationSignal, (data) {
        List<NotificationData> notifications = ref.read(notificationsProvider);
        NotificationData notificationData = processSocketNotification(data);
        ref.watch(notificationsProvider.notifier).state = [
          notificationData,
          ...notifications,
        ];

        AwesomeNotifications().createNotification(
            content: NotificationContent(
          id: 10,
          channelKey: 'rediones_notification_channel_key',
          actionType: ActionType.Default,
          title:
              "${notificationData.postedBy.nickname} ${notificationData.header}",
          body: notificationData.content,
          fullScreenIntent: true,
          wakeUpScreen: true,
        ));
      });
    }
  });
  return true;
});

final StateProvider<bool> initializedProvider = StateProvider((ref) => false);
final StateProvider<bool> hideBottomProvider = StateProvider((ref) => false);
final StateProvider<bool> updatedPostObject = StateProvider((ref) => false);
final StateProvider<int> dashboardIndexProvider = StateProvider((ref) => 0);
final StateProvider<bool> spotlightsPlayStatusProvider =
    StateProvider((ref) => false);

final StateProvider<List<Map<String, dynamic>>> outgoingStatus =
    StateProvider((ref) => []);

final StateProvider<bool> loadingLocalPostsProvider =
    StateProvider((ref) => true);

final StateProvider<UpdatePost> updatedPostInfoProvider =
    StateProvider((ref) => const UpdatePost());

class UpdatePost {
  final int index;
  final bool update;

  const UpdatePost({this.index = -1, this.update = false});
}

void toggle(StateProvider<UpdatePost> provider, WidgetRef ref) {
  UpdatePost state = ref.watch(provider);
  ref.watch(provider.notifier).state = UpdatePost(
    index: state.index,
    update: !state.update,
  );
}

void logout(WidgetRef ref) {
  FileHandler.saveAuthDetails(null);
  FileHandler.saveString(userIsarId, "");
  ref.invalidate(registeredNotificationHandler);
  ref.invalidate(currentUserStory);
  ref.invalidate(outgoingStatus);
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
  ref.invalidate(myGroupsProvider);
  ref.invalidate(forYouGroupsProvider);
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
