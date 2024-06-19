import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/components/spotlight_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/tools/widgets.dart';

class SpotlightPage extends ConsumerStatefulWidget {
  const SpotlightPage({super.key});

  @override
  ConsumerState<SpotlightPage> createState() => _SpotlightPageState();
}

class _SpotlightPageState extends ConsumerState<SpotlightPage> {
  final List<FijkPlayer> spotlightPlayers = [];
  final List<bool> spotlightStates = [];

  static const int maximumConcurrentPlayers = 5, fullDragInSeconds = 30;

  int spotlightPointer = 0, initialVideoDurationInMilliseconds = 0;

  double initialDragDx = 0.0;

  bool showText = false, _shouldRefresh = false;
  String durationText = "";

  late Future spotlightFuture;

  @override
  void initState() {
    super.initState();
    spotlightFuture = Future.delayed(Duration.zero);
  }

  Future<void> fetchSpotlights() async {
    if (_shouldRefresh) {
      List<SpotlightData> spotlights = ref.watch(spotlightsProvider);
      if (spotlights.isEmpty) return;

      for(FijkPlayer p in spotlightPlayers) {
        p.release();
      }
      spotlightStates.clear();
      spotlightPlayers.clear();

      int max = spotlights.length > maximumConcurrentPlayers
          ? maximumConcurrentPlayers
          : spotlights.length;

      for (int i = 0; i < max; ++i) {
        FijkPlayer player = FijkPlayer();
        SpotlightData data = spotlights[i];
        player.setDataSource(data.url, autoPlay: false);
        player.setLoop(0);
        spotlightPlayers.add(player);
        spotlightStates.add(false);
      }

      setState(() => _shouldRefresh = false);
    }
  }

  void pauseAll() {
    for (FijkPlayer player in spotlightPlayers) {
      if (player.state == FijkState.started) {
        player.pause();
      }
    }
  }

  @override
  void dispose() {
    for (FijkPlayer player in spotlightPlayers) {
      player.release();
    }

    super.dispose();
  }

  void listenForChanges() {
    ref.listen(spotlightsPlayStatusProvider, (oldVal, newVal) {
      if (!newVal) {
        pauseAll();
      } else {
        if (spotlightPlayers.isNotEmpty) {
          pauseAll();
          spotlightPlayers[spotlightPointer].start();
          Future.delayed(Duration.zero,
              () => setState(() => spotlightStates[spotlightPointer] = true));
        }
      }
    });

    ref.listen(userProvider, (oldUser, newUser) {
      if (oldUser == dummyUser && newUser != dummyUser) {
        setState(() => _shouldRefresh = true);
      }
    });
  }

