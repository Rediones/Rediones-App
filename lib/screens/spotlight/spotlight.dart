

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
  final FijkPlayer player = FijkPlayer();


  
  
  @override
  void initState() {
    super.initState();
    fetchSpotlights();
  }

  Future<void> fetchSpotlights() async {
    // List<SpotlightData> spotlightData = await getAllSpotlights();
    List<SpotlightData> spotlightData = [
      SpotlightData.fromJson({
        "_id" : "12",
        "postedBy": ref.read(userProvider),
        "likes" : ["1"]
      })
    ];



    // SpotlightData dta = spotlightData[0];
    // player.setDataSource(dta.url, autoPlay: true);
    // setState(() => fetching = false);
  }


  @override
  void dispose() {
    player.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: primary,
      body: Stack(
        children: [
          SizedBox(
            height: height,
            child: fetching ? const Center(child: loader) : PageView.builder(
              onPageChanged: (index) {
                if (index != 0) {
                  //controllers[index - 1].pause();
                }

                //if (index != controllers.length - 1) {
                  //controllers[index + 1].pause();
                //}

                //controllers[index].play();
              },
              itemBuilder: (_, index) => InkWell(
                onTap: () {
                  // setState(() {
                  //   if (controllers[index].value.isPlaying) {
                  //     controllers[index].pause();
                  //   } else {
                  //     controllers[index].play();
                  //   }
                  // });
                },
                child: Center(
                  child: FijkView(player: player),
                ),
              ),
              itemCount: 1,
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
