import 'package:hedeyati/bloc/generic_bloc/generic_states.dart';


abstract class GiftCategoryState extends ModelStates {
  @override
  List<Object?> get props => [];
}

class GiftCategoryToLocalDatabaseLoadedState extends GiftCategoryState {}

class GiftCategoryNameFromLocalDatabaseLoadedState extends GiftCategoryState {
  GiftCategoryNameFromLocalDatabaseLoadedState(this.categoryName);

  final String categoryName;

  @override
  List<Object?> get props => [categoryName];
}

