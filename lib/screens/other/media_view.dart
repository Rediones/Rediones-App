import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MediaViewPage extends StatefulWidget {
  final List<String> images;
  final List<String> video;

  const MediaViewPage({super.key, required this.images, required this.video});

  @override
  State<MediaViewPage> createState() => _MediaViewPageState();
}

class _MediaViewPageState extends State<MediaViewPage>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? controller;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);

    controller = VideoPlayerController.network(
      widget.video[0],
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    controller?.addListener(() {
      setState(() {});
    });
    controller?.initialize();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void pause() {
    controller?.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(Icons.chevron_left_rounded, size: 22.r, color: primary),
            onPressed: () => Navigator.pop(context),
            splashRadius: 0.1),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: [
                TabBar(
                    controller: tabController,
                    indicatorColor: appRed,
                    tabs: [
                      Tab(
                        child: Text("Your Videos",
                            style: context.textTheme.bodySmall),
                      ),
                      Tab(
                        child: Text("Saved Videos",
                            style: context.textTheme.bodySmall),
                      ),
                    ]),
                SizedBox(height: 25.h),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 5.h,
                        crossAxisCount: 2,
                        crossAxisSpacing: 5.h),
                    itemCount: widget.images.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => context.router.pushNamed(
                        Pages.viewMedia,
                        extra: PreviewData(
                          images: widget.images,
                          displayType: DisplayType.network,
                          current: index,
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: widget.images[index],
                        progressIndicatorBuilder: (context, url, download) =>
                            Center(
                          child: CircularProgressIndicator(
                              value: download.progress),
                        ),
                        imageBuilder: (context, provider) => Container(
                          width: 120.w,
                          height: 120.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: provider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum DisplayType { asset, network, memory, file }

class PreviewData {
  final List<Uint8List> bytes;
  final List<String> images;
  final DisplayType displayType;
  final int current;

  const PreviewData({
    this.images = const [],
    this.bytes = const [],
    required this.displayType,
    this.current = 0,
  });
}

class PreviewPictures extends StatefulWidget {
  final PreviewData data;

  const PreviewPictures({
    super.key,
    required this.data,
  });

  @override
  State<PreviewPictures> createState() => _PreviewPicturesState();
}

class _PreviewPicturesState extends State<PreviewPictures> {
  late PageController pageController;
  late int length;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.data.current);
    length = widget.data.images.isNotEmpty
        ? widget.data.images.length
        : widget.data.bytes.length;
  }

  ImageProvider provider(int index) {
    if (widget.data.displayType == DisplayType.asset) {
      return AssetImage(widget.data.images[index]);
    } else if (widget.data.displayType == DisplayType.network) {
      return NetworkImage(widget.data.images[index]);
    } else if (widget.data.displayType == DisplayType.file) {
      return FileImage(File(widget.data.images[index]));
    }
    return MemoryImage(widget.data.bytes[index]);
  }

  int getHashCode(int index) {
    if (widget.data.displayType == DisplayType.memory) {
      return widget.data.bytes[index].hashCode;
    }
    return widget.data.images[index].hashCode;
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;

    return Scaffold(
      body: SafeArea(
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (context, index) => PhotoViewGalleryPageOptions(
            imageProvider: provider(index),
            initialScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.contained * 3.0,
            minScale: PhotoViewComputedScale.contained * 0.8,
            heroAttributes: PhotoViewHeroAttributes(tag: getHashCode(index)),
          ),
          itemCount: length,
          loadingBuilder: (context, event) => const CenteredPopup(),
          backgroundDecoration:
              BoxDecoration(color: darkTheme ? primary : theme),
          pageController: pageController,
        ),
      ),
    );
  }
}
