import 'package:hedeyati/bloc/generic_bloc/generic_states.dart';

import '../../models/gift_category.dart';

abstract class GiftCategoryState extends ModelStates {
  @override
  List<Object?> get props => [];
}

class GiftCategoryToLocalDatabaseLoadedState extends GiftCategoryState {}

class GiftCategoryNameFromLocalDatabaseLoadedState extends GiftCategoryState {
  GiftCategoryNameFromLocalDatabaseLoadedState();
  @override
  List<Object?> get props => [];
}
