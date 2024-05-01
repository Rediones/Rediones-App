import 'dart:developer';
import 'dart:typed_data';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rediones/api/post_service.dart';
import 'package:rediones/api/profile_service.dart';
import 'package:rediones/components/event_data.dart';
import 'package:rediones/components/post_data.dart';
import 'package:rediones/components/project_data.dart';
import 'package:rediones/components/user_data.dart';
import 'package:rediones/components/providers.dart';
import 'package:rediones/screens/other/media_view.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:timeago/timeago.dart' as time;

class BreakLine extends StatelessWidget {
  const BreakLine({super.key});

  @override
  Widget build(BuildContext context) => Container(
        height: 1,
        color: neutral2,
      );
}

const SpinKitWave loader = SpinKitWave(
  color: appRed,
  size: 20,
);

const SpinKitWave whiteLoader = SpinKitWave(
  color: theme,
  size: 20,
);

// const BottomNavBar bottomNavBar = BottomNavBar();

class TabHeaderDelegate extends SliverPersistentHeaderDelegate {
  TabHeaderDelegate({required this.tabBar, this.color});

  final TabBar tabBar;
  final Color? color;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Container(
        color: color,
        child: tabBar,
      );

  @override
  bool shouldRebuild(TabHeaderDelegate oldDelegate) => false;
}

class WidgetHeaderDelegate extends SliverPersistentHeaderDelegate {
  WidgetHeaderDelegate({required this.child, this.color, required this.height});

  final Widget child;
  final double height;
  final Color? color;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Container(
        color: color,
        height: height,
        width: 390.w,
        child: child,
      );

  @override
  bool shouldRebuild(TabHeaderDelegate oldDelegate) => false;
}

class Popup extends StatelessWidget {
  const Popup({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => const AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: CenteredPopup(),
      );
}

class CenteredPopup extends StatelessWidget {
  const CenteredPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(child: loader);
}

class PopupPicture extends StatelessWidget {
  final String path;

  const PopupPicture({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CachedNetworkImage(
          imageUrl: path,
          progressIndicatorBuilder: (context, url, download) => Center(
            child: CircularProgressIndicator(
              value: download.progress,
              color: appRed,
            ),
          ),
          imageBuilder: (context, provider) => CircleAvatar(
            backgroundImage: provider,
            radius: 80.w,
          ),
        ),
      ),
    );
  }
}

class SpecialForm extends StatelessWidget {
  final Widget? prefix;
  final Widget? suffix;
  final String? hint;
  final Color? fillColor;
  final Color? borderColor;
  final EdgeInsets? padding;
  final bool obscure;
  final bool autoValidate;
  final FocusNode? focus;
  final bool autoFocus;
  final Function? onChange;
  final Function? onActionPressed;
  final Function? onValidate;
  final Function? onSave;
  final BorderRadius? radius;
  final TextEditingController controller;
  final TextInputType type;
  final TextInputAction action;
  final TextStyle? hintStyle;
  final bool readOnly;
  final int maxLines;
  final double width;
  final double height;

  const SpecialForm({
    super.key,
    required this.controller,
    required this.width,
    required this.height,
    this.fillColor,
    this.borderColor,
    this.padding,
    this.hintStyle,
    this.focus,
    this.autoFocus = false,
    this.readOnly = false,
    this.obscure = false,
    this.autoValidate = false,
    this.type = TextInputType.text,
    this.action = TextInputAction.none,
    this.onActionPressed,
    this.onChange,
    this.onValidate,
    this.onSave,
    this.radius,
    this.hint,
    this.prefix,
    this.suffix,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        autovalidateMode:
            autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
        maxLines: maxLines,
        focusNode: focus,
        autofocus: autoFocus,
        controller: controller,
        obscureText: obscure,
        keyboardType: type,
        textInputAction: action,
        readOnly: readOnly,
        onEditingComplete: () {
          if (onActionPressed != null) {
            onActionPressed!(controller.text);
          }
        },
        cursorColor: appRed,
        style: context.textTheme.bodyMedium,
        decoration: InputDecoration(
          errorMaxLines: 1,
          errorStyle: const TextStyle(height: 0, fontSize: 0),
          fillColor: fillColor ?? Colors.transparent,
          filled: true,
          contentPadding: padding ??
              EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: maxLines == 1 ? 5.h : 10.h,
              ),
          prefixIcon: prefix,
          suffixIcon: suffix,
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(maxLines > 1 ? 15.r : height * 0.5),
            borderSide: BorderSide(
              color: borderColor ?? (darkTheme ? neutral3 : fadedPrimary),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(maxLines > 1 ? 15.r : height * 0.5),
            borderSide: BorderSide(
              color: borderColor ?? (darkTheme ? neutral3 : fadedPrimary),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(maxLines > 1 ? 15.r : height * 0.5),
            borderSide: BorderSide(
              color: borderColor ?? (darkTheme ? neutral3 : fadedPrimary),
            ),
          ),
          hintText: hint,
          hintStyle: hintStyle ??
              context.textTheme.labelSmall!
                  .copyWith(fontWeight: FontWeight.w300, color: neutral3),
        ),
        onChanged: (value) {
          if (onChange == null) return;
          onChange!(value);
        },
        validator: (value) {
          if (onValidate == null) return null;
          return onValidate!(value);
        },
        onSaved: (value) {
          if (onSave == null) return;
          onSave!(value);
        },
      ),
    );
  }
}

