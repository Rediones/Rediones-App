import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rediones/components/media_data.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:rediones/components/message_data.dart' hide MediaType;
import 'package:rediones/tools/constants.dart';

class YourSpotlightsPage extends StatefulWidget {
  final List<MediaData> saved;

  const YourSpotlightsPage({
    Key? key,
    this.saved = const [],
  }) : super(key: key);

  @override
  State<YourSpotlightsPage> createState() => _YourSpotlightsPageState();
}

class _YourSpotlightsPageState extends State<YourSpotlightsPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  // List<MediaCollection> allVideos = [];
  // late MediaPage videoPage;

  bool loadedDeviceVideos = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          splashRadius: 0.01,
          iconSize: 26.r,
          icon: const Icon(Icons.chevron_left),
          onPressed: () => context.router.pop(),
        ),
        title: Text("Your Spotlight", style: context.textTheme.titleMedium),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              TabBar(
                controller: tabController,
                indicatorColor: appRed,
                tabs: [
                  Tab(
                    child: Text("Your Videos",
                        style: context.textTheme.bodyMedium),
                  ),
                  Tab(
                    child: Text("Saved Videos",
                        style: context.textTheme.bodyMedium),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    !loadedDeviceVideos
                        ? Center(
                            child: SpinKitCubeGrid(color: appRed, size: 50.r))
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 10.h,
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                            ),
                            //itemCount: videoPage.items.length,
                      itemCount: 5,
                            itemBuilder: (context, index) => Text("")
                            //     _SpotlightContainer(
                            //   header: "some plays",
                            //   data: videoPage.items[index],
                            //   onClick: () {},
                            // ),
                          ),
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 10.h,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.h,
                      ),
                      itemCount: widget.saved.length,
                      itemBuilder: (context, index) =>
                      //     _SpotlightContainer(
                      //   header: "play",
                      //   data: videoPage.items[index],
                      //   onClick: () {},
                      // ),
                      Text("")
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class _SpotlightContainer extends StatefulWidget {
//   final String header;
//   final Media data;
//   final VoidCallback onClick;
//
//   const _SpotlightContainer({
//     Key? key,
//     required this.header,
//     required this.data,
//     required this.onClick,
//   }) : super(key: key);
//
//   @override
//   State<_SpotlightContainer> createState() => _SpotlightContainerState();
// }
//
// class _SpotlightContainerState extends State<_SpotlightContainer> {
//   @override
//   Widget build(BuildContext context) {
//     bool darkTheme =
//         MediaQuery.of(context).platformBrightness == Brightness.dark;
//
//     return GestureDetector(
//       onTap: widget.onClick,
//       child: Container(
//         width: 180.w,
//         height: 220.h,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8.r),
//             border: Border.all(color: darkTheme ? neutral3 : fadedPrimary)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.only(left: 5.w),
//               child: Text(widget.header, style: context.textTheme.bodyMedium),
//             ),
//             ClipRRect(
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(8.r),
//                 bottomRight: Radius.circular(8.r),
//               ),
//               child: FadeInImage(
//                 height: 155.h,
//                 width: 180.w,
//                 fit: BoxFit.cover,
//                 placeholder: MemoryImage(kTransparentImage),
//                 image: MediaThumbnailProvider(
//                   media: widget.data,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
