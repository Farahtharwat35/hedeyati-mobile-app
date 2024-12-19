import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_crud_events.dart';
import 'package:hedeyati/bloc/gifts/gift_bloc.dart';
import 'package:hedeyati/bloc/gift_category/gift_category_bloc.dart';
import 'package:hedeyati/bloc/gift_category/gift_category_events.dart';
import 'package:hedeyati/bloc/gift_category/gift_category_states.dart';
import 'package:hedeyati/bloc/user/user_event.dart';
import 'package:hedeyati/bloc/user/user_states.dart';
import 'package:hedeyati/models/gift.dart';
import 'package:intl/intl.dart';
import 'package:hedeyati/app/reusable_components/card_for_details.dart';
import '../../bloc/generic_bloc/generic_states.dart';
import '../../bloc/user/user_bloc.dart';
import '../reusable_components/card_for_details_text_style.dart';

void showGiftDetails(
    BuildContext context,
    Gift gift,
    GiftBloc giftBloc,
    GiftCategoryBloc giftCategoryBloc,
    String userId,
    DateTime dueDate,
    ) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return BlocProvider.value(
        value: giftCategoryBloc..add(GetGiftCategoryNameByIDFromLocalDatabaseEvent(id: gift.categoryID)),
        child: BlocProvider(
          create: (_) => UserBloc(),
          child: BlocBuilder<GiftCategoryBloc, ModelStates>(
            builder: (context, state) {
              // Load user information
              context.read<UserBloc>().add(GetUserName(userId: gift.pledgedBy!));

              String categoryName = 'Unknown Category';
              if (state is GiftCategoryNameFromLocalDatabaseLoadedState) {
                categoryName = state.categoryName;
              } else if (state is ModelErrorState) {
                categoryName = 'Error Loading Category';
              }

              // Access user state and build UI accordingly
              return BlocBuilder<UserBloc, ModelStates>(
                builder: (context, userState) {
                  if (userState is ModelInitState || userState is ModelLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  else if (userState is ModelErrorState) {
                    return const Center(child: Text('Error loading gift details'));
                  }
                  String pledgerName = (userState as UserNameLoaded).name;
                  return buildDetailPage(
                    context: context,
                    title: gift.name,
                    subtitle: "",
                    widgetsAxisAlignment: CrossAxisAlignment.center,
                    content: [
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          gift.description.isNotEmpty
                              ? gift.description
                              : 'No description available',
                          style: getCardForDetailsTextStyle(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          'Category: $categoryName',
                          style: getCardForDetailsTextStyle(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          'Due To: ${DateFormat("dd/MM/yyyy").format(dueDate)}',
                          style: getCardForDetailsTextStyle(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (gift.isPledged)
                        Column(
                          children: [
                            Text(
                              'This gift is already pledged.',
                              style: getCardForDetailsTextStyle(),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Pledged by: $pledgerName',
                              style: getCardForDetailsTextStyle(),
                            ),
                          ],
                        )
                      else if (userId != gift.firestoreUserID)
                        ElevatedButton(
                          onPressed: () {
                            giftBloc.add(
                              UpdateModel(
                                gift.copyWith(
                                  id: gift.id,
                                  isPledged: true,
                                  pledgedBy: userId,
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Pledge Gift',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        )
                      else
                        const SizedBox(height: 0),
                    ],
                  );
                },
              );
            },
          ),
        ),
      );
    },
  );
}