class ComboBox extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> dropdownItems;
  final ValueChanged<String?>? onChanged;
  final DropdownButtonBuilder? selectedItemBuilder;
  final Alignment? hintAlignment;
  final Alignment? valueAlignment;
  final double? buttonHeight, buttonWidth;
  final EdgeInsetsGeometry? buttonPadding;
  final BoxDecoration? buttonDecoration;
  final int? buttonElevation;
  final Widget? icon;
  final double? iconSize;
  final Color? iconEnabledColor;
  final Color? iconDisabledColor;
  final double? itemHeight;
  final EdgeInsetsGeometry? itemPadding;
  final double? dropdownHeight, dropdownWidth;
  final EdgeInsetsGeometry? dropdownPadding;
  final BoxDecoration? dropdownDecoration;
  final int? dropdownElevation;
  final Radius? scrollbarRadius;
  final double? scrollbarThickness;
  final bool? scrollbarAlwaysShow;
  final Offset offset;
  final bool noDecoration;

  const ComboBox({
    required this.hint,
    required this.value,
    required this.dropdownItems,
    required this.onChanged,
    this.noDecoration = false,
    this.selectedItemBuilder,
    this.hintAlignment,
    this.valueAlignment,
    this.buttonHeight,
    this.buttonWidth,
    this.buttonPadding,
    this.buttonDecoration,
    this.buttonElevation,
    this.icon,
    this.iconSize,
    this.iconEnabledColor,
    this.iconDisabledColor,
    this.itemHeight,
    this.itemPadding,
    this.dropdownHeight,
    this.dropdownWidth,
    this.dropdownPadding,
    this.dropdownDecoration,
    this.dropdownElevation,
    this.scrollbarRadius,
    this.scrollbarThickness,
    this.scrollbarAlwaysShow,
    this.offset = Offset.zero,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Container(
          alignment: hintAlignment,
          child: Text(
            hint,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: context.textTheme.bodyMedium!
                .copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        value: value,
        items: dropdownItems
            .map(
              (String item) => DropdownMenuItem<String>(
                value: item,
                child: Container(
                  alignment: valueAlignment,
                  child: Text(
                    item,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: context.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
        selectedItemBuilder: selectedItemBuilder,
        buttonStyleData: ButtonStyleData(
          height: (noDecoration) ? null : buttonHeight ?? 40,
          width: (noDecoration) ? 80 : buttonWidth ?? 140,
          padding: (noDecoration)
              ? null
              : buttonPadding ?? const EdgeInsets.only(left: 14, right: 14),
          decoration: (noDecoration)
              ? null
              : buttonDecoration ??
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(color: fadedPrimary),
                  ),
          elevation: buttonElevation,
        ),
        iconStyleData: IconStyleData(
          icon: icon ?? const Icon(Icons.arrow_forward_ios_outlined),
          iconSize: iconSize ?? 12,
          iconEnabledColor: iconEnabledColor,
          iconDisabledColor: iconDisabledColor,
        ),
        dropdownStyleData: DropdownStyleData(
          //Max height for the dropdown menu & becoming scrollable if there are more items. If you pass Null it will take max height possible for the items.
          maxHeight: dropdownHeight ?? 200,
          width: dropdownWidth ?? 140,
          padding: dropdownPadding,
          decoration: dropdownDecoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
              ),
          elevation: dropdownElevation ?? 8,
          //Null or Offset(0, 0) will open just under the button. You can edit as you want.
          offset: offset,
          scrollbarTheme: ScrollbarThemeData(
            radius: scrollbarRadius ?? const Radius.circular(40),
            thickness: scrollbarThickness != null
                ? MaterialStateProperty.all<double>(scrollbarThickness!)
                : null,
            thumbVisibility: scrollbarAlwaysShow != null
                ? MaterialStateProperty.all<bool>(scrollbarAlwaysShow!)
                : null,
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: itemHeight ?? 40,
          padding: itemPadding ?? const EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}

class FadeRoute<T> extends PageRoute<T> {
  final Widget child;

  FadeRoute(this.child);

  @override
  Color get barrierColor => Colors.black;

  @override
  String get barrierLabel => "";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      FadeTransition(opacity: animation, child: child);

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);
}

class WaitScreen extends StatelessWidget {
  final Future<bool> future;
  final Widget onFalse;
  final Widget onTrue;

  const WaitScreen(
      {Key? key,
      required this.future,
      required this.onFalse,
      required this.onTrue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CenteredPopup();
          } else if (snapshot.connectionState == ConnectionState.done) {
            bool result = snapshot.data as bool;
            Navigator.pushReplacement(
                context, FadeRoute(result ? onTrue : onFalse));
            return const SizedBox();
          } else {
            Navigator.pushReplacement(context, FadeRoute(onFalse));
            return const SizedBox();
          }
        },
      )),
    );
  }
}

// class BottomNavBar extends ConsumerWidget {
//   const BottomNavBar({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     bool darkTheme = context.isDark;
//     int currentTab = ref.watch(dashboardIndexProvider);

//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 10.w),
//         child: SizedBox(
//           height: 120.h,
//           child: Stack(
//             children: [
//               Positioned(
//                 top: 20.h,
//                 left: 160.w,
//                 right: 160.w,
//                 child: GestureDetector(
//                   onTap: () {
//                     if (currentTab == 0) {
//                       showDialog(
//                         context: context,
//                         barrierDismissible: true,
//                         builder: (context) => Dialog(
//                           backgroundColor: Colors.transparent,
//                           elevation: 0.0,
//                           child: ClipPath(
//                             clipper: TriangleClipper(
//                               borderRadius: 10.r,
//                               triangleHeight: 15.h,
//                               triangleWidth: 20.h,
//                             ),
//                             child: Container(
//                               color: darkTheme ? primary : theme,
//                               height: 160.h,
//                               width: 40.w,
//                               padding: EdgeInsets.only(left: 55.w, top: 12.5.h),
//                               child: ListView(children: [
//                                 ListTile(
//                                   onTap: () {
//                                     Navigator.pop(context);
//                                     context.router.pushNamed(Pages.createPosts);
//                                   },
//                                   title: Text(
//                                     "Create A Post",
//                                     style: context.textTheme.bodyMedium,
//                                   ),
//                                 ),
//                                 ListTile(
//                                   onTap: () {
//                                     Navigator.pop(context);
//                                     context.router.pushNamed(Pages.askQuestion);
//                                   },
//                                   title: Text(
//                                     "Ask Question",
//                                     style: context.textTheme.bodyMedium,
//                                   ),
//                                 ),
//                               ]),
//                             ),
//                           ),
//                         ),
//                       );
//                     } else if (currentTab == 1) {
//                       showDialog(
//                         context: context,
//                         useSafeArea: true,
//                         barrierDismissible: true,
//                         builder: (context) => Dialog(
//                           backgroundColor: Colors.transparent,
//                           elevation: 0.0,
//                           child: ClipPath(
//                             clipper: TriangleClipper(
//                               borderRadius: 10.r,
//                               triangleHeight: 15.h,
//                               triangleWidth: 20.h,
//                             ),
//                             child: Container(
//                               color: neutral2,
//                               height: 65.h,
//                               width: 80.w,
//                               child: Column(
//                                 children: [
//                                   SizedBox(height: 20.h),
//                                   GestureDetector(
//                                     onTap: () async {
//                                       Navigator.pop(context);
//                                       Permission.storage.request().then((resp) {
//                                         if (resp.isGranted) {
//                                           context.router.pushNamed(
//                                             Pages.createSpotlight,
//                                           );
//                                         }
//                                       });
//                                     },
//                                     child: Text(
//                                       "Create A Spotlight Video",
//                                       style: context.textTheme.bodyMedium!
//                                           .copyWith(color: theme),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     } else if (currentTab == 2) {
//                       context.router.pushNamed(Pages.createProject);
//                     }
//                   },
//                   child: Container(
//                     height: 50.r,
//                     width: 50.r,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: currentTab == 1
//                           ? goodYellow
//                           : (darkTheme ? midPrimary : primary),
//                     ),
//                     child: Icon(
//                       Icons.add_rounded,
//                       size: 32.r,
//                       color: currentTab == 1 ? primary : offWhite,
//                     ),
//                   ),
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: ClipPath(
//                   clipper: BottomNavBarClipper(
//                     borderRadius: 15.r,
//                     cutoutRadius: 35.r,
//                   ),
//                   child: Container(
//                     color: currentTab == 1
//                         ? neutral2
//                         : (darkTheme ? midPrimary : primary),
//                     height: 70.h,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         SizedBox(
//                           width: 160.w,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               BottomNavItem(
//                                 color: currentTab == 1 ? offWhite : null,
//                                 selected: currentTab == 0,
//                                 height: 70.h,
//                                 text: "Home",
//                                 activeSVG: "assets/Home Active.svg",
//                                 inactiveSVG: "assets/Home Inactive.svg",
//                                 onSelect: () {
//                                   unFocus();
//                                   if (currentTab != 0) {
//                                     ref
//                                         .watch(dashboardIndexProvider.notifier)
//                                         .state = 0;
//                                   }
//                                 },
//                               ),
//                               BottomNavItem(
//                                 selected: currentTab == 1,
//                                 color: currentTab == 1 ? appRed : null,
//                                 height: 70.h,
//                                 activeSVG: "assets/Spotlight Active.svg",
//                                 inactiveSVG: "assets/Spotlight Inactive.svg",
//                                 text: "Spotlight",
//                                 onSelect: () {
//                                   unFocus();
//                                   if (currentTab != 1) {
//                                     ref
//                                         .watch(dashboardIndexProvider.notifier)
//                                         .state = 1;
//                                   }
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           width: 160.w,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               BottomNavItem(
//                                 selected: currentTab == 2,
//                                 color: currentTab == 1 ? offWhite : null,
//                                 height: 70.h,
//                                 text: "Communities",
//                                 activeSVG: "assets/Community.svg",
//                                 inactiveSVG: "assets/Community.svg",
//                                 onSelect: () {
//                                   unFocus();
//                                   context.router
//                                       .pushNamed(Pages.communityPractice);
//                                 },
//                               ),
//                               BottomNavItem(
//                                 selected: currentTab == 3,
//                                 color: currentTab == 1 ? offWhite : null,
//                                 height: 70.h,
//                                 text: "Notification",
//                                 activeSVG: "assets/Notification Active.svg",
//                                 inactiveSVG: "assets/Notification Inactive.svg",
//                                 onSelect: () {
//                                   unFocus();
//                                   if (currentTab != 3) {
//                                     ref
//                                         .watch(dashboardIndexProvider.notifier)
//                                         .state = 3;
//                                   }
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class ImageSlide extends StatelessWidget {
  final List<Uint8List> mediaBytes;
  final Function onDelete;

  const ImageSlide({
    super.key,
    required this.mediaBytes,
    required this.onDelete,
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

  const PostPreview(
      {Key? key, required this.bytes, this.duration, required this.onDelete})
      : super(key: key);

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

class PostContainer extends ConsumerStatefulWidget {
  final Post post;
  final VoidCallback onCommentClicked;

  const PostContainer({
    super.key,
    required this.post,
    required this.onCommentClicked,
  });

  @override
  ConsumerState<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends ConsumerState<PostContainer> {
  late int length;
  bool liked = false;
  bool bookmarked = false;
  bool expandText = false;
  late String currentUserID;
  late Future<int> commentsFuture;

  @override
  void initState() {
    super.initState();
    length = widget.post.media.length;
    User user = ref.read(userProvider);
    currentUserID = user.id;
    liked = widget.post.likes.contains(currentUserID);
    bookmarked = user.savedPosts.contains(widget.post.id);
    commentsFuture = _getCommentsCount();
  }

  Future<int> _getCommentsCount() async {
    int value = (await getComments(widget.post.id)).payload.length;
    return value;
  }

  void showExtension() {
    bool darkTheme = context.isDark;
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 360.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.h),
            SvgPicture.asset("assets/Modal Line.svg",
                color: darkTheme ? Colors.white : null),
            SizedBox(height: 30.h),
            ListTile(
              leading: SvgPicture.asset("assets/Link Red.svg"),
              title: Text(
                "Copy Link",
                style: context.textTheme.bodyMedium,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: SvgPicture.asset("assets/Unfollow Red.svg"),
              title: Text("Unfollow", style: context.textTheme.bodyMedium),
              onTap: () {},
            ),
            ListTile(
              leading: SvgPicture.asset("assets/Not Interested Red.svg"),
              title:
                  Text("Not Interested", style: context.textTheme.bodyMedium),
              onTap: () {},
            ),
            ListTile(
              leading: SvgPicture.asset("assets/Block Red.svg"),
              title: Text("Block User", style: context.textTheme.bodyMedium),
              onTap: () {},
            ),
            ListTile(
              leading: SvgPicture.asset("assets/Report Red.svg"),
              title: Text("Report Post", style: context.textTheme.bodyMedium),
              onTap: () {},
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  void onLike() {
    setState(() => liked = !liked);
    likePost(widget.post.id).then((response) {
      if (response.status == Status.success) {
        showToast(response.message);
        if (response.payload.contains(currentUserID) &&
            !widget.post.likes.contains(currentUserID)) {
          widget.post.likes.add(currentUserID);
        } else if (!response.payload.contains(currentUserID) &&
            widget.post.likes.contains(currentUserID)) {
          widget.post.likes.remove(currentUserID);
        }
        setState(() {});
      } else {
        setState(() => liked = !liked);
        showToast("Something went wrong");
      }
    });
  }

  void onBookmark(bool condition) {
    if ((bookmarked && condition) || (!bookmarked && !condition)) return;
    setState(() => bookmarked = condition);
    savePost(widget.post.id).then((value) {
      if (value.status == Status.success) {
        showToast(value.message);
        compute(
          (_) {
            List<String> postsID =
                ref.watch(userProvider.select((value) => value.savedPosts));
            postsID.clear();
            postsID.addAll(value.payload);
          },
          "",
        );
      } else {
        setState(() => bookmarked = !bookmarked);
        showToast("Something went wrong");
      }
    });
  }

  bool get shouldFollow {
    User currentUser = ref.watch(userProvider);
    if (widget.post.poster == currentUser) return false;
    if (widget.post.poster.followers.contains(currentUserID) ||
        currentUser.following.contains(widget.post.poster.id)) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;
    Map<PostCategory, Map<String, List<dynamic>>> postCategories =
        ref.watch(postCategoryProvider);
    String title = postCategories[widget.post.category]!.keys.first;
    List<dynamic> icon = postCategories[widget.post.category]![title]!;

    return Container(
      width: 390.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: darkTheme ? neutral2 : fadedPrimary),
        color: Colors.transparent,
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 60.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    User currentUser = ref.watch(userProvider);
                    if (widget.post.poster == currentUser) {
                      context.router.pushNamed(Pages.profile);
                    } else {
                      context.router.pushNamed(
                        Pages.otherProfile,
                        extra: widget.post.poster,
                      );
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.post.poster.profilePicture,
                        errorWidget: (context, url, error) => CircleAvatar(
                          backgroundColor: neutral2,
                          radius: 20.r,
                          child: Icon(
                            Icons.person_outline_rounded,
                            color: Colors.black,
                            size: 16.r,
                          ),
                        ),
                        progressIndicatorBuilder: (context, url, download) {
                          return Container(
                            width: 40.r,
                            height: 40.r,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: neutral2,
                            ),
                          );
                        },
                        imageBuilder: (context, provider) {
                          return CircleAvatar(
                            backgroundImage: provider,
                            radius: 20.r,
                          );
                        },
                      ),
                      SizedBox(width: 10.w),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 140.w,
                                child: Text(
                                  widget.post.poster.username,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.textTheme.bodySmall!
                                      .copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Text("@${widget.post.poster.nickname}",
                                  style: context.textTheme.labelSmall!.copyWith(fontSize: 10)),
                              Wrap(
                                spacing: 3.w,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(icon[0], size: 12.r, color: icon[1]),
                                  Text(title,
                                      style: context.textTheme.labelSmall!.copyWith(fontSize: 10))
                                ],
                              ),
                            ],
                          ),
                          if (shouldFollow)
                            Skeleton.ignore(
                              ignore: true,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 10.w),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxHeight: 15.h,
                                        maxWidth: 1.5.w,
                                        minHeight: 15.h,
                                        minWidth: 1.5.w),
                                    child: ColoredBox(
                                      color: darkTheme ? neutral2 : primary,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  GestureDetector(
                                    onTap: () async {
                                      await followUser(widget.post.poster.id);
                                    },
                                    child: Container(
                                      height: 20.r,
                                      width: 20.r,
                                      decoration: BoxDecoration(
                                        color: darkTheme ? neutral2 : primary,
                                        borderRadius:
                                            BorderRadius.circular(6.r),
                                      ),
                                      child: Center(
                                        child: Icon(Icons.add_rounded,
                                            color: theme, size: 16.r),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 5.w),
                  child: Row(
                    children: [
                      Text(time.format(widget.post.timestamp),
                          style: context.textTheme.labelSmall),
                      SizedBox(width: 10.w),
                      IconButton(
                        iconSize: 26.r,
                        icon: Icon(
                          Icons.more_horiz,
                          color: darkTheme ? neutral : midPrimary,
                        ),
                        onPressed: showExtension,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () => setState(() => expandText = !expandText),
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                text:
                    "${widget.post.text.substring(0, expandText ? null : (widget.post.text.length >= 150 ? 150 : widget.post.text.length))}"
                    "${widget.post.text.length >= 150 && !expandText ? "..." : ""}",
                style: context.textTheme.bodyMedium,
              ),
              if (widget.post.text.length > 150)
                TextSpan(
                  text: expandText ? " Read Less" : " Read More",
                  style: context.textTheme.bodySmall!.copyWith(color: appRed),
                ),
            ])),
          ),
          SizedBox(height: 10.h),
          if (widget.post.type == MediaType.imageAndText)
            SizedBox(
              width: 370.w,
              height: 230.h,
              child: PageView.builder(
                itemCount: length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => context.router.pushNamed(
                    Pages.viewMedia,
                    extra: PreviewData(
                      images: widget.post.media,
                      current: index,
                      displayType: DisplayType.network,
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.post.media[index],
                    errorWidget: (context, url, error) => Container(
                      width: 364.w,
                      height: 230.h,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/error.jpeg"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    progressIndicatorBuilder: (context, url, download) =>
                        const Center(
                      child: loader,
                    ),
                    imageBuilder: (context, provider) => Container(
                      width: 364.w,
                      height: 230.h,
                      decoration: BoxDecoration(
                        image:
                            DecorationImage(image: provider, fit: BoxFit.cover),
                      ),
                      child: length > 1
                          ? Padding(
                              padding: EdgeInsets.only(top: 10.h, left: 10.w),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  height: 20.h,
                                  width: 55.w,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(10.h),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 2.h),
                                  child: Text(
                                    "${index + 1} of $length",
                                    style: context.textTheme.bodySmall!
                                        .copyWith(color: theme),
                                  ),
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcherZoom.zoomIn(
                    duration: const Duration(milliseconds: 200),
                    child: IconButton(
                      key: ValueKey<bool>(liked),
                      splashRadius: 0.01,
                      onPressed: onLike,
                      iconSize: 18.r,
                      icon: Icon(liked ? Boxicons.bxs_like : Boxicons.bx_like,
                          color: liked ? appRed : null),
                    ),
                  ),
                  Text(
                    "${widget.post.likes.length}",
                    style: context.textTheme.bodySmall,
                  )
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Skeleton.ignore(
                    ignore: true,
                    child: IconButton(
                      icon: SvgPicture.asset("assets/Comment Post.svg",
                      width: 18.r, height: 18.r,
                          color: darkTheme ? Colors.white : null),
                      onPressed: widget.onCommentClicked,
                      splashRadius: 0.01,
                    ),
                  ),
                  FutureBuilder(
                    future: commentsFuture,
                    builder: (context, snapshot) {
                      String text = "";
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        text = "...";
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        text = "${snapshot.data as int}";
                      }
                      return Text(
                        text,
                        style: context.textTheme.bodySmall,
                      );
                    },
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Skeleton.ignore(
                    ignore: true,
                    child: IconButton(
                      icon: SvgPicture.asset("assets/Reply.svg", width: 18.r, height: 18.r,
                          color: darkTheme ? Colors.white : null),
                      onPressed: () {},
                      splashRadius: 0.01,
                    ),
                  ),
                  Text(
                    "${widget.post.shares}",
                    style: context.textTheme.bodySmall,
                  )
                ],
              ),
              AnimatedSwitcherZoom.zoomIn(
                duration: const Duration(milliseconds: 200),
                child: IconButton(
                  key: ValueKey<bool>(bookmarked),
                  icon: Icon(
                      bookmarked ? Boxicons.bxs_bookmark : Boxicons.bx_bookmark,
                      color: bookmarked ? appRed : null),
                  iconSize: 20.r,
                  splashRadius: 0.01,
                  onPressed: () => onBookmark(!bookmarked),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class MultiMemberImage extends StatelessWidget {
  final List<String> images;
  final double size;
  final Color border;
  final int total;

  const MultiMemberImage({
    super.key,
    required this.images,
    required this.size,
    required this.border,
    required this.total,
  });

  double leftPadding(int count) {
    return 225;
  }

  @override
  Widget build(BuildContext context) {
    int count = images.length > 3 ? 4 : (images.length + 1);

    if (images.isEmpty) return const SizedBox();

    return SizedBox(
      width: 170.w,
      height: 50.h,
      child: Center(
        child: SizedBox(
          width: 150.w,
          child: Center(
            child: Stack(
              children: List.generate(
                count,
                (index) => Positioned(
                  left: 22.5.w * (index + 1),
                  child: (index == count - 1)
                      ? CircleAvatar(
                          backgroundColor: border,
                          radius: size,
                          child: CircleAvatar(
                            foregroundColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            radius: size * 0.9,
                            child: Text(
                              "+${total - images.length}",
                              style: context.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w600, color: primary),
                            ),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: images[0],
                          errorWidget: (_, url, error) => CircleAvatar(
                            radius: size,
                            backgroundColor: neutral2,
                          ),
                          progressIndicatorBuilder: (_, url, error) =>
                              CircleAvatar(
                            radius: size,
                            backgroundColor: neutral2,
                          ),
                          imageBuilder: (_, provider) => CircleAvatar(
                            backgroundColor: border,
                            radius: size,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldCombo extends StatefulWidget {
  final TextEditingController controller;
  final Function onChanged;
  final EdgeInsets padding;
  final List<String> items;
  final String hint;
  final double width;
  final Function? onValidate;
  final double height;

  const TextFieldCombo({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.hint,
    required this.padding,
    required this.items,
    this.onValidate,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  State<TextFieldCombo> createState() => _TextFieldComboState();
}

class _TextFieldComboState extends State<TextFieldCombo> {
  String? selection;

  @override
  void initState() {
    super.initState();
    selection = widget.items[0];
  }

  @override
  Widget build(BuildContext context) {
    return SpecialForm(
      width: widget.width,
      height: widget.height,
      controller: widget.controller,
      onValidate: widget.onValidate,
      padding: widget.padding,
      hint: widget.hint,
      type: TextInputType.number,
      suffix: SizedBox(
        width: widget.width * 0.55,
        height: widget.height,
        child: DropdownButtonFormField<String>(
          value: selection,
          style: context.textTheme.bodyMedium,
          decoration: InputDecoration(
            fillColor: Colors.transparent,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
          ),
          items: widget.items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
          onChanged: (item) {
            selection = item;
            widget.onChanged(item);
          },
        ),
      ),
    );
  }
}

class ProjectContainer extends StatelessWidget {
  final ProjectData data;

  const ProjectContainer({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.isDark;
    return Container(
      width: 364.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: darkTheme ? neutral : fadedPrimary),
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: SizedBox(
              height: 48.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        foregroundColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage(data.user!.profilePicture),
                        radius: 18.r,
                      ),
                      SizedBox(
                        width: 11.w,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.user!.username,
                              style: context.textTheme.labelMedium!
                                  .copyWith(fontWeight: FontWeight.w700)),
                          Text("@${data.user!.nickname}",
                              style: context.textTheme.labelSmall)
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const BreakLine(),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () => context.router.pushNamed(
              Pages.viewMedia,
              extra: PreviewData(
                bytes: [data.cover!],
                displayType: DisplayType.memory,
              ),
            ),
            child: Image.memory(data.cover!,
                fit: BoxFit.cover, height: 116.h, width: 364.w),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Wrap(
                spacing: 10.w,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.start,
                children: [
                  Container(
                    width: 90.w,
                    height: 20.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: darkTheme ? Colors.white54 : Colors.black38,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.h),
                        topLeft: Radius.circular(10.h),
                        bottomLeft: Radius.circular(10.h),
                      ),
                    ),
                    child: Text(
                      "Project Title:",
                      style:
                          context.textTheme.bodyLarge!.copyWith(color: theme),
                    ),
                  ),
                  Text(
                    data.title,
                    style: context.textTheme.headlineLarge!
                        .copyWith(color: Colors.grey),
                  )
                ],
              ),
              SizedBox(height: 20.h),
              Wrap(
                  spacing: 10.w,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      width: 90.w,
                      height: 20.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: darkTheme ? Colors.white54 : Colors.black38,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.h),
                          topLeft: Radius.circular(10.h),
                          bottomLeft: Radius.circular(10.h),
                        ),
                      ),
                      child: Text("Description:",
                          style: context.textTheme.bodyLarge!
                              .copyWith(color: theme)),
                    ),
                    Text(data.description, style: context.textTheme.bodyLarge)
                  ]),
              SizedBox(height: 20.h),
              Wrap(
                  spacing: 10.w,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    Container(
                      width: 120.w,
                      height: 20.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: darkTheme ? Colors.white54 : Colors.black38,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.h),
                              topLeft: Radius.circular(10.h),
                              bottomLeft: Radius.circular(10.h))),
                      child: Text("Skills Required:",
                          style: context.textTheme.bodyLarge!
                              .copyWith(color: theme)),
                    ),
                    Text(data.title, style: context.textTheme.bodyLarge)
                  ]),
              SizedBox(height: 20.h),
              Wrap(
                  spacing: 10.w,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      width: 120.w,
                      height: 20.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: darkTheme ? Colors.white54 : Colors.black38,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.h),
                              topLeft: Radius.circular(10.h),
                              bottomLeft: Radius.circular(10.h))),
                      child: Text("Project Duration:",
                          style: context.textTheme.bodyLarge!
                              .copyWith(color: theme)),
                    ),
                    Text("${data.duration} ${data.durationType}",
                        style: context.textTheme.bodyLarge)
                  ]),
              SizedBox(height: 20.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.h),
                child: SizedBox(
                  width: 390.w,
                  height: 40.h,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          darkTheme ? Colors.white54 : Colors.black38),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Apply",
                      style:
                          context.textTheme.bodyLarge!.copyWith(color: theme),
                    ),
                  ),
                ),
              ),
            ]),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final String activeSVG;
  final String inactiveSVG;
  final Color? color;
  final bool invertColor;
  final bool selected;

  const BottomNavItem({
    super.key,
    this.color,
    this.invertColor = false,
    this.activeSVG = "",
    this.inactiveSVG = "",
    required this.selected,
  });

  Color getColor(bool darkTheme) {
    if (color != null) {
      return color!;
    }

    if (selected) {
      return appRed;
    }

    if (darkTheme) {
      return invertColor ? Colors.white54 : Colors.black54;
    } else {
      return !invertColor ? Colors.white54 : Colors.black54;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcherZoom.zoomIn(
      duration: const Duration(milliseconds: 200),
      child: SvgPicture.asset(
        selected ? activeSVG : inactiveSVG,
        key: ValueKey<bool>(selected),
        width: 20.r,
        height: 20.r,
      ),
    );
  }
}

class BottomNavBarClipper extends CustomClipper<Path> {
  final double borderRadius;
  final double cutoutRadius;

  const BottomNavBarClipper({
    required this.borderRadius,
    required this.cutoutRadius,
  });

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTRB(0, 0, size.width, size.height),
        Radius.circular(borderRadius)));

    return Path.combine(
        PathOperation.reverseDifference,
        Path()
          ..addOval(Rect.fromCircle(
              center: Offset(size.width * 0.5, 0), radius: cutoutRadius)),
        path);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TriangleClipper extends CustomClipper<Path> {
  final double triangleHeight;
  final double triangleWidth;
  final double borderRadius;

  const TriangleClipper({
    required this.triangleHeight,
    required this.triangleWidth,
    required this.borderRadius,
  });

  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(borderRadius, 0);
    path.lineTo(size.width - borderRadius, 0);
    path.arcToPoint(
      Offset(size.width, borderRadius),
      radius: Radius.circular(borderRadius),
    );
    path.lineTo(size.width, size.height - borderRadius - triangleHeight);
    path.arcToPoint(
      Offset(size.width - borderRadius, size.height - triangleHeight),
      radius: Radius.circular(borderRadius),
    );
    path.lineTo(
        (size.width * 0.5 + triangleWidth * 0.5), size.height - triangleHeight);
    path.lineTo(size.width * 0.5, size.height);
    path.lineTo(
        (size.width * 0.5 - triangleWidth * 0.5), size.height - triangleHeight);
    path.lineTo(borderRadius, size.height - triangleHeight);
    path.arcToPoint(
      Offset(0, size.height - borderRadius - triangleHeight),
      radius: Radius.circular(borderRadius),
    );
    path.lineTo(0, borderRadius);
    path.arcToPoint(
      Offset(borderRadius, 0),
      radius: Radius.circular(borderRadius),
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}

class EventContainer extends StatefulWidget {
  final EventData data;

  const EventContainer({Key? key, required this.data}) : super(key: key);

  @override
  State<EventContainer> createState() => _EventContainerState();
}

class _EventContainerState extends State<EventContainer> {
  int status = 0;
  bool expanded = false;
  late bool past;
  double stars = 0.0;

  String truncate() {
    if (!expanded) {
      if (widget.data.description.length > 150) {
        return widget.data.description.substring(0, 150);
      }
    }
    return widget.data.description;
  }

  @override
  void initState() {
    super.initState();
    past = DateTime.now().millisecondsSinceEpoch >=
        widget.data.date.millisecondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      width: 390.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: darkTheme ? neutral : fadedPrimary),
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Text(
              widget.data.header,
              style: context.textTheme.bodyLarge!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: 390.w,
            height: 200.h,
            child: Stack(children: [
              CachedNetworkImage(
                imageUrl: widget.data.cover,
                errorWidget: (context, url, error) => Container(
                  width: 390.w,
                  height: 200.h,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/error.jpeg"),
                        fit: BoxFit.fill),
                  ),
                ),
                progressIndicatorBuilder: (context, url, download) => Center(
                  child: CircularProgressIndicator(
                      color: appRed, value: download.progress),
                ),
                imageBuilder: (context, provider) => Container(
                  width: 390.w,
                  height: 200.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: provider, fit: BoxFit.cover),
                  ),
                ),
              ),
              Positioned(
                bottom: 20.h,
                left: 45.w,
                right: 45.w,
                child: GlassmorphicContainer(
                  width: 300.w,
                  height: 50.h,
                  borderRadius: 15.r,
                  blur: 10,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.withOpacity(0.1),
                      theme.withOpacity(0.05),
                    ],
                    stops: const [0.1, 1],
                  ),
                  borderGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.withOpacity(0.5),
                      theme.withOpacity(0.5),
                    ],
                  ),
                  border: 0,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 75.w,
                        child: Center(
                          child: Text(widget.data.location,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodySmall!
                                  .copyWith(color: theme)),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Container(
                        color: appRed,
                        width: 0.5.w,
                        height: 20.h,
                      ),
                      SizedBox(width: 10.w),
                      SizedBox(
                        width: 75.w,
                        child: Center(
                          child: Text(
                            formatDate(
                                DateFormat("dd/MM/yyyy")
                                    .format(widget.data.date),
                                shorten: true),
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmall!
                                .copyWith(color: theme),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Container(
                        color: appRed,
                        width: 0.5.w,
                        height: 20.h,
                      ),
                      SizedBox(width: 10.w),
                      SizedBox(
                        width: 75.w,
                        child: Center(
                          child: Text(
                            widget.data.time.format(context),
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmall!
                                .copyWith(color: theme),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 10.w,
                top: 10.h,
                child: past
                    ? GlassmorphicContainer(
                        borderRadius: 9.h,
                        border: 0,
                        blur: 10,
                        width: 45.w,
                        height: 18.h,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 2.h),
                        linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.withOpacity(0.1),
                            theme.withOpacity(0.05),
                          ],
                          stops: const [0.1, 1],
                        ),
                        borderGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.withOpacity(0.5),
                            theme.withOpacity(0.5),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Boxicons.bxs_star, color: appRed, size: 14.r),
                            SizedBox(width: 2.w),
                            Text(
                              widget.data.rating.toStringAsFixed(1),
                              style: context.textTheme.labelSmall!.copyWith(
                                  color: theme, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
              )
            ]),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 5.w,
                  children: [
                    Text(truncate(), style: context.textTheme.bodyMedium),
                    GestureDetector(
                      onTap: () => setState(() => expanded = !expanded),
                      child: Text(
                        expanded ? "Read Less" : "Read More",
                        style: context.textTheme.bodyMedium!
                            .copyWith(color: appRed),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                const BreakLine(),
                SizedBox(height: 10.h),
                past
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Rate",
                              style: context.textTheme.bodyLarge!
                                  .copyWith(fontWeight: FontWeight.w700)),
                          SizedBox(height: 5.h),
                          RatingStars(
                            value: stars,
                            onValueChanged: (val) =>
                                setState(() => stars = val),
                            starBuilder: (_, color) => Icon(Boxicons.bxs_star,
                                color: color, size: 16.r),
                            starCount: 5,
                            starSize: 20.r,
                            starColor: appRed,
                            starOffColor: neutral,
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            "Helping us rate this event will help other users decide whether to attend "
                            "future events hosted by the creator",
                            style: context.textTheme.bodySmall,
                          )
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(
                          3,
                          (index) => GestureDetector(
                            onTap: () => setState(() => status = index),
                            child: Container(
                              width: 100.w,
                              height: 40.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.h),
                                color: (index == status)
                                    ? appRed
                                    : Colors.transparent,
                                border: Border.all(
                                  color: (index == status)
                                      ? Colors.transparent
                                      : (darkTheme ? neutral3 : fadedPrimary),
                                ),
                              ),
                              child: Text(
                                index == 0
                                    ? "Interested"
                                    : (index == 1 ? "Going" : "Not Interested"),
                                style: context.textTheme.bodyMedium!.copyWith(
                                  color: (index == status)
                                      ? theme
                                      : (darkTheme
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
