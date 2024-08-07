import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';

class ImageSlide extends StatelessWidget {
  final List<Uint8List> mediaBytes;
  final Function onDelete;
  final Function onPictureTaken;

  const ImageSlide({
    super.key,
    required this.mediaBytes,
    required this.onDelete,
    required this.onPictureTaken,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.h,
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
                height: 80.h,
                width: 100.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r), color: neutral2),
                child: SvgPicture.asset("assets/Add Images Camera.svg"),
              ),
            );
          }

          return PostPreview(
            bytes: mediaBytes[index - 1],
            onDelete: () => onDelete(index - 1),
          );
        },
        separatorBuilder: (_, __) => SizedBox(width: 10.w),
        itemCount: mediaBytes.length + 1,
      ),
    );
  }
}

class PostPreview extends StatelessWidget {
  final Uint8List bytes;
  final Duration? duration;
  final VoidCallback onDelete;

  const PostPreview({
    super.key,
    required this.bytes,
    this.duration,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      width: 100.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: MemoryImage(bytes),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 3.h,
            right: 5.w,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 22.r,
                height: 22.r,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: Colors.white30, shape: BoxShape.circle),
                child: Icon(Boxicons.bx_x, color: appRed, size: 20.r),
              ),
            ),
          ),
          if (duration != null)
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                formatDuration(duration!),
              ),
            )
        ],
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
    bool hasExtra = images.length > 3;
    int count = images.length > 3 ? 4 : images.length;

    if (images.isEmpty) return const SizedBox();

    return SizedBox(
      height: size * 2,
      child: Stack(
        children: List.generate(
          count,
              (index) => Positioned(
            left: alignment == ImageAlign.start ? (index * size * 0.7) : (22.5.w * (index + 1)),
            child: (hasExtra && index == count - 1)
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
      ),
    );

  }
}
