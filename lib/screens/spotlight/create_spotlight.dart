import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
//import 'package:media_gallery2/media_gallery2.dart';
import 'package:rediones/api/file_handler.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';

import 'package:rediones/api/spotlight_service.dart';

class CreateSpotlightPage extends StatefulWidget {
  const CreateSpotlightPage({super.key});

  @override
  State<CreateSpotlightPage> createState() => _CreateSpotlightPageState();
}

class _CreateSpotlightPageState extends State<CreateSpotlightPage>
    with SingleTickerProviderStateMixin {
  // List<MediaCollection> allVideos = [];
  // late MediaPage videoPage;

  bool loadedDeviceVideos = false;
  late TabController controller;

  int selectedVideo = -1;

  String? videoPath;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    getDeviceVideos();
  }

  Future<void> getDeviceVideos() async {
    // allVideos =
    //     await MediaGallery.listMediaCollections(mediaTypes: [MediaType.video])
    //         as List<MediaCollection>;
    // videoPage = await allVideos[0].getMedias(mediaType: MediaType.video);
    setState(() => loadedDeviceVideos = true);
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 0.01,
          iconSize: 26.r,
          icon: const Icon(Icons.chevron_left),
          onPressed: () => context.router.pop(),
        ),
        elevation: 0.0,
        centerTitle: true,
        title: Text("Recent", style: context.textTheme.headlineSmall),
      ),
      body: SafeArea(
        child: //!loadedDeviceVideos ?
            Center(child: SpinKitWave(color: appRed, size: 40.r))

        // : Padding(
        //         padding: EdgeInsets.symmetric(horizontal: 10.w),
        //         child: GridView.builder(
        //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //               mainAxisSpacing: 5.h,
        //               crossAxisCount: 4,
        //               crossAxisSpacing: 5.w),
        //           itemCount: videoPage.items.length,
        //           itemBuilder: (context, index) => _SpotlightContainer(
        //               data: Holder(videoPage.items[index],
        //                   selected: index == selectedVideo),
        //               onPress: () => setState(() => selectedVideo = index),
        //           ),
        //         ),
        //       ),
      ),
      bottomNavigationBar: Container(
        height: 50.h,
        width: 390.w,
        color: darkTheme ? primary : theme,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (loadedDeviceVideos)
              Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  selectedVideo != -1 ? appRed : neutral,
                    minimumSize: Size(90.w, 35.h)
                  ),
                  onPressed: () async {
                    if (selectedVideo == -1) {
                      showToast("Please choose a video", context);
                      return;
                    }

                    // context.router.pushNamed(
                    //   Pages.editSpotlight,
                    //   extra: videoPage.items[selectedVideo],
                    // );


                    SingleFileResponse? response = await FileHandler.single(type: FileType.video);
                    if(response != null) {
                      File file = File(response.path);
                      Uint8List data = await file.readAsBytes();
                      String videoData = FileHandler.convertTo64(data);
                      await createSpotlight(data: videoData, name: response.filename, extension: response.extension);
                    }

                  },
                  child: Text(
                    "Next",
                    style:
                        context.textTheme.bodyLarge!.copyWith(color: theme),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

// class _SpotlightContainer extends StatefulWidget {
//   final Holder<Media> data;
//   final VoidCallback onPress;
//
//   const _SpotlightContainer({
//     Key? key,
//     required this.data,
//     required this.onPress,
//   }) : super(key: key);
//
//   @override
//   State<_SpotlightContainer> createState() => _SpotlightContainerState();
// }
//
// class _SpotlightContainerState extends State<_SpotlightContainer> {
//   late Duration duration;
//   bool loaded = false;
//
//   @override
//   void initState() {
//     super.initState();
//     //assign();
//     duration = const Duration(minutes: 2, seconds: 45);
//   }
//
//   void assign() async {
//     double d = (await FlutterVideoInfo()
//             .getVideoInfo((await widget.data.value.getFile())!.path))!
//         .duration!;
//     duration = Duration(milliseconds: d.toInt());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.onPress,
//       child: SizedBox(
//         height: 100.h,
//         width: 85.w,
//         child: Stack(children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(5.r),
//             child: FadeInImage(
//               height: 100.h,
//               width: 85.w,
//               fit: BoxFit.cover,
//               placeholder: MemoryImage(kTransparentImage),
//               image: MediaThumbnailProvider(
//                 media: widget.data.value,
//               ),
//             ),
//           ),
//           Container(
//             height: 100.h,
//             width: 85.w,
//             alignment: Alignment.center,
//             color: widget.data.selected ? Colors.black45 : Colors.transparent,
//             child: widget.data.selected
//                 ? Container(
//                     height: 20.r,
//                     width: 20.r,
//                     alignment: Alignment.center,
//                     decoration: const BoxDecoration(
//                         shape: BoxShape.circle, color: appRed),
//                     child: Icon(Icons.done_rounded, size: 14.r, color: theme))
//                 : null,
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: EdgeInsets.only(bottom: 5.h, right: 5.w),
//               child: Text(formatDuration(duration),
//                   style: context.textTheme.bodyMedium!.copyWith(color: theme)),
//             ),
//           )
//         ]),
//       ),
//     );
//   }
// }
