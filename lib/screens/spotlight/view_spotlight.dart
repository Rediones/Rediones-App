import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/components/spotlight_data.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/widgets/spotlight.dart';

class ViewSpotlightOptions {
  final SpotlightData data;
  final bool showUserData;

  const ViewSpotlightOptions({
    required this.data,
    this.showUserData = false,
});
}

class ViewSpotlightPage extends StatefulWidget {
  final ViewSpotlightOptions options;

  const ViewSpotlightPage({
    super.key,
    required this.options,
  });

  @override
  State<ViewSpotlightPage> createState() => _ViewSpotlightPageState();
}

class _ViewSpotlightPageState extends State<ViewSpotlightPage> {
  late FijkPlayer player;
  late bool playing;

  @override
  void initState() {
    super.initState();

    player = FijkPlayer();
    player.setDataSource(widget.options.data.url, autoPlay: true);
    player.setLoop(0);
    playing = true;
  }

  @override
  void dispose() {
    player.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primary,
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              setState(() {
                playing = !playing;
                if (playing) {
                  player.start();
                } else {
                  player.pause();
                }
              });
            },
            child: Stack(
              children: [
                Center(
                  child: FijkView(
                    player: player,
                    fsFit: FijkFit.cover,
                    fit: FijkFit.cover,
                    panelBuilder: (player, data, context, rect, size) =>
                        const SizedBox(),
                  ),
                ),
                Positioned(
                  left: 10.w,
                  top: 15.h,
                  child: Text(
                    "Spotlight",
                    style: context.textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: playing ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  child: ColoredBox(
                    color: Colors.black.withOpacity(0.15),
                    child: SizedBox(
                      width: 390.w,
                      height: 844.h,
                      child: Center(
                        child: Icon(
                          Icons.play_arrow_rounded,
                          size: 64.r,
                          color: Colors.white60,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10.w,
                  bottom: 80.h,
                  child: SpotlightToolbar(
                    spotlight: widget.options.data,
                  ),
                ),
                if(widget.options.showUserData)
                  Positioned(
                    left: 10.w,
                    bottom: 100.h,
                    child: SpotlightUserData(
                      spotlight: widget.options.data,
                    ),
                  )
              ],
            ),
          ),
        ));
  }
}
