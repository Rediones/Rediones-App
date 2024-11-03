import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rediones/tools/constants.dart';

void showToast(String message, BuildContext context) {
  if (message.isEmpty || !context.mounted) return;

  HapticFeedback.vibrate();
  AnimatedSnackBar snackBar = AnimatedSnackBar(
    builder: (context) => ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 220.w,
      ),
      child: IntrinsicWidth(
        child: Container(
          constraints: BoxConstraints(
            minWidth: 60.w,
            minHeight: 35.h,
          ),
          decoration: BoxDecoration(
            color: appRed,
            borderRadius: BorderRadius.circular(5.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          alignment: Alignment.center,
          child: Text(
            message,
            style: context.textTheme.bodyMedium!.copyWith(
              color: theme,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ),
    mobileSnackBarPosition: MobileSnackBarPosition.top,
    mobilePositionSettings: const MobilePositionSettings(topOnAppearance: 100),
    animationCurve: Curves.ease,
    snackBarStrategy: const ColumnSnackBarStrategy(),
    duration: const Duration(seconds: 1),
    animationDuration: const Duration(milliseconds: 350),
  );
  snackBar.show(context);
}

void unFocus() => FocusManager.instance.primaryFocus?.unfocus();

String formatRawAmount(int price) => formatAmount(price.toString());

String formatAmount(String price) {
  String priceInText = "";
  int counter = 0;
  for (int i = (price.length - 1); i >= 0; i--) {
    counter++;
    String str = price[i];
    if ((counter % 3) != 0 && i != 0) {
      priceInText = "$str$priceInText";
    } else if (i == 0) {
      priceInText = "$str$priceInText";
    } else {
      priceInText = ",$str$priceInText";
    }
  }
  return priceInText.trim();
}

String format(double val) =>
    val.toStringAsFixed(val.truncateToDouble() == val ? 0 : 2);

String formatDate(String dateTime, {bool shorten = false}) {
  int firIndex = dateTime.indexOf("/");
  String d = dateTime.substring(0, firIndex);
  int secIndex = dateTime.indexOf("/", firIndex + 1);
  String m = dateTime.substring(firIndex + 1, secIndex);
  String y = dateTime.substring(secIndex + 1);

  return "${month(m, shorten)} ${day(d)}, $y";
}

String formatTime(DateTime dateTime) {
  int hr = dateTime.hour;
  int min = dateTime.minute;

  return "${hr > 12 ? hr % 12 : (hr == 12 || hr == 0) ? "12" : hr}:$min ${hr > 12 ? "pm" : "am"}";
}

String formatDuration(Duration duration) {
  String twoDigits(int n) =>
      n >= 10 ? "$n" : "0$n"; // Helper function to pad single digits with zero

  String formattedDuration = "";
  if (duration.inHours > 0) {
    formattedDuration += "${twoDigits(duration.inHours)}:";
  }
  formattedDuration +=
      "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";

  return formattedDuration;
}

String month(String val, bool shorten) {
  int month = int.parse(val);
  switch (month) {
    case 1:
      return shorten ? "Jan" : "January";
    case 2:
      return shorten ? "Feb" : "February";
    case 3:
      return shorten ? "Mar" : "March";
    case 4:
      return shorten ? "Apr" : "April";
    case 5:
      return "May";
    case 6:
      return shorten ? "Jun" : "June";
    case 7:
      return shorten ? "Jul" : "July";
    case 8:
      return shorten ? "Aug" : "August";
    case 9:
      return shorten ? "Sep" : "September";
    case 10:
      return shorten ? "Oct" : "October";
    case 11:
      return shorten ? "Nov" : "November";
    default:
      return shorten ? "Dec" : "December";
  }
}

String day(String val) {
  int day = int.parse(val);
  int remainder = day % 10;
  switch (remainder) {
    case 1:
      return (day == 11) ? "${day}th" : "${day}st";
    case 2:
      return (day == 12) ? "${day}th" : "${day}nd";
    case 3:
      return (day == 13) ? "${day}th" : "${day}rd";
    default:
      return "${day}th";
  }
}

int fastHash(String string) {
  var hash = 0xcbf29ce484222325;
  int i = 0;
  while (i < string.length) {
    final codeUnit = string.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }
  return hash;
}

bool validateForm(GlobalKey<FormState> formKey) {
  unFocus();
  FormState? currentState = formKey.currentState;
  if (currentState != null) {
    if (!currentState.validate()) return false;

    currentState.save();
    return true;
  }
  return false;
}

List<String> toStringList(List<dynamic> data) {
  List<String> result = [];
  for (var element in data) {
    result.add(element as String);
  }
  return result;
}
