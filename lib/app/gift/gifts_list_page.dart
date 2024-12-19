import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:async_builder/async_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/app/gift/edit_gift_page.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_states.dart';
import 'package:hedeyati/bloc/gift_category/gift_category_bloc.dart';
import 'package:provider/provider.dart';
import '../../bloc/events/event_bloc.dart';
import '../../bloc/gifts/gift_bloc.dart';
import '../../models/event.dart';
import '../../models/gift.dart';
import '../../app/reusable_components/app_theme.dart';
import '../../app/reusable_components/build_card.dart';
import '../../models/model.dart';
import 'gift_details_page.dart';

class GiftListPage extends StatefulWidget {
  final Model event;
  final EventBloc eventBloc;

  const GiftListPage({super.key, required this.event, required this.eventBloc});

  @override
  _GiftListPageState createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  late Stream<List<Gift>> _giftStreams;
  late GiftBloc giftBloc;
  late GiftCategoryBloc giftCategoryBloc;

  @override
  void initState() {
    super.initState();
    giftBloc = context.read<GiftBloc>();
    giftCategoryBloc = context.read<GiftCategoryBloc>();
    _giftStreams = giftBloc.giftsStream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gifts'),
        titleTextStyle: myTheme.textTheme.headlineMedium,
        backgroundColor: myTheme.colorScheme.primary,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: AsyncBuilder<List<Gift>>(
              stream: _giftStreams,
              waiting: (context) =>
                  const Center(child: CircularProgressIndicator()),
              error: (context, error, stack) {
                debugPrint('Error: $error');
                debugPrint('Stack Trace: $stack');
                return Center(
                  child: Text('Error: $error'),
                );
              },
              builder: (context, gifts) {
                List<Widget> content = [];
                content.add(Center(
                  child: Text(
                    'Gifts for this Event',
                    style: myTheme.textTheme.headlineMedium,
                  ),
                ));
                content.add(const SizedBox(height: 16));
                if (gifts == null || gifts.isEmpty) {
                  content.add(const Center(child: Text('No gifts found.')));
                } else {
                  content.addAll(
                    gifts
                        .map((gift) => _buildGiftTile(
                            context, gift, widget.event as Event))
                        .toList(),
                  );
                }
                return buildCard(context, content);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGiftTile(BuildContext context, Gift gift, Event event) {
    return BlocBuilder<GiftCategoryBloc, ModelStates>(
      builder: (context, state) {
        return ListTile(
          title: Text(
            gift.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            "${gift.price} USD",
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              gift.firestoreUserID == FirebaseAuth.instance.currentUser!.uid ? IconButton(
                icon: const Icon(Icons.edit, color: Colors.pinkAccent),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: giftBloc),
                          BlocProvider.value(value: giftCategoryBloc),
                          BlocProvider.value(value: widget.eventBloc)
                        ],
                        child: EditGift(
                            gift: gift,
                            giftBloc: giftBloc,
                            giftCategoryBloc: giftCategoryBloc,
                            eventBloc: EventBloc(),
                        ),
                      ),
                    ),
                  );
                },
              ): const SizedBox(),
              IconButton(
                icon:
                    const Icon(Icons.remove_red_eye, color: Colors.pinkAccent),
                onPressed: () {
                  showGiftDetails(
                    context,
                    gift,
                    context.read<GiftBloc>(),
                    context.read<GiftCategoryBloc>(),
                    FirebaseAuth.instance.currentUser!.uid,
                    event.eventDate,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
