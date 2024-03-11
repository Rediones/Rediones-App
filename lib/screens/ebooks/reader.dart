// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pdfx/pdfx.dart';
// import 'package:rediones/api/file_handler.dart';
// import 'package:rediones/tools/constants.dart';
//
// class ReaderPage extends StatefulWidget
// {
//   final String encodedData;
//   const ReaderPage({Key? key, required this.encodedData}) : super(key: key);
//
//   @override
//   State<ReaderPage> createState() => _ReaderPageState();
// }
//
// class _ReaderPageState extends State<ReaderPage> {
//   late List<Uint8List> data;
//   late PdfControllerPinch _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     data = FileHandler.convertToData([widget.encodedData]);
//     _controller = PdfControllerPinch(document: PdfDocument.openData(data[0]));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: theme,
//       body: SafeArea(
//           child: Padding(
//             padding: EdgeInsets.symmetric(
//                 horizontal: 10.w, vertical: 5.h),
//             child: SizedBox(
//                 width: 390.w,
//                 height: 840.h,
//                 child: PdfViewPinch(controller: _controller)),
//           ),),
//     );
//   }
// }
