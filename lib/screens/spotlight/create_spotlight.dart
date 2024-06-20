import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/widgets.dart';

class CreateSpotlightPage extends StatefulWidget {
  const CreateSpotlightPage({super.key});

  @override
  State<CreateSpotlightPage> createState() => _CreateSpotlightPageState();
}

class _CreateSpotlightPageState extends State<CreateSpotlightPage>
    with TickerProviderStateMixin {
  final List<Album> allAlbums = [];
  final List<Medium> albumMedia = [];
  bool loadedDeviceVideos = false,
      expanded = false,
      _shouldRefreshAlbums = false,
      _shouldRefreshMedia = false;

  late AnimationController controller;
  late Animation<double> animation;

  String? videoPath;

  int selectedAlbum = 0;

  late Future deviceVideoFuture;
  Medium? selectedVideo;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut,
      ),
    );
    deviceVideoFuture = getDeviceVideos();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> getDeviceVideos() async {
    List<Album> albums = await PhotoGallery.listAlbums(
      mediumType: MediumType.video,
      newest: true,
    );
    allAlbums.addAll(albums);
    setState(() => _shouldRefreshAlbums = false);
    await getMediaForAlbum();
  }

  Future<void> getMediaForAlbum() async {
    setState(() => loadedDeviceVideos = false);
    Album album = allAlbums[selectedAlbum];
    MediaPage page = await album.listMedia();
    albumMedia.clear();
    albumMedia.addAll(page.items);
    setState(() {
      _shouldRefreshMedia = false;
      loadedDeviceVideos = true;
    });
  }

  Future get getFuture {
    return _shouldRefreshAlbums
        ? getDeviceVideos()
        : _shouldRefreshMedia
            ? getMediaForAlbum()
            : deviceVideoFuture;
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;

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
        title: GestureDetector(
          onTap: () => setState(() {
            expanded = !expanded;
            if (expanded) {
              controller.forward();
            } else {
              controller.reverse();
            }
          }),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 20.w,
                  maxWidth: 200.w,
                ),
                child: Text(
                  allAlbums.isEmpty ? "..." : allAlbums[selectedAlbum].name!,
                  style: context.textTheme.titleLarge,
                ),
              ),
              SizedBox(width: 5.w),
              Icon(Icons.keyboard_arrow_down_rounded, size: 26.r)
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder(
              future: getFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: loader);
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 5.r,
                        crossAxisCount: 4,
                        crossAxisSpacing: 5.r,
                        mainAxisExtent: 100.h,
                      ),
                      itemCount: albumMedia.length,
                      itemBuilder: (context, index) => _SpotlightContainer(
                        data: Holder(
                          albumMedia[index],
                          selected: albumMedia[index] == selectedVideo,
                        ),
                        onPress: () =>
                            setState(() => selectedVideo = albumMedia[index]),
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      "An error occurred while fetching your video albums",
                      style: context.textTheme.bodyLarge,
                    ),
                  );
                }
              },
            ),
            SpotlightMediaList(
              animation: animation,
              allAlbums: allAlbums,
              onSelect: (index) {
                setState(() {
                  selectedAlbum = index;
                  _shouldRefreshMedia = true;
                });
                controller.reverse();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: expanded ? null : Container(
        height: 60.h,
        width: 390.w,
        color: darkTheme ? primary : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (loadedDeviceVideos)
              Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedVideo != null ? appRed : neutral2,
                    minimumSize: Size(90.w, 35.h),
                    fixedSize: Size(90.w, 35.h),
                    elevation: 1.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                  ),
                  onPressed: () async {
                    if (selectedVideo == null) {
                      showToast("Please choose a video", context);
                      return;
                    }

                    context.router.pushNamed(
                      Pages.editSpotlight,
                      extra: selectedVideo,
                    );

                    // SingleFileResponse? response =
                    //     await FileHandler.single(type: FileType.video);
                    // if (response != null) {
                    //   File file = File(response.path);
                    //   Uint8List data = await file.readAsBytes();
                    //   String videoData = FileHandler.convertTo64(data);
                    //   await createSpotlight(
                    //       data: videoData,
                    //       name: response.filename,
                    //       extension: response.extension);
                    // }
                  },
                  child: Text(
                    "Next",
                    style: context.textTheme.titleSmall!.copyWith(
                      color: theme,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class _SpotlightContainer extends StatefulWidget {
  final Holder<Medium> data;
  final VoidCallback onPress;

  const _SpotlightContainer({
    super.key,
    required this.data,
    required this.onPress,
  });

  @override
  State<_SpotlightContainer> createState() => _SpotlightContainerState();
}

class _SpotlightContainerState extends State<_SpotlightContainer> {
  late Future videoFuture;
  bool shouldRefresh = false;

  @override
  void initState() {
    super.initState();
    videoFuture = assign();
  }

  Future<List<dynamic>> assign() async {
    File videoFile = await widget.data.value.getFile();
    Uint8List bytes =
        Uint8List.fromList(await widget.data.value.getThumbnail());
    var data = await FlutterVideoInfo().getVideoInfo(videoFile.path);
    Duration duration = Duration(milliseconds: data!.duration!.toInt());
    return [bytes, duration];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: videoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 100.h,
            width: 85.w,
            child: const Center(
              child: smallLoader,
            ),
          );
        } else {
          List<dynamic>? data = snapshot.data;

          if (data == null) return const SizedBox();

          return GestureDetector(
            onTap: widget.onPress,
            child: Container(
              height: 100.h,
              width: 85.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                image: DecorationImage(
                  image: MemoryImage(data[0]),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(widget.data.selected ? 0.5 : 0.1),
                    BlendMode.darken,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 5.r,
                horizontal: 5.r,
              ),
              child: Column(
                mainAxisAlignment: widget.data.selected
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.data.selected)
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 20.r,
                        width: 20.r,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: appRed),
                        child: Icon(
                          Icons.done_rounded,
                          size: 14.r,
                          color: theme,
                        ),
                      ),
                    ),
                  Text(
                    formatDuration(data[1]),
                    style: context.textTheme.bodyMedium!.copyWith(color: theme),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
