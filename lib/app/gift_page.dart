import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:hedeyati/app/app_theme.dart';

import '../bloc/gifts/gift_bloc.dart';
import '../bloc/gifts/gift_bloc_events.dart';
import '../bloc/gifts/gift_bloc_states.dart';

class GiftPage extends StatefulWidget {
  final int giftIdx;
  GiftPage({super.key, required this.giftIdx});

  @override
  _GiftPageState createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {
  DateTime? selectedDate;
  bool isPledged = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        isPledged = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final giftBloc = BlocProvider.of<GiftBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 70, 0),
          child: Center(child: Text('Gift Details')),
        ),
      ),
      body: BlocBuilder<GiftBloc, GiftState>(
        builder: (context, state) {
          if (state is GiftsLoaded) {
            final gift = state.gifts[widget.giftIdx];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      gift.imageUrl,
                      height: 200,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Gift Description',
                      style: myTheme.textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'This is a wonderful gift that you can pledge for your loved one.',
                      style: myTheme.textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Price: ${gift.price}',
                    style: myTheme.textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPledged ? Colors.pink.shade100 : Colors.pink,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: isPledged
                          ? null
                          : () {
                        _selectDate(context);
                        giftBloc.add(PledgeGiftEvent(gift));
                      },
                      child: Text(
                        isPledged
                            ? 'Pledged on ${DateFormat('yyyy-MM-dd').format(selectedDate!)}'
                            : 'Pledge',
                        style: const TextStyle(color: Colors.black, fontFamily: "Times New Roman"),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      backgroundColor: myTheme.colorScheme.secondary,
    );
  }
}
