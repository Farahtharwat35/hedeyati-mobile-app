import 'package:hedeyati/bloc/generic_bloc/generic_states.dart';

abstract class GiftCategoryState extends ModelStates {
  @override
  List<Object?> get props => [];
}

class GiftCategoryToLocalDatabaseLoadedState extends GiftCategoryState {}

