// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hedeyati/app/gifts_list_page.dart';
// import '../bloc/gifts/gift_bloc.dart';
//
// class MyTabBarFriendList extends StatelessWidget {
//
//   const MyTabBarFriendList({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       initialIndex: 0,
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title:  Padding(
//             padding: EdgeInsets.fromLTRB(15,0,70,0),
//             child: Center(child: Text("Gifts List")),
//           ),
//         ),
//         body: TabBarView(
//           children: <Widget>[
//             NestedTabBarFriendList('All Gifts'),
//             NestedTabBarFriendList('Pleedged Gifts'),
//             NestedTabBarFriendList('Unpleedged Gifts'),
//             // NestedTabBar('Explore'),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class NestedTabBarFriendList extends StatefulWidget {
//   const NestedTabBarFriendList(this.outerTab, {super.key});
//
//   final String outerTab;
//
//   @override
//   State<NestedTabBarFriendList> createState() => _NestedTabBarState();
// }
//
// class _NestedTabBarState extends State<NestedTabBarFriendList> with TickerProviderStateMixin {
//   late final TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           TabBar(
//             controller: _tabController,
//             tabs: const <Widget>[
//               Tab(text: 'All', icon: Icon(Icons.all_out)),
//               Tab(text: 'Pledged', icon: Icon(Icons.favorite)),
//               Tab(text: 'Unpledged', icon: Icon(Icons.remove_done)),
//             ],
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: <Widget>[
//                 BlocProvider(
//                   create: (context) => GiftBloc(),
//                   child: GiftsListPage(),
//                 ), // All gifts
//                 BlocProvider(
//                   create: (context) => GiftBloc(),
//                   child: GiftsListPage(),
//                 ),
//                 BlocProvider(
//                   create: (context) => GiftBloc(),
//                   child: GiftsListPage(),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
