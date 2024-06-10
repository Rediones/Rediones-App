import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/components/spotlight_data.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/tools/constants.dart';
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

  static const int maximumConcurrentPlayers = 4;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, fetchSpotlights);
    // Future.delayed(const Duration(seconds: 1), () => ref.listen(spotlightsPlayStatusProvider, (oldVal, newVal) {
    //   if(!newVal) {
    //     pauseAll();
    //   }
    // }));
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
      spotlightPlayers.add(player);
      spotlightStates.add(false);
    }

    setState(() => fetching = false);
  }

  void pauseAll() {
    for (FijkPlayer player in spotlightPlayers) {
      player.pause();
    }
  }

  @override
  void dispose() {
    for (FijkPlayer player in spotlightPlayers) {
      player.release();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
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

                      spotlightPlayers[index].start();
                      spotlightStates[index] = true;
                    },
                    itemBuilder: (_, index) => InkWell(
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
                              color: Colors.black54,
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
          )
        ],
      ),
    );
  }
}
