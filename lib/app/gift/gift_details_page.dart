import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_crud_events.dart';
import 'package:hedeyati/bloc/gifts/gift_bloc.dart';
import 'package:hedeyati/bloc/gift_category/gift_category_bloc.dart';
import 'package:hedeyati/bloc/gift_category/gift_category_events.dart';
import 'package:hedeyati/bloc/gift_category/gift_category_states.dart';
import 'package:hedeyati/bloc/notification/notification_bloc.dart';
import 'package:hedeyati/bloc/user/user_event.dart';
import 'package:hedeyati/bloc/user/user_states.dart';
import 'package:hedeyati/models/gift.dart';
import 'package:hedeyati/shared/notification_types_enum.dart';
import 'package:intl/intl.dart';
import 'package:hedeyati/app/reusable_components/card_for_details.dart';
import '../../bloc/generic_bloc/generic_states.dart';
import '../../bloc/user/user_bloc.dart';
import '../reusable_components/card_for_details_text_style.dart';
import '../../models/notification.dart' as Notification;


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
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: giftCategoryBloc
              ..add(GetGiftCategoryNameByIDFromLocalDatabaseEvent(id: gift.categoryID)),
          ),
          BlocProvider(create: (_) => UserBloc()),
        ],
        child: BlocBuilder<GiftCategoryBloc, ModelStates>(
          builder: (context, state) {
            String categoryName = 'Unknown Category';
            if (state is GiftCategoryNameFromLocalDatabaseLoadedState) {
              categoryName = state.categoryName;
            } else if (state is ModelErrorState) {
              categoryName = 'Error Loading Category';
            }

            return BlocBuilder<UserBloc, ModelStates>(
              builder: (context, userState) {
                String pledgerName = '';
                if (userState is UserNameLoaded) {
                  pledgerName = userState.name;
                  NotificationBloc().add(
                    AddModel(Notification.Notification(
                      type: NotificationType.other,
                      title: 'Gift Pledged',
                      body: '$pledgerName has pledged your gift: "${gift.name}"',
                      initiatorID: userId,
                      receiverID: gift.firestoreUserID!,
                    )),
                  );
                  Navigator.pop(context);
                }
                List<Widget> content = [
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
                ];

                if (gift.isPledged) {
                  content.addAll([
                    Text(
                      'This gift is already pledged.',
                      style: getCardForDetailsTextStyle(),
                    ),
                    const SizedBox(height: 8),
                    // Text(
                    //   'Pledged by: $pledgerName',
                    //   style: getCardForDetailsTextStyle(),
                    // ),
                  ]);
                } else if (userId != gift.firestoreUserID) {
                  content.add(
                    ElevatedButton(
                      onPressed: () {
                        // Update gift to mark it pledged
                        giftBloc.add(
                          UpdateModel(
                            gift.copyWith(
                              id: gift.id,
                              isPledged: true,
                              pledgedBy: userId,
                            ),
                          ),
                        );
                        context.read<UserBloc>().add(GetUserName(userId: userId));
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
                    ),
                  );

                  // // Listen for user state and then send the notification
                  // context.read<UserBloc>().stream.listen((userState) {
                  //   log('User State: $userState');
                  //   if (userState is UserNameLoaded) {
                  //     pledgerName = userState.name;
                  //     NotificationBloc().add(
                  //       AddModel(Notification.Notification(
                  //         type: NotificationType.other,
                  //         title: 'Gift Pledged',
                  //         body: '$pledgerName has pledged your gift: "${gift.name}"',
                  //         initiatorID: userId,
                  //         receiverID: gift.firestoreUserID!,
                  //       )),
                  //     );
                  //     Navigator.pop(context);
                  //   }
                  // });
                }

                return buildDetailPage(
                  context: context,
                  title: gift.name,
                  subtitle: "",
                  widgetsAxisAlignment: CrossAxisAlignment.center,
                  content: content,
                );
              },
            );
          },
        ),
      );
    },
  );
}
