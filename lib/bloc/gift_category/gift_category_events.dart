
import '../generic_bloc/generic_crud_events.dart';


abstract class GiftCategoryEvent extends GenericCRUDEvents {
  @override
  List<Object?> get props => [];
}

class LoadGiftCategoriesEventToLocalDatabase extends GiftCategoryEvent {}

class GetGiftCategoryNameByIDFromLocalDatabaseEvent extends GiftCategoryEvent {
  GetGiftCategoryNameByIDFromLocalDatabaseEvent(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class GetAllGiftCategoriesEvent extends GiftCategoryEvent {}

