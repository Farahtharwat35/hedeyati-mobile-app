// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hedeyati/app/gift_page.dart';
// import 'package:hedeyati/app/app_theme.dart';
// import '../bloc/gifts/gift_bloc.dart';
// import '../bloc/gifts/gift_bloc_events.dart';
// import '../bloc/gifts/gift_bloc_states.dart';
//
//
// class GiftsListPage extends StatelessWidget {
//   const GiftsListPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Trigger loading gifts when the page is first built
//     BlocProvider.of<GiftBloc>(context).add(LoadGiftsEvent(0));
//
//     return Scaffold(
//       body: BlocBuilder<GiftBloc, GiftState>(
//         builder: (context, state) {
//           if (state is GiftsLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is GiftsLoaded) {
//             return ListView.builder(
//               padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
//               itemCount: state.gifts.length,
//               itemBuilder: (context, index) {
//                 final gift = state.gifts[index];
//                 return ListTile(
//                   title: Text("Gift ${index + 1}", style: myTheme.textTheme.headlineMedium),
//                   leading: Image.network(gift.imageUrl),
//                   trailing: Text(gift.price),
//                   onTap: () async {
//                     await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => GiftPage(giftIdx: index),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           } else if (state is GiftsError) {
//             return Center(child: Text(state.message));
//           } else {
//             return const Center(child: Text('No Gifts Available'));
//           }
//         },
//       ),
//       backgroundColor: myTheme.colorScheme.secondary,
//     );
//   }
// }
