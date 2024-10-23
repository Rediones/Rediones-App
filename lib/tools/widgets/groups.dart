import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rediones/tools/constants.dart';

class ImageSlide extends StatelessWidget {
  final List<Uint8List> mediaBytes;
  final Function onDelete;
  final Function onPictureTaken;
  final Function onSelect;
  final int currentIndex;

  const ImageSlide({
    super.key,
    required this.currentIndex,
    required this.onSelect,
    required this.mediaBytes,
    required this.onDelete,
    required this.onPictureTaken,
  });

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;

    return SizedBox(
      height: 70.r,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          if (index == 0) {
            return GestureDetector(
              onTap: () {
                context.router
                    .pushNamed(Pages.camera)
                    .then((res) => onPictureTaken(res));
              },
              child: Container(
                height: 70.r,
                width: 70.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  color: !darkTheme ? primary : neutral2,
                ),
                child: SvgPicture.asset("assets/Add Images Camera.svg"),
              ),
            );
          }

          return PostPreview(
            bytes: mediaBytes[index - 1],
            onSelect: () => onSelect(index - 1),
            currentIndex: currentIndex,
            index: index - 1,
          );
        },
        separatorBuilder: (_, __) => SizedBox(width: 5.r),
        itemCount: mediaBytes.length + 1,
      ),
    );
  }
}

class PostPreview extends StatelessWidget {
  final Uint8List bytes;
  final Duration? duration;
  final VoidCallback onSelect;
  final int currentIndex, index;

  const PostPreview({
    super.key,
    required this.bytes,
    this.duration,
    required this.currentIndex,
    required this.index,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        height: 70.r,
        width: 70.r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          border: index == currentIndex
              ? Border.all(
                  color: appRed,
                  width: 2.r,
                )
              : null,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: MemoryImage(bytes),
          ),
        ),
      ),
    );
  }
}

enum ImageAlign { start, center }

class MultiMemberImage extends StatelessWidget {
  final List<String> images;
  final double size;
  final Color border;
  final int total;
  final ImageAlign alignment;

  const MultiMemberImage({
    super.key,
    required this.images,
    required this.size,
    required this.border,
    required this.total,
    this.alignment = ImageAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    bool hasExtra = images.length > 1;
    int count = images.length > 1 ? 2 : 1;

    if (images.isEmpty) return const SizedBox();

    return SizedBox(
      height: size * 2,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: alignment == ImageAlign.center
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: List.generate(
          count,
          (index) => (hasExtra && index == count - 1)
              ? CircleAvatar(
                  backgroundColor: const Color(0xFFF5F5F5),
                  radius: size,
                  child: Text(
                    "+${total - images.length}",
                    style: context.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: primary,
                    ),
                  ),
                )
              : CachedNetworkImage(
                  imageUrl: images[0],
                  errorWidget: (_, url, error) => CircleAvatar(
                    radius: size,
                    backgroundColor: neutral2,
                  ),
                  progressIndicatorBuilder: (_, url, error) => CircleAvatar(
                    radius: size,
                    backgroundColor: neutral2,
                  ),
                  imageBuilder: (_, provider) => CircleAvatar(
                    backgroundColor: border,
                    radius: size,
                    child: CircleAvatar(
                      radius: size * 0.9,
                      backgroundImage: provider,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
