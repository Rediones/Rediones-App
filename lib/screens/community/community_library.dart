import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart' as bg;
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:rediones/components/community_data.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:rediones/tools/constants.dart';

enum LibraryType { audio, file, link, video }

class LibraryMedia {
  final String? fileUrl;
  final String? linkUrl;
  final String? videoUrl;
  final String? audioUrl;

  const LibraryMedia(
      {this.fileUrl, this.linkUrl, this.audioUrl, this.videoUrl});
}

class CommunityLibraryPage extends StatefulWidget {
  final CommunityData data;

  const CommunityLibraryPage({super.key, required this.data});

  @override
  State<CommunityLibraryPage> createState() => _CommunityLibraryPageState();
}

class _CommunityLibraryPageState extends State<CommunityLibraryPage> {
  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left, size: 26.r),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0.0,
        title: Wrap(
          spacing: 5.w,
          children: [
            Text("Library", style: context.textTheme.titleMedium),
            Text(
              "(129)",
              style: context.textTheme.titleMedium!
                  .copyWith(color: darkTheme ? Colors.white54 : Colors.black45),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                const LibraryContent(
                  media: [
                    LibraryMedia(),
                    LibraryMedia(),
                    LibraryMedia(),
                    LibraryMedia(),
                    LibraryMedia(),
                  ],
                  header: "Videos",
                  type: LibraryType.video,
                  iconData: Boxicons.bx_video,
                ),
                SizedBox(height: 20.h),
                const LibraryContent(
                  media: [
                    LibraryMedia(),
                    LibraryMedia(),
                    LibraryMedia(),
                  ],
                  header: "Audio",
                  type: LibraryType.audio,
                  iconData: Icons.headphones,
                ),
                SizedBox(height: 20.h),
                const LibraryContent(
                  media: [
                    LibraryMedia(),
                    LibraryMedia(),
                    LibraryMedia(),
                    LibraryMedia(),
                    LibraryMedia(),
                    LibraryMedia(),
                  ],
                  header: "Files",
                  type: LibraryType.file,
                  iconData: Boxicons.bx_file,
                ),
                SizedBox(height: 20.h),
                const LibraryContent(
                  media: [
                    LibraryMedia(),
                    LibraryMedia(),
                  ],
                  header: "Link",
                  type: LibraryType.link,
                  iconData: Boxicons.bx_link,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LibraryContent extends StatefulWidget {
  final List<LibraryMedia> media;
  final String header;
  final IconData iconData;
  final LibraryType type;

  const LibraryContent({
    super.key,
    required this.media,
    required this.header,
    required this.type,
    required this.iconData,
  });

  @override
  State<LibraryContent> createState() => _LibraryContentState();
}

class _LibraryContentState extends State<LibraryContent>
    with SingleTickerProviderStateMixin {
  bool expanded = false;
  late Animation<double> sizeAnimation;
  late AnimationController sizeController;

  @override
  void initState() {
    super.initState();
    sizeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );
    sizeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: sizeController,
        curve: const Interval(
          0.0,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
  }

  @override
  void dispose() {
    sizeController.dispose();
    super.dispose();
  }

  void refresh() => setState(() {
        expanded = !expanded;
        if (expanded) {
          sizeController.forward();
        } else {
          sizeController.reverse();
        }
      });

  Widget getThumbnail(int index) {
    if (widget.type == LibraryType.video) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: FadeInImage(
          height: 40.r,
          width: 70.r,
          fit: BoxFit.cover,
          placeholder: MemoryImage(kTransparentImage),
          // image: MediaThumbnailProvider(
          //   media: widget.media[index],
          // ),
          image: const AssetImage("assets/home.jpeg"),
        ),
      );
    } else if (widget.type == LibraryType.audio) {
      return Container(
        height: 50.r,
        width: 70.r,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: neutral2),
          borderRadius: BorderRadius.circular(10.r),
          color: neutral2,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              Icons.music_note_rounded,
              size: 26.r,
            ),
            Text("two.mp3",
                style: context.textTheme.bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      );
    } else if (widget.type == LibraryType.file) {
      return Container(
        height: 50.r,
        width: 80.r,
        decoration: BoxDecoration(
          border: Border.all(color: neutral2),
          borderRadius: BorderRadius.circular(10.r),
          color: neutral2,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Boxicons.bxs_file_pdf, color: appRed, size: 22.r),
            Text("so...pdf",
                style: context.textTheme.bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600)),
            Text("1.73 Kb", style: context.textTheme.bodySmall)
          ],
        ),
      );
    }
    return Container(
      height: 50.r,
      width: 80.r,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        border: Border.all(color: neutral2),
        borderRadius: BorderRadius.circular(10.r),
        color: neutral2,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Boxicons.bx_link, size: 22.r),
          Text("www.google.com",
              style: context.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;

    return GestureDetector(
      onTap: refresh,
      child: Container(
        width: 390.w,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          border: Border.all(color: darkTheme ? neutral3 : fadedPrimary),
          borderRadius: BorderRadius.circular(15.r),
          color: Colors.transparent,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(widget.iconData, size: 26.r),
                    SizedBox(width: 10.w),
                    Text(widget.header,
                        style: context.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.w600)),
                    SizedBox(width: 20.w),
                    bg.Badge(
                      badgeStyle: const bg.BadgeStyle(
                        badgeColor: Colors.transparent,
                        borderSide: BorderSide(color: neutral3),
                      ),
                      badgeContent: Text(widget.media.length.toString(),
                          style: context.textTheme.bodySmall),
                    )
                  ],
                ),
                IconButton(
                  icon: Icon(!expanded ? Icons.add_rounded : Boxicons.bx_x,
                      size: 26.r, color: appRed),
                  onPressed: refresh,
                  splashRadius: 0.01,
                ),
              ],
            ),
            SizeTransition(
              sizeFactor: sizeAnimation,
              child: SizedBox(
                width: 350.w,
                height: 75.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) => getThumbnail(index),
                  separatorBuilder: (_, __) => SizedBox(width: 10.w),
                  itemCount: widget.media.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
