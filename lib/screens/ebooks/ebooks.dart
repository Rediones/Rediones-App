// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:rediones/components/ebook_data.dart';
// import 'package:rediones/tools/constants.dart';
// import 'package:rediones/tools/widgets.dart';
// import 'package:rediones/services/ebook_service.dart';
//
// class EbooksPage extends StatefulWidget {
//
//   const EbooksPage({Key? key,}) : super(key: key);
//
//   @override
//   State<EbooksPage> createState() => _EbooksPageState();
// }
//
// class _EbooksPageState extends State<EbooksPage>
//     with SingleTickerProviderStateMixin {
//   final TextEditingController controller = TextEditingController();
//   late TabController tabController;
//
//   List<EbookData> forYou = [];
//   List<EbookData> trending = [];
//   List<EbookData> saved = [];
//
//   int stateOne = 0;
//   int stateTwo = 0;
//   int stateThree = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     tabController = TabController(length: 3, vsync: this);
//
//     getEbooks(type: 1).then((val) => setState(() {
//         forYou = val;
//         stateOne = 1;
//     }));
//
//     getEbooks(type: 2).then((val) => setState(() {
//       trending = val;
//       stateTwo = 1;
//     }));
//
//     getEbooks(type: 3).then((val) => setState(() {
//       saved = val;
//       stateThree = 1;
//     }));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: theme,
//         appBar: AppBar(
//             leading: IconButton(
//                 icon: Icon(Icons.chevron_left, color: primary, size: 26.r),
//                 onPressed: () => Navigator.pop(context)),
//             elevation: 0.0,
//             backgroundColor: theme,
//             title: SpecialForm(
//                 controller: controller,
//                 fillColor: neutral2,
//                 hint: "Search",
//                 border: Colors.transparent,
//                 prefix: IconButton(
//                   icon: Icon(Icons.search_rounded, size: 24.w, color: neutral3),
//                   onPressed: () {},
//                 ))),
//         body: SafeArea(
//             child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.w),
//           child: Column(children: [
//             TabBar(controller: tabController, tabs: [
//               Tab(
//                 child: Text("For You", style: normalText),
//               ),
//               Tab(
//                 child: Text("Trending", style: normalText),
//               ),
//               Tab(
//                 child: Text("Saved", style: normalText),
//               )
//             ]),
//             SizedBox(
//               height: 672.h,
//               width: 359.w,
//               child: TabBarView(controller: tabController, children: [
//                 stateOne == 0 ? const CenteredPopup() : Column(children: []),
//                 stateTwo == 0 ? const CenteredPopup() : Column(children: []),
//                 stateThree == 0 ? const CenteredPopup() : Column(children: []),
//               ]),
//             ),
//           ]),
//         )));
//   }
// }
//
// class EbookContainer extends StatelessWidget {
//   final EbookData data;
//
//   const EbookContainer({Key? key, required this.data}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(height: 55.h, child: Row(
//
//         children: [
//       ClipRRect(
//          borderRadius: BorderRadius.circular(6.r),
//           child: Image.asset("images/book.jpg",)),
//
//
//
//     ]));
//   }
// }