  bool get available {
    return spotlightPlayers.isNotEmpty && spotlightStates.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    listenForChanges();

    Size size = MediaQuery.of(context).size;
    double height = size.height, width = size.width;
    List<SpotlightData> spotlights = ref.watch(spotlightsProvider);
    int length = spotlights.length;

    return Scaffold(
      backgroundColor: primary,
      body: Stack(
        children: [
          SizedBox(
            height: height,
            child: FutureBuilder(
              future: _shouldRefresh ? fetchSpotlights() : spotlightFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !_shouldRefresh) {
                  return const Center(child: loader);
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (!available || length == 0) {
                    return Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "No spotlights available finally.",
                              style: context.textTheme.bodyLarge,
                            ),
                            TextSpan(
                              text: " Tap to refresh",
                              style: context.textTheme.bodyLarge!
                                  .copyWith(color: appRed),
                              recognizer: TapGestureRecognizer()
                                ..onTap =
                                    () => setState(() => _shouldRefresh = true),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return PageView.builder(
                    onPageChanged: (index) {
                      if (index != 0) {
                        spotlightPlayers[index - 1].pause();
                        spotlightStates[index - 1] = false;
                      }

                      if (index != spotlightPlayers.length - 1) {
                        spotlightPlayers[index + 1].pause();
                        spotlightStates[index + 1] = false;
                      }

                      spotlightPlayers[index].seekTo(100);
                      spotlightPlayers[index].start();
                      spotlightStates[index] = true;
                      spotlightPointer = index;

                      setState(() {});
                    },
                    itemBuilder: (_, index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          if (spotlightStates[index]) {
                            spotlightPlayers[index].pause();
                            spotlightStates[index] = false;
                          } else {
                            spotlightPlayers[index].start();
                            spotlightStates[index] = true;
                          }
                        });
                      },
                      onHorizontalDragStart: (details) {
                        // setState(() {
                        //   initialVideoDurationInMilliseconds =
                        //       spotlightPlayers[index].currentPos.inMilliseconds;
                        //   initialDragDx = details.globalPosition.dx;
                        //   showText = true;
                        // });
                      },
                      onHorizontalDragUpdate: (details) {
                        // double currentDX = details.globalPosition.dx;
                        // double newPosition = currentDX / width * 1000;
                        // newPosition = newPosition.clamp(0, 1000);
                        // bool reverse = initialDragDx - currentDX > 0;
                        //
                        // int milliseconds = initialVideoDurationInMilliseconds +
                        //     (newPosition *
                        //             fullDragInSeconds *
                        //             (reverse ? -1.0 : 1.0))
                        //         .toInt();
                        // FijkPlayer player = spotlightPlayers[index];
                        // player.seekTo(milliseconds);
                        //
                        // Duration currentDuration =
                        //     Duration(milliseconds: milliseconds);
                        //
                        // setState(() {
                        //   durationText =
                        //       "${formatDuration(currentDuration)} - ${formatDuration(player.value.duration)}";
                        // });
                      },
                      onHorizontalDragEnd: (details) {
                        // setState(() {
                        //   showText = false;
                        //   durationText = "";
                        //   spotlightPlayers[index].start();
                        //   spotlightStates[index] = true;
                        // });
                      },
                      child: Stack(
                        children: [
                          Center(
                            child: FijkView(
                              player: spotlightPlayers[index],
                              fsFit: FijkFit.cover,
                              fit: FijkFit.cover,
                              panelBuilder:
                                  (player, data, context, rect, size) =>
                                      const SizedBox(),
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: spotlightStates[index] ? 0 : 1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            child: ColoredBox(
                              color: Colors.black.withOpacity(0.2),
                              child: SizedBox(
                                width: 390.w,
                                height: 844.h,
                                child: Center(
                                  child: Icon(
                                    Icons.play_arrow_rounded,
                                    size: 64.r,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: showText ? 1 : 0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            child: ColoredBox(
                              color: Colors.black.withOpacity(0.2),
                              child: SizedBox(
                                width: 390.w,
                                height: 844.h,
                                child: Center(
                                  child: Text(
                                    durationText,
                                    style: context.textTheme.headlineMedium!
                                        .copyWith(color: theme),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 10.w,
                            bottom: 80.h,
                            child: SpotlightToolbar(
                              data: spotlights[index],
                              liked: true,
                              onLike: () {},
                              bookmarked: false,
                              onCommentClicked: () {},
                              commentsFuture: () async {
                                await Future.delayed(Duration.zero);
                                return 1;
                              }(),
                              onBookmark: () {},
                            ),
                          ),
                          Positioned(
                            left: 10.w,
                            bottom: 100.h,
                            child: SpotlightUserData(
                              text: loremIpsum,
                              postedBy: spotlights[index].poster,
                              timestamp: spotlights[index].createdAt,
                            ),
                          )
                        ],
                      ),
                    ),
                    itemCount: length,
                    scrollDirection: Axis.vertical,
                  );
                } else {
                  return Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "No spotlights available.",
                            style: context.textTheme.bodyLarge,
                          ),
                          TextSpan(
                            text: " Tap to refresh",
                            style: context.textTheme.bodyLarge!
                                .copyWith(color: appRed),
                            recognizer: TapGestureRecognizer()
                              ..onTap =
                                  () => setState(() => _shouldRefresh = true),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          Positioned(
            top: 10.h,
            left: 10.w,
            child: Text(
              "Spotlight",
              style: context.textTheme.titleMedium!.copyWith(color: theme),
            ),
          ),
        ],
      ),
    );
  }
}
