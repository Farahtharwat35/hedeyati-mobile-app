import 'package:flutter/material.dart';
import 'package:async_builder/async_builder.dart';
import '../../bloc/gifts/gift_bloc.dart';
import '../../models/gift.dart';
import '../../app/reusable_components/app_theme.dart';
import '../../app/reusable_components/build_card.dart';

class GiftListPage extends StatefulWidget {
  final String? eventID;

  const GiftListPage({super.key, required this.eventID});

  @override
  _GiftListPageState createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  late Stream<List<Gift>> _giftStreams;
  late GiftBloc giftBloc;

  @override
  void initState() {
    super.initState();
    giftBloc = GiftBloc(eventID: widget.eventID); // Pass eventID here
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
              waiting: (context) => const Center(child: CircularProgressIndicator()),
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
                    gifts.map((gift) => _buildGiftTile(context, gift)).toList(),
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

  Widget _buildGiftTile(BuildContext context, Gift gift) {
    return ListTile(
      title: Text(
        gift.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        "${gift.price} USD", // You can format price as needed
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.pinkAccent),
            onPressed: () {
              // Uncomment and navigate to your Edit Gift page
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => EditGift(gift: gift, giftBloc: giftBloc),
              //   ),
              // );
            },
          ),
          IconButton(
            icon: const Icon(Icons.remove_red_eye, color: Colors.pinkAccent),
            onPressed: () {
              // Uncomment this to show gift details
              // showGiftDetails(context, gift);
            },
          ),
        ],
      ),
      onTap: () {
        // Uncomment to navigate to the gift details page
        // Navigator.push(context, MaterialPageRoute(builder: (context) => GiftDetails(gift: gift)));
      },
    );
  }
}
