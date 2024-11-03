import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/api/spotlight_service.dart';
import 'package:rediones/components/spotlight_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/providers.dart';
import 'package:rediones/tools/widgets.dart';

class SpotlightPage extends ConsumerStatefulWidget {
  const SpotlightPage({super.key});

  @override
  ConsumerState<SpotlightPage> createState() => _SpotlightPageState();
}

class _SpotlightPageState extends ConsumerState<SpotlightPage> {
  late List<FijkPlayer?> spotlightPlayers;

  int spotlightCurrentIndex = 0;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    spotlightPlayers = [];
    Future.delayed(Duration.zero, fetchSpotlights);
  }

  Future<void> fetchSpotlights() async {
    if (loading) return;
    setState(() => loading = true);

    var response = (await getAllSpotlights()).payload;
    if (response == null) {
      setState(() => loading = false);
      return;
    }

    ref.watch(spotlightsProvider.notifier).state = response;
    ref.watch(spotlightsPlayStatusProvider.notifier).state = false;
    List<SpotlightData> spotlights = ref.watch(spotlightsProvider);

    for (FijkPlayer? p in spotlightPlayers) {
      p?.release();
    }

    spotlightPlayers.clear();
    spotlightPlayers.addAll(List.filled(spotlights.length, null));

    int total = spotlights.length;

    for (int i = 0; i < total; ++i) {
      FijkPlayer player = FijkPlayer();
      SpotlightData data = spotlights[i];
      player.setDataSource(data.url, autoPlay: false);
      player.setLoop(0);
      spotlightPlayers[i] = player;
    }

    spotlightPlayers.first?.start();

    setState(() => loading = false);
  }

  void pauseAll() {
    for (FijkPlayer? player in spotlightPlayers) {
      if (player == null) continue;
      if (player.state == FijkState.started) {
        player.pause();
      }
    }
  }

  @override
  void dispose() {
    for (FijkPlayer? player in spotlightPlayers) {
      player?.release();
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
          spotlightPlayers[spotlightCurrentIndex]?.start();
        }
      }
    });

    ref.listen(isLoggedInProvider, (oldVal, newVal) {
      if (!oldVal! && newVal) {
        fetchSpotlights();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    listenForChanges();

    Size size = MediaQuery.of(context).size;
    double height = size.height;
    List<SpotlightData> spotlights = ref.watch(spotlightsProvider);
    bool isPlaying = ref.watch(spotlightsPlayStatusProvider);

    return BackButtonListener(
      onBackButtonPressed: () async {
        final canPop = context.router.canPop();
        if (!canPop) {
          ref.watch(dashboardIndexProvider.notifier).state = 0;
          ref.watch(spotlightsPlayStatusProvider.notifier).state = false;
        }
        return !canPop;
      },
      child: Scaffold(
        backgroundColor: primary,
        body: Stack(
          children: [
            SizedBox(
              height: height,
              width: 390.w,
              child: loading
                  ? const Center(
                      child: loader,
                    )
                  : (spotlights.isEmpty)
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/No Data.png",
                                width: 150.r,
                                height: 150.r,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                "There are no spotlights available",
                                style: context.textTheme.titleSmall!.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              GestureDetector(
                                onTap: fetchSpotlights,
                                child: Text(
                                  "Refresh",
                                  style: context.textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: appRed,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : PageView.builder(
                          onPageChanged: (index) {
                            pauseAll();
                            setState(() => spotlightCurrentIndex = index);
                            spotlightPlayers[index]?.seekTo(100);
                            spotlightPlayers[index]?.start();
                            ref
                                .watch(spotlightsPlayStatusProvider.notifier)
                                .state = true;
                          },
                          itemBuilder: (_, index) => GestureDetector(
                            onTap: () {
                              if (isPlaying) {
                                spotlightPlayers[spotlightCurrentIndex]
                                    ?.pause();
                              } else {
                                spotlightPlayers[spotlightCurrentIndex]
                                    ?.start();
                              }
                              ref
                                  .watch(spotlightsPlayStatusProvider.notifier)
                                  .state = !isPlaying;
                            },
                            child: Stack(
                              children: [
                                Center(
                                  child: spotlightPlayers[index] == null
                                      ? loader
                                      : FijkView(
                                          player: spotlightPlayers[index]!,
                                          fsFit: FijkFit.cover,
                                          fit: FijkFit.cover,
                                          panelBuilder: (player, data, context,
                                                  rect, size) =>
                                              const SizedBox(),
                                        ),
                                ),
                                Container(
                                  width: 390.w,
                                  height: 844.h,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(0, 0, 0, 0.7),
                                        Colors.transparent,
                                      ],
                                      stops: [0.1, 1],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                  child: AnimatedOpacity(
                                    opacity: isPlaying ? 0 : 1,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                    child: Icon(
                                      Icons.play_arrow_rounded,
                                      size: 64.r,
                                      color: Colors.white60,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 10.w,
                                  bottom: 80.h,
                                  child: SpotlightToolbar(
                                    spotlight: spotlights[index],
                                  ),
                                ),
                                Positioned(
                                  left: 10.w,
                                  bottom: 100.h,
                                  child: SpotlightUserData(
                                    spotlight: spotlights[index],
                                  ),
                                )
                              ],
                            ),
                          ),
                          itemCount: spotlights.length,
                          scrollDirection: Axis.vertical,
                        ),
            ),
            Positioned(
              top: 10.h,
              left: 10.w,
              child: Text(
                "Spotlight",
                style: context.textTheme.titleLarge!.copyWith(color: theme),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
