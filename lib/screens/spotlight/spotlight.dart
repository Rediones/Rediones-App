import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/components/spotlight_data.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/widgets.dart';

import 'package:fijkplayer/fijkplayer.dart';

class SpotlightPage extends ConsumerStatefulWidget {
  const SpotlightPage({super.key});

  @override
  ConsumerState<SpotlightPage> createState() => _SpotlightPageState();
}

class _SpotlightPageState extends ConsumerState<SpotlightPage> {
  bool fetching = true;

  final List<FijkPlayer> spotlightPlayers = [];
  final List<bool> spotlightStates = [];
  static const int maximumConcurrentPlayers = 5;
  static const int fullDragInSeconds = 30;

  int spotlightPointer = 0;
  int initialVideoDurationInMilliseconds = 0;

  double initialDragDx = 0.0;

  bool showText = false;
  String durationText = "";

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, fetchSpotlights);
  }

  Future<void> fetchSpotlights() async {
    List<SpotlightData> spotlights = ref.watch(spotlightsProvider);
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

    setState(() => fetching = false);
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
        spotlightPlayers[spotlightPointer].start();
        Future.delayed(Duration.zero,
            () => setState(() => spotlightStates[spotlightPointer] = true));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    listenForChanges();

    Size size = MediaQuery.of(context).size;
    double height = size.height, width = size.width;

    int length = ref.watch(spotlightsProvider).length;

    return Scaffold(
      backgroundColor: primary,
      body: Stack(
        children: [
          SizedBox(
            height: height,
            child: fetching
                ? const Center(child: loader)
                : PageView.builder(
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
                        setState(() {
                          initialVideoDurationInMilliseconds =
                              spotlightPlayers[index].currentPos.inMilliseconds;
                          initialDragDx = details.globalPosition.dx;
                          showText = true;
                        });
                      },
                      onHorizontalDragUpdate: (details) {
                        double currentDX = details.globalPosition.dx;
                        double newPosition = currentDX / width * 1000;
                        newPosition = newPosition.clamp(0, 1000);
                        bool reverse = initialDragDx - currentDX > 0;

                        int milliseconds = initialVideoDurationInMilliseconds +
                            (newPosition *
                                    fullDragInSeconds *
                                    (reverse ? -1.0 : 1.0))
                                .toInt();
                        FijkPlayer player = spotlightPlayers[index];
                        player.seekTo(milliseconds);

                        Duration currentDuration =
                            Duration(milliseconds: milliseconds);

                        setState(() {
                          durationText =
                              "${formatDuration(currentDuration)} - ${formatDuration(player.value.duration)}";
                        });
                      },
                      onHorizontalDragEnd: (details) {
                        setState(() {
                          showText = false;
                          durationText = "";
                        });
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
                          )
                        ],
                      ),
                    ),
                    itemCount: length,
                    scrollDirection: Axis.vertical,
                  ),
          ),
          Positioned(
            top: 10.h,
            left: 15.w,
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
