import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const Color theme = Color.fromARGB(255, 245, 245, 245);
const Color appRed = Color.fromARGB(255, 217, 74, 74);
const Color appRed2 = Color.fromARGB(255, 255, 125, 125);
const Color niceBlue =  Color.fromARGB(255, 73, 121, 209);
const Color possibleGreen = Color.fromARGB(255, 0, 158, 96);
const Color goodYellow = Color.fromARGB(255, 252, 163, 17);
const Color primary = Color.fromARGB(255, 31, 31, 31);
const Color fadedPrimary = Color.fromARGB(25, 31, 31, 31);
const Color midPrimary = Color.fromARGB(255, 65, 65, 65);
const Color neutral = Color.fromARGB(180, 200, 200, 200);
const Color neutral2 = Color.fromARGB(35, 152, 152, 152);
const Color neutral3 = Color.fromARGB(255, 165, 165, 165);
const Color statusColor = Color.fromARGB(255, 229, 229, 229);
const Color offWhite = Color.fromRGBO(224, 224, 224, 1.0);

const Color primary1 = Color(0xFF1F1F1F);
const Color primaryPoint2 = Color.fromRGBO(0, 0, 0, 0.2);
const Color primaryPoint6 = Color.fromRGBO(0, 0, 0, 0.6);
const Color gray = Color(0xFF808080);
const Color gray2 = Color.fromRGBO(65, 65, 65, 0.5);
const Color gray3 = Color(0xFFD9D9D9);
const Color border = Color.fromRGBO(31, 31, 31, 0.15);

const Color authFieldBackground = Color.fromRGBO(242, 242, 242, 0.7);

const String userIsarId = "USER_ISAR_DB_ID";

List<CameraDescription> allCameras = [];
int currentCamera = 0;

extension StringPath on String {
  String get path => "/$this";
}

extension RedionesContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  GoRouter get router => GoRouter.of(this);
  ScaffoldMessengerState get messenger => ScaffoldMessenger.of(this);
  bool get isDark => MediaQuery.of(this).platformBrightness == Brightness.dark;
}

class Pages
{
  static const String splash = "splash";
  static const String register = "register";
  static const String login = "login";
  static const String home = "home";
  static const String spotlight = "spotlight";
  static const String search = "search";
  static const String notification = "notification";
  static const String events = "events";
  static const String groups = "groups";
  static const String camera = "camera";
  static const String communityPractice = "community-practice";
  static const String createProfile = "create-profile";
  static const String profile = "profile";
  static const String otherProfile = "other-profile";
  static const String message = "messages";
  static const String messagePocket = "message-pocket";
  static const String inbox = "inbox";
  static const String createPosts = "create-post";
  static const String createGroupPosts = 'create-group-posts';
  static const String createProject = "create-project";
  static const String createStory = "create-story";
  static const String createGroup = "create-group";
  static const String createCommunity = "create-community";
  static const String createEvents = "create-events";
  static const String createTask = 'create-task';
  static const String yourSpotlight = "your-spotlight";
  static const String createSpotlight = "create-spotlight";
  static const String editSpotlight = "edit-spotlight";
  static const String editProfile = "edit-profile";
  static const String viewStory = 'view-story';
  static const String aspectRatio = 'aspect-ratio';
  static const String viewMedia = 'view-media';
  static const String askQuestion = 'ask-question';
  static const String communityChat = 'community-chat';
  static const String communityLibrary = 'community-library';
  static const String communityParticipants = 'community-participants';
  static const String communitySearch = 'community-search';
  static const String groupHome = 'group-home';
  static const String viewPost = 'view-post';
 }

const String helpMeID = "65454b4db0916c7a0990af7f";
const String johnDoeID = "6547e80c1e04b4e42ff06db7";

const String loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque feugiat at risus sit amet scelerisque. Curabitur sollicitudin tincidunt erat, sed vehicula ligula ullamcorper at. In in tortor ipsum.";



class Holder<T> {
  T value;
  bool selected;

  Holder(this.value, {this.selected = false});
}
